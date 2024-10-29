import 'package:equatable/equatable.dart';
import 'package:dronify/models/cart_model.dart';

abstract class CartState extends Equatable {
  const CartState();
  
  @override
  List<Object?> get props => [];
}

class CartLoading extends CartState {}

class CartUpdated extends CartState {
  final CartModel cart;
  const CartUpdated({required this.cart});
  
  @override
  List<Object?> get props => [cart];
}

class CartSubmitted extends CartState {
  final CartModel cart;
  const CartSubmitted({required this.cart});
  
  @override
  List<Object?> get props => [cart];
}
