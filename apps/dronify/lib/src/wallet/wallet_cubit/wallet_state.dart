part of 'wallet_cubit.dart';

@immutable
sealed class WalletState {}

final class WalletInitial extends WalletState {}

final class WalletLoading extends WalletState {}

final class WalletLoaded extends WalletState {
  final List<OrderModel> orders;
  WalletLoaded(this.orders);
}

final class WalletError extends WalletState {
  final String message;
  WalletError(this.message);
}