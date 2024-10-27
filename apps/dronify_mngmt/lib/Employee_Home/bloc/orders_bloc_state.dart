import 'package:equatable/equatable.dart';

abstract class OrdersState {}

class OrderLoading extends OrdersState {}

class OrderLoaded extends OrdersState {
  final List<dynamic> completeOrders;
  final List<dynamic> incompleteOrders;
  final List<dynamic> availableOrders;
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
