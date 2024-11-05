import 'package:bloc/bloc.dart';
import 'package:dronify_mngmt/Admin_Screens/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:dronify_mngmt/utils/db_operations.dart';
import 'package:dronify_mngmt/utils/setup.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'admin_orders_state.dart';

class AdminOrdersCubit extends Cubit<AdminOrdersState> {
  late final RealtimeChannel channel;
  List<OrderModel> completeOrders = [];
  List<OrderModel> incompleteOrders = [];
  List<OrderModel> availableOrders = [];

  AdminOrdersCubit() : super(AdminOrdersInitial()) {
    initializeListener();
  }

  void initializeListener() {
    channel = supabase
        .channel('public:orders')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'orders',
          callback: (payload) async {
            final newOrder = OrderModel.fromJson(payload.newRecord);
            loadNewOrder();
            emit(OrderInsertedState(newOrder));
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'orders',
          callback: (payload) async {
            final updatedOrder = OrderModel.fromJson(payload.newRecord);
            updateOrderLists(updatedOrder);
            emit(OrderUpdatedState(updatedOrder));
          },
        )
        .subscribe();
  }

  Future<void> loadOrders() async {
    emit(OrdersLoadingState());
    try {
      await locator.get<AdminDataLayer>().fetchOrders();
      completeOrders = locator.get<AdminDataLayer>().completeOrders;
      incompleteOrders = locator.get<AdminDataLayer>().incompleteOrders;
      availableOrders = locator.get<AdminDataLayer>().availableOrders;
      emit(OrdersLoadedState());
    } catch (e) {
      emit(ErrorState('Failed to load orders'));
    }
  }

  Future<void> loadNewOrder() async {
    emit(OrdersLoadingState());
    try {
      availableOrders.clear();
      final availableOrdersResponse = await supabase
          .from('orders')
          .select(
              '*, app_user!inner(name, phone), service(name), images(image_url, type), address(latitude, longitude)')
          .eq('status', 'pending');

      for (var element in availableOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        availableOrders.add(order);
      }
      emit(OrdersLoadedState());
    } catch (e) {
      emit(ErrorState('Failed to load new orders'));
    }
  }

  void updateOrderLists(OrderModel updatedOrder) async {
    try {
      if (updatedOrder.status == 'complete') {
        completeOrders.clear();
        final completeOrdersResponse = await supabase
            .from('orders')
            .select(
                '*, app_user!inner(name, phone), service(name), images(image_url, type), address(latitude, longitude)')
            .eq('status', 'complete');

        for (var element in completeOrdersResponse) {
          OrderModel order = OrderModel.fromJson(element);
          completeOrders.add(order);
        }
        incompleteOrders
            .removeWhere((order) => order.orderId == updatedOrder.orderId);
      } else if (updatedOrder.status == 'confirmed') {
        incompleteOrders.clear();
        final incompleteOrdersResponse = await supabase
            .from('orders')
            .select(
                '*, app_user!inner(name, phone), service(name), images(image_url, type), address(latitude, longitude)')
            .eq('status', 'confirmed');

        for (var element in incompleteOrdersResponse) {
          OrderModel order = OrderModel.fromJson(element);
          incompleteOrders.add(order);
        }
        availableOrders
            .removeWhere((order) => order.orderId == updatedOrder.orderId);
      }
      emit(OrdersLoadedState());
    } catch (e) {
      emit(ErrorState('Failed to load updated orders'));
    }
  }
}
