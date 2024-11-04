import 'package:dronify_mngmt/Admin/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/utils/db_operations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'orders_bloc_event.dart';
import 'orders_bloc_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final AdminDataLayer dataLayer;

  OrdersBloc({required this.dataLayer}) : super(OrderLoading()) {
    on<FetchOrders>(_onFetchOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
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

      await supabase.from('orders').update({
        'employee_id': event.employeeId,
        'status': event.newStatus
      }).eq('order_id', event.orderId);

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
