import 'package:dronify_mngmt/models/order_model.dart';
import 'package:equatable/equatable.dart';

abstract class OrdersState {}

class OrderLoading extends OrdersState {}

class OrderLoaded extends OrdersState {
  final List<OrderModel> completeOrders;
  final List<OrderModel> incompleteOrders;
  final List<OrderModel> availableOrders;
  final bool isCompleteOrdersEmpty;
  final bool isIncompleteOrdersEmpty;
  final bool isAvailableOrdersEmpty;

  OrderLoaded({
    required this.completeOrders,
    required this.incompleteOrders,
    required this.availableOrders,
    this.isCompleteOrdersEmpty = false,
    this.isIncompleteOrdersEmpty = false,
    this.isAvailableOrdersEmpty = false,
  });
}

class OrderError extends OrdersState {
  final String message;

  OrderError({required this.message});
}

  