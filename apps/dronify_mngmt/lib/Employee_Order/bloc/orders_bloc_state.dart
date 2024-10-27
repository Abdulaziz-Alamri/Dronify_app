import 'package:equatable/equatable.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrderLoading extends OrdersState {}

class OrderLoaded extends OrdersState {
  final List<dynamic> completeOrders;
  final List<dynamic> incompleteOrders;
  final List<dynamic> availableOrders;

  const OrderLoaded({
    required this.completeOrders,
    required this.incompleteOrders,
    required this.availableOrders,
  });

  @override
  List<Object> get props => [completeOrders, incompleteOrders, availableOrders];
}

class OrderDetailLoaded extends OrdersState {
  final Map<String, dynamic> order;
  final String? imagePath;

  const OrderDetailLoaded({required this.order, this.imagePath});

  @override
  List<Object?> get props => [order, imagePath];
}

class OrderError extends OrdersState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object> get props => [message];
}
