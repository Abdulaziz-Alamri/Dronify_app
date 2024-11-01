import 'dart:developer';
import 'package:dronify_mngmt/Admin/admin_datalayer/admin_data_layer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'orders_bloc_event.dart';
import 'orders_bloc_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final AdminDataLayer dataLayer; // تعريف AdminDataLayer

  OrdersBloc({required this.dataLayer}) : super(OrderLoading()) {
    on<FetchOrders>(_onFetchOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
  }

  Future<void> _onFetchOrders(
      FetchOrders event, Emitter<OrdersState> emit) async {
    try {
      emit(OrderLoading());
      await dataLayer.fetchOrders();

      emit(OrderLoaded(
        completeOrders: dataLayer.empCompleteOrders,
        incompleteOrders: dataLayer.empIncompleteOrders,
        availableOrders: dataLayer.empAvailableOrders,
        isCompleteOrdersEmpty: dataLayer.empCompleteOrders.isEmpty,
        isIncompleteOrdersEmpty: dataLayer.empIncompleteOrders.isEmpty,
        isAvailableOrdersEmpty: dataLayer.empAvailableOrders.isEmpty,
      ));
    } catch (error) {
      log('Error: $error');
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

      add(FetchOrders());
    } catch (error) {
      emit(OrderError(message: "Failed to update order status: $error"));
    }
  }
}
