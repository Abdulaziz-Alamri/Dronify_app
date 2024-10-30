part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignedUp extends AuthState {}

class AuthSignedIn extends AuthState {}

class AuthVerfiy extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

