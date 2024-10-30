part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String phone;

  SignUpEvent({
    required this.email,
    required this.password,
    required this.username,
    required this.phone,
  });
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({
    required this.email,
    required this.password,
  });
}

final class VerifyEvent extends AuthEvent {
  final String email;

  final String otp;

  VerifyEvent(
      {
      required this.email,
     
      required this.otp});
}
final class VerifycoverEvent extends AuthEvent {
  final String email;

  final String otp;

  VerifycoverEvent(
      {
      required this.email,
     
      required this.otp});
}

class RequestOtpEmail extends AuthEvent {
  final String email;

  RequestOtpEmail(this.email);
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent(this.email);
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String newPassword;

  ResetPasswordEvent({required this.email, required this.newPassword});
}
