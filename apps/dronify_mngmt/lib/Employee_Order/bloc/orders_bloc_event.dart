import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class FetchOrders extends OrdersEvent {}

class UpdateOrderStatus extends OrdersEvent {
  final int orderId;
  final String newStatus;

  const UpdateOrderStatus({required this.orderId, required this.newStatus});

  @override
  List<Object> get props => [orderId, newStatus];
}

class FetchOrderById extends OrdersEvent {
  final int orderId;

  const FetchOrderById({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

class UploadOrderImage extends OrdersEvent {
  final int orderId;
  final String imagePath;

  const UploadOrderImage({required this.orderId, required this.imagePath});

  @override
  List<Object> get props => [orderId, imagePath];
}

class UpdateOrderDescription extends OrdersEvent {
  final int orderId;
  final String description;

  const UpdateOrderDescription({required this.orderId, required this.description});

  @override
  List<Object> get props => [orderId, description];
}
