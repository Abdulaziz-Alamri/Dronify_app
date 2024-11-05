import 'dart:async';
import 'package:dronify_mngmt/Admin_Screens/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/repository/auth_repository.dart';
import 'package:dronify_mngmt/utils/db_operations.dart';
import 'package:dronify_mngmt/utils/setup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignUpEvent>(onSignUp);
    on<SignInEvent>(onSignIn);
    on<VerifyEvent>(onVerifyOtp);
    on<VerifycoverEvent>(onVerifyOtprecover);
    on<ForgotPasswordEvent>(onForgotPassword);
    on<RequestOtpEmail>(sendOtp);
  }

  Future<void> onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.signUp(
        email: event.email,
        password: event.password,
        username: event.username,
        phone: event.phone,
      );

      if (response.user != null) {
        emit(AuthSignedUp());
      } else {
        emit(AuthError('Sign-up failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Handle Sign-In event
  Future<void> onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.login(
        email: event.email.toLowerCase(),
        password: event.password,
      );

      if (response.user != null) {
        if (response.user!.userMetadata!['role'] == 'customer') {
          emit(FailedLoginState('You do not have permission to sign in',
              isCustomer: true));
          return;
        }
        await updateExternalKey(
            externalKey: locator.get<AdminDataLayer>().externalKey!);
        emit(AuthSignedIn());
      }
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('confirmed')) {
        emit(FailedLoginState('Confirm Your Email'));
      } else {
        emit(AuthError('An error occurred'));
      }
    }
  }

  // Handle OTP verification event
  Future<void> onVerifyOtp(VerifyEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.verifyOtp(
        email: event.email,
        otp: event.otp,
      );

      if (user.id.isNotEmpty) {
        await locator.get<AdminDataLayer>().fetchEmpOrders();
        emit(AuthSignedIn()); // OTP verified successfully
      } else {
        emit(AuthError('Invalid OTP. Please try again.'));
      }
    } catch (e) {
      emit(AuthError('Error: ${e.toString()}'));
    }
  }

  // Handle Forgot Password event
  Future<void> onForgotPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.forgotPassword(email: event.email);
      emit(PasswordResetEmailSent()); // Password reset email sent successfully
    } catch (e) {
      emit(PasswordResetFailed('Error: ${e.toString()}')); // Handle error
    }
  }

  FutureOr<void> onVerifyOtprecover(
      VerifycoverEvent event, Emitter<AuthState> emit) async {
    try {
      final user = await authRepository.verifyOtprecover(
        email: event.email,
        otp: event.otp,
      );

      if (user.id.isNotEmpty) {
        emit(AuthSignedIn());
      } else {
        emit(AuthError('Invalid OTP. Please try again.'));
      }
    } catch (e) {
      emit(AuthError('Error: ${e.toString()}'));
    }
  }

  FutureOr<void> sendOtp(RequestOtpEmail event, Emitter<AuthState> emit) async {
    try {
      await supabase.auth.resend(
        type: OtpType.signup,
        email: event.email.toLowerCase(),
      );
      emit(OtpSentSuccessfully()); 
    } catch (e) {
      emit(AuthError('Error sending OTP: ${e.toString()}'));
    }
  }
}
