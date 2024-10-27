import 'package:flutter_bloc/flutter_bloc.dart';
import 'orders_bloc_event.dart';
import 'orders_bloc_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrderLoading()) {
    on<FetchOrders>(_onFetchOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<FetchOrderById>(_onFetchOrderById);
    on<UploadOrderImage>(_onUploadOrderImage);
    on<UpdateOrderDescription>(_onUpdateOrderDescription);
  }

  Future<void> _onFetchOrders(FetchOrders event, Emitter<OrdersState> emit) async {
    try {
      emit(OrderLoading());

      final completeOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name,description)')
          .eq('status', 'complete');
      final incompleteOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name,description)')
          .eq('status', 'confirmed');
      final availableOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name,description)')
          .eq('status', 'pending');

      emit(OrderLoaded(
        completeOrders: completeOrdersResponse as List<dynamic>,
        incompleteOrders: incompleteOrdersResponse as List<dynamic>,
        availableOrders: availableOrdersResponse as List<dynamic>,
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

      add(FetchOrders());
    } catch (error) {
      emit(OrderError(message: "Failed to update order status: $error"));
    }
  }

  Future<void> _onFetchOrderById(FetchOrderById event, Emitter<OrdersState> emit) async {
    try {
      emit(OrderLoading());

      final orderResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name,description)')
          .eq('order_id', event.orderId)
          .single();

      if (orderResponse != null) {
        emit(OrderDetailLoaded(order: orderResponse as Map<String, dynamic>));
      } else {
        emit(OrderError(message: "Order not found"));
      }
    } catch (error) {
      emit(OrderError(message: "Failed to fetch order details: $error"));
    }
  }

  Future<void> _onUploadOrderImage(UploadOrderImage event, Emitter<OrdersState> emit) async {
    if (state is OrderDetailLoaded) {
      final currentOrder = (state as OrderDetailLoaded).order;

      try {
        // بعد تحميل الصورة بنجاح، تحديث الحالة لعرض الصورة في الواجهة
        emit(OrderDetailLoaded(order: currentOrder, imagePath: event.imagePath));
      } catch (error) {
        emit(OrderError(message: "Failed to upload image: $error"));
      }
    }
  }

  Future<void> _onUpdateOrderDescription(UpdateOrderDescription event, Emitter<OrdersState> emit) async {
    try {
      await supabase
          .from('orders')
          .update({'description': event.description})
          .eq('order_id', event.orderId);

      add(FetchOrderById(orderId: event.orderId));
    } catch (error) {
      emit(OrderError(message: "Failed to update order description: $error"));
    }
  }
}
