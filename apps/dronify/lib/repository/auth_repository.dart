import 'dart:developer';

import 'package:dronify/layer/data_layer.dart';
import 'package:dronify/utils/setup.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final supabase = Supabase.instance.client;
  // final user = supabase.auth.
  final user = Supabase.instance.client.auth.currentUser;

  // Sign Up function with metadata
  Future<AuthResponse> signUp({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username, 'phone': phone, 'role': 'customer'},
      );

      if (response.user != null) {
        return response;
      } else {
        throw Exception('Sign-up failed. Please try again.');
      }
    } catch (error) {
      log('Sign-up failed: $error');
      throw Exception('Sign-up failed: ${error.toString()}');
    }
  }

  // Resend OTP function
  Future<void> resendOtp({required String email}) async {
    try {
      await supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
      log('OTP resent successfully to $email');
    } catch (error) {
      log('OTP resend failed: $error');
      throw Exception('OTP resend failed: ${error.toString()}');
    }
  }

  // Login function
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        OneSignal.login(locator.get<DataLayer>().externalKey!);
        return response;
      } else {
        throw Exception('Login failed: Invalid credentials.');
      }
    } catch (error) {
      log('Login failed: $error');
      throw Exception('Login failed: ${error.toString()}');
    }
  }

  // Get Current User function
  User? getCurrentUser() {
    try {
      return supabase.auth.currentUser;
    } catch (error) {
      log('Failed to get current user: $error');
      throw Exception('Failed to get current user: ${error.toString()}');
    }
  }

  // Logout function
  Future logout() async {
    try {
      await locator.get<DataLayer>().onLogout();
      await supabase.auth.signOut();
      log('User logged out successfully');
    } catch (error) {
      log('Logout failed: $error');
      throw Exception('Logout failed: ${error.toString()}');
    }
  }

//============================================
  // Verify OTP function
  Future<User> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await supabase.auth.verifyOTP(
        type: OtpType.signup,
        token: otp,
        email: email,
      );

      if (response.user != null) {
        log('OTP verified successfully for $email');
        return response.user!;
      } else {
        throw Exception('OTP verification failed. Please try again.');
      }
    } catch (error) {
      log('OTP verification failed: $error');
      throw Exception('OTP verification failed: ${error.toString()}');
    }
  }
//-------------------------------------------------------------------

  Future<User> verifyOtprecover({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await supabase.auth.verifyOTP(
        token: otp,
        type: OtpType.recovery,
        email: email,
      );

      if (response.user != null) {
        log('OTP verified successfully for $email');
        return response.user!;
      } else {
        throw Exception('OTP verification failed. Please try again.');
      }
    } catch (error) {
      log('OTP verification failed: $error');
      throw Exception('OTP verification failed: ${error.toString()}');
    }
  }

  //=======================
  // sign in with email otp
  Future signWithOtp({
    required String email,
    required String otp,
  }) async {
    try {
      return await supabase.auth.signInWithOtp(email: email);
    } catch (error) {
      log('Email OTP sign-in failed: $error');
      throw Exception('Email OTP sign-in failed: ${error.toString()}');
    }
  }

  // Forgot Password function
  Future<void> forgotPassword({required String email}) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      log('Password reset link sent to $email');
    } catch (error) {
      log('Password reset failed: $error');
      throw Exception('Password reset failed: ${error.toString()}');
    }
    // Verify OTP and reset password
    Future<void> verifyOtpAndResetPassword({
      required String email,
      required String otp,
      required String newPassword,
    }) async {
      try {
        final response = await supabase.auth.verifyOTP(
          token: otp,
          type: OtpType.recovery,
          email: email,
        );

        if (response.user == null) {
          throw Exception('Invalid OTP. Please try again.');
        }

        // Update the user's password
        await supabase.auth.updateUser(
          UserAttributes(password: newPassword),
        );

        log('Password reset successfully');
      } catch (error) {
        log('OTP verification failed: $error');
        throw Exception('OTP verification failed: ${error.toString()}');
      }
    }

    //  Update Password
    Future<void> updatePassword({
      required String email,
      // required String otp,
      required String newPassword,
    }) async {
      try {
        // OTP verified successfully, now update the user's password
        await supabase.auth.updateUser(
          UserAttributes(password: newPassword), // Set new password
        );

        log('Password updated successfully for $email');
      } catch (error) {
        log('Password update failed: $error');
        throw Exception('Password update failed: ${error.toString()}');
      }
    }
  }
}
