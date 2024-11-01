part of 'admin_orders_cubit.dart';

@immutable
sealed class AdminOrdersState {}

final class AdminOrdersInitial extends AdminOrdersState {}

final class OrdersLoadingState extends AdminOrdersState {}

final class OrdersLoadedState extends AdminOrdersState {
}

final class ErrorState extends AdminOrdersState {
  final String message;
  ErrorState(this.message);
}