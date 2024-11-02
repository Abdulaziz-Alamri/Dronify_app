part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignedUp extends AuthState {}

class AuthSignedIn extends AuthState {}

class AuthVerfiy extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final bool isCustomer;
  AuthError(this.message, {this.isCustomer=false});
}

class PasswordResetEmailSent extends AuthState {}

class PasswordResetFailed extends AuthState {
  final String message;

  PasswordResetFailed(this.message);
}

class AuthPasswordResetSuccess extends AuthState {} // Password reset success

class OtpResent extends AuthState {} // OTP resend success

