part of 'admin_orders_cubit.dart';

@immutable
sealed class AdminOrdersState {}

final class AdminOrdersInitial extends AdminOrdersState {}

final class OrdersLoadingState extends AdminOrdersState {}

final class OrdersLoadedState extends AdminOrdersState {}

final class ErrorState extends AdminOrdersState {
  final String message;
  ErrorState(this.message);
}

final class OrderInsertedState extends AdminOrdersState {
  final OrderModel newOrder;
  OrderInsertedState(this.newOrder);
}

final class OrderUpdatedState extends AdminOrdersState {
  final OrderModel updatedOrder;
  OrderUpdatedState(this.updatedOrder);
}
