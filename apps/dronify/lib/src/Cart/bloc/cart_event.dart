import 'package:equatable/equatable.dart';
import 'package:dronify/models/order_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadCartItemsEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final OrderModel order;
  const AddToCartEvent(this.order);
  
  @override
  List<Object?> get props => [order];
}

class RemoveFromCartEvent extends CartEvent {
  final int orderId;
  const RemoveFromCartEvent(this.orderId);
  
  @override
  List<Object?> get props => [orderId];
}

class SubmitCart extends CartEvent {}
