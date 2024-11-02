part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

final class RateOrderEvent extends OrderEvent {
  final int rating;
  RateOrderEvent({required this.rating});
}
