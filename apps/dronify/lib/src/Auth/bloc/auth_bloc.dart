// import 'package:dronify/repository/auth_repository.dart'; // Adjust path if needed
// import 'package:flutter_bloc/flutter_bloc.dart';

// part 'auth_event.dart'; // Event declarations (SignUp, SignIn, VerifyOtp, etc.)
// part 'auth_state.dart'; // State declarations (Loading, Success, Error, etc.)

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthRepository authRepository;

//   AuthBloc(this.authRepository) : super(AuthInitial()) {
//     // Event handlers for authentication flows
//     on<SignUpEvent>(onSignUp);
//     on<SignInEvent>(onSignIn);
//     on<VerifyEvent>(onVerifyOtp); // OTP verification handler
//   }

//   // Handle Sign-Up event
//   Future<void> onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
//     emit(AuthLoading());
//     try {
//       final response = await authRepository.signUp(
//         email: event.email,
//         password: event.password,
//         username: event.username,
//         phone: event.phone,
//       );

//       if (response.user != null) {
//         emit(AuthSignedUp());
//       } else {
//         emit(AuthError('Sign-up failed. Please try again.'));
//       }
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }

//   // Handle Sign-In event
//   Future<void> onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
//     emit(AuthLoading());
//     try {
//       final response = await authRepository.login(
//         email: event.email,
//         password: event.password,
//       );

//       if (response.user != null) {
//         emit(AuthSignedIn());
//       } else {
//         emit(AuthError('Invalid credentials. Please try again.'));
//       }
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }

//   Future<void> onVerifyOtp(VerifyEvent event, Emitter<AuthState> emit) async {
//     emit(AuthLoading());
//     try {
//       // Call the repository to verify the OTP and get the user
//       final user = await authRepository.verifyOtp(
//         email: event.email,
//         otp: event.otp,
//       );
//       print("SUCCEEDED");

//       if (user != null) {
//         emit(AuthSignedIn()); // Successfully signed in
//       } else {
//         emit(AuthError('Invalid OTP. Please try again.'));
//       }
//     } catch (e) {
//       emit(AuthError('Error: ${e.toString()}'));
//     }
//   }
// }
import 'dart:async';

import 'package:dronify/repository/auth_repository.dart'; // Adjust path if needed
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart'; // Event declarations
part 'auth_state.dart'; // State declarations

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    // Event handlers for authentication flows
    on<SignUpEvent>(onSignUp);
    on<SignInEvent>(onSignIn);
    on<VerifyEvent>(onVerifyOtp);
    on<VerifycoverEvent>(onVerifyOtprecover);
    on<ForgotPasswordEvent>(onForgotPassword); // Forgot password handler
  }

  // Handle Sign-Up event
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
        email: event.email,
        password: event.password,
      );

      if (response.user != null) {
        emit(AuthSignedIn());
      } else {
        emit(AuthError('Invalid credentials. Please try again.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Future<void> onVerifyOtprecover(
  //     VerifyEvent event, Emitter<AuthState> emit) async {
  //   emit(AuthLoading());
  //   try {
  //     final user = await authRepository.verifyOtprecover(
  //       email: event.email,
  //       otp: event.otp,
  //     );

  //     if (user != null) {
  //       emit(AuthSignedIn()); // OTP verified successfully
  //     } else {
  //       emit(AuthError('Invalid OTP. Please try again.'));
  //     }
  //   } catch (e) {
  //     emit(AuthError('Error: ${e.toString()}'));
  //   }
  // }

  // Handle OTP Verification
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

  FutureOr<void> onVerifyOtprecover(
      VerifycoverEvent event, Emitter<AuthState> emit) async {
    try {
      final user = await authRepository.verifyOtprecover(
        email: event.email,
        otp: event.otp,
      );

      if (user != null) {
        emit(AuthPasswordResetSuccess()); // OTP verified successfully
      } else {
        emit(AuthError('Invalid OTP. Please try again.'));
      }
    } catch (e) {
      emit(AuthError('Error: ${e.toString()}'));
    }
  }
}
