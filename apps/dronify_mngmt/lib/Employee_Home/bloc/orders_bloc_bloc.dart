import 'package:dronify_mngmt/Admin/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/utils/db_operations.dart';
import 'package:dronify_mngmt/utils/notification.dart';
import 'package:dronify_mngmt/utils/setup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'orders_bloc_event.dart';
import 'orders_bloc_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final AdminDataLayer dataLayer;
  late final RealtimeChannel channel;

  OrdersBloc({required this.dataLayer}) : super(OrderLoading()) {
    on<FetchOrders>(_onFetchOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);

    initializeListener();
  }

  void initializeListener() {
    supabase
        .channel('public:orders')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'orders',
          callback: (payload) async {
            if (locator.get<AdminDataLayer>().externalKey != null) {
              sendAvailableOrderNotification(
                  externalKey: locator.get<AdminDataLayer>().externalKey!);
              add(FetchOrders());
            }
          },
        )
        .subscribe();
  }

  Future<void> _onFetchOrders(
      FetchOrders event, Emitter<OrdersState> emit) async {
    try {
      emit(OrderLoading());
      await dataLayer.fetchEmpOrders();

      emit(OrderLoaded(
        completeOrders: dataLayer.empCompleteOrders,
        incompleteOrders: dataLayer.empIncompleteOrders,
        availableOrders: dataLayer.empAvailableOrders,
        isCompleteOrdersEmpty: dataLayer.empCompleteOrders.isEmpty,
        isIncompleteOrdersEmpty: dataLayer.empIncompleteOrders.isEmpty,
        isAvailableOrdersEmpty: dataLayer.empAvailableOrders.isEmpty,
      ));
    } catch (error) {
      emit(OrderError(message: "Error fetching orders: $error"));
    }
  }

  Future<void> _onUpdateOrderStatus(
      UpdateOrderStatus event, Emitter<OrdersState> emit) async {
    try {
      emit(OrderLoading());

      await setOrderConfrimed(
          employeeId: event.employeeId,
          newStatus: event.newStatus,
          orderId: event.orderId);

      await dataLayer.fetchEmpOrders();

      emit(OrderLoaded(
        completeOrders: dataLayer.empCompleteOrders,
        incompleteOrders: dataLayer.empIncompleteOrders,
        availableOrders: dataLayer.empAvailableOrders,
        isCompleteOrdersEmpty: dataLayer.empCompleteOrders.isEmpty,
        isIncompleteOrdersEmpty: dataLayer.empIncompleteOrders.isEmpty,
        isAvailableOrdersEmpty: dataLayer.empAvailableOrders.isEmpty,
      ));
    } catch (error) {
      emit(OrderError(message: "Failed to update order status: $error"));
    }
  }
}
