import 'package:bloc/bloc.dart';
import 'package:dronify_mngmt/Admin/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:dronify_mngmt/utils/setup.dart';
import 'package:meta/meta.dart';

part 'admin_orders_state.dart';

class AdminOrdersCubit extends Cubit<AdminOrdersState> {
  List<OrderModel> completeOrders = [];
  List<OrderModel> incompleteOrders = [];
  List<OrderModel> availableOrders = [];
  AdminOrdersCubit() : super(AdminOrdersInitial());

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
}
