import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final supabase = Supabase.instance.client;

  // Sign Up function with metadata
  Future<AuthResponse> signUp({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      return await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          // Metadata for the user
          'username': username,
          'phone': phone,
        },
      );
    } catch (error) {
      return Future.error('Sign up failed: ${error.toString()}');
    }
  }

  // Resend OTP function
  Future<void> resendOtp({required String email}) async {
    try {
      await supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } catch (error) {
      return Future.error('OTP resend failed: ${error.toString()}');
    }
  }

  // Login function
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      return await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      return Future.error('Login failed: ${error.toString()}');
    }
  }

  // Get Current User function
  Future<User?> getCurrentUser() async {
    try {
      return supabase.auth.currentUser;
    } catch (error) {
      return Future.error('Failed to get current user: ${error.toString()}');
    }
  }

  // Logout function
  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
    } catch (error) {
      return Future.error('Logout failed: ${error.toString()}');
    }
  }

  Future verifyOtp({required String email, required String otp}) async {
    try {
      final AuthResponse authResponse = await supabase.auth.verifyOTP(
        token: otp,
        type: OtpType.signup,
        email: email,
      );

      if (authResponse.user != null) {
        return authResponse.user; // Return the authenticated user.
      } else {
        return Future.error('OTP verification failed.');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
