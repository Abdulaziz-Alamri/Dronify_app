part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class RateOrderState extends OrderState {
  final int rating;
  RateOrderState({required this.rating});
}
