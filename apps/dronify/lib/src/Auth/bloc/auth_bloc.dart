import 'dart:async';

import 'package:dronify/Data_layer/data_layer.dart';
import 'package:dronify/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dronify/models/customer_model.dart';
import 'package:dronify/utils/setup.dart'; // لضمان الوصول لـ DataLayer

part 'auth_event.dart'; // Event declarations
part 'auth_state.dart'; // State declarations

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignUpEvent>(onSignUp);
    on<SignInEvent>(onSignIn);
    on<VerifyEvent>(onVerifyOtp);
    on<VerifycoverEvent>(onVerifyOtprecover);
    on<ForgotPasswordEvent>(onForgotPassword);
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
        final customer = CustomerModel(
          customerId: response.user!.id,
          name: event.username,
          email: event.email,
          phone: event.phone,
        );

        await locator.get<DataLayer>().upsertCustomer(customer);

        locator.get<DataLayer>().saveCustomerData(customer);
        
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
        email: event.email,
        password: event.password,
      );

      if (response.user != null) {
        final customer = await locator.get<DataLayer>().getCustomer(
          response.user!.id,
        );

        // التحقق من وجود بيانات المستخدم وتخزينها في DataLayer
        if (customer != null) {
          locator.get<DataLayer>().saveCustomerData(customer);
          locator.get<DataLayer>().fetchCustomerOrders();
          emit(AuthSignedIn());
        } else {
          emit(AuthError('User data not found.'));
        }
      } else {
        emit(AuthError('Invalid credentials. Please try again.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
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

      if (user != null) {
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

  // FutureOr<void> onVerifyOtprecover(
  //     VerifycoverEvent event, Emitter<AuthState> emit) async {
  //   try {
  //     final user = await authRepository.verifyOtprecover(
  //       email: event.email,
  //       otp: event.otp,
  //     );

  //     if (user != null) {
  //       emit(AuthSignedIn());
  //     } else {
  //       emit(AuthError('Invalid OTP. Please try again.'));
  //     }
  //   } catch (e) {
  //     emit(AuthError('Error: ${e.toString()}'));
  //   }
  // }

  FutureOr<void> onVerifyOtprecover(VerifycoverEvent event, Emitter<AuthState> emit) async{

     try {
      final user = await authRepository.verifyOtprecover(
        email: event.email,
        otp: event.otp,
      );

      if (user != null) {
        emit(AuthSignedIn());
      } else {
        emit(AuthError('Invalid OTP. Please try again.'));
      }
    } catch (e) {
      emit(AuthError('Error: ${e.toString()}'));
    }

  }
}
