import 'package:flutter_bloc/flutter_bloc.dart';
import 'orders_bloc_event.dart';
import 'orders_bloc_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrderLoading()) {
    on<FetchOrders>(_onFetchOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
  }

  Future<void> _onFetchOrders(FetchOrders event, Emitter<OrdersState> emit) async {
    try {
      emit(OrderLoading());

      final completeOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name, description)')
          .eq('status', 'complete');
      final incompleteOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name, description)')
          .eq('status', 'confirmed');
      final availableOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name, description)')
          .eq('status', 'pending');

      emit(OrderLoaded(
        completeOrders: completeOrdersResponse as List<dynamic>,
        incompleteOrders: incompleteOrdersResponse as List<dynamic>,
        availableOrders: availableOrdersResponse as List<dynamic>,
        isCompleteOrdersEmpty: completeOrdersResponse.isEmpty,
        isIncompleteOrdersEmpty: incompleteOrdersResponse.isEmpty,
        isAvailableOrdersEmpty: availableOrdersResponse.isEmpty,
      ));
    } catch (error) {
      emit(OrderError(message: "Error fetching orders: $error"));
    }
  }

  Future<void> _onUpdateOrderStatus(UpdateOrderStatus event, Emitter<OrdersState> emit) async {
    try {
      emit(OrderLoading());

      await supabase
          .from('orders')
          .update({'status': event.newStatus})
          .eq('order_id', event.orderId);

      add(FetchOrders()); // إعادة تحميل الطلبات بعد تحديث الحالة
    } catch (error) {
      emit(OrderError(message: "Failed to update order status: $error"));
    }
  }
}
