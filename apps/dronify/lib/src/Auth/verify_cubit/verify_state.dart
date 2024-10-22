part of 'verify_cubit.dart';

@immutable
sealed class VerifyState {}

final class VerifyInitial extends VerifyState {}

final class LoadingState extends VerifyState {}

final class SuccessState extends VerifyState {}

final class ErrorState extends VerifyState {
  final String message;

  ErrorState({required this.message});
}
