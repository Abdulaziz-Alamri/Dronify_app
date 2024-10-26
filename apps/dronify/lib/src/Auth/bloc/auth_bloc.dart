// import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

import 'package:dronify/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignUpEvent>(onSignUp);
  }

  Future<void> onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Emit loading state.
    try {
      final response = await authRepository.signUp(
        email: event.email,
        password: event.password,
        username: event.username,
        phone: event.phone,
      );

      if (response.user != null) {
        emit(AuthSignedUp()); // Emit success state.
      } else {
        emit(AuthError('Sign-up failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError(e.toString())); // Emit error state.
    }
  }
}
