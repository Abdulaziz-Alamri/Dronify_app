import 'package:equatable/equatable.dart';

abstract class OrdersEvent {}

class FetchOrders extends OrdersEvent {}

class UpdateOrderStatus extends OrdersEvent {
  final int orderId;
  final String newStatus;
  final String employeeId;

  UpdateOrderStatus({required this.orderId, required this.newStatus, required this.employeeId});
}
