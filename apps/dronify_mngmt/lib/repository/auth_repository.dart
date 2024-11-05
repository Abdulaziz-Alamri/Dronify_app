import 'package:dronify_mngmt/Admin_Screens/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/utils/setup.dart';
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
        data: {'username': username, 'phone': phone, 'role': 'employee'},
      );

      if (response.user != null) {
        await supabase.rpc('confirm_user', params: {
          '_user_id': response.user!.id,
          'employee_position': 'Unassigned',
          'rating': 0.0,
          'image_url': null
        });
        return response;
      } else {
        throw Exception('Sign-up failed. Please try again.');
      }
    } catch (error) {
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
    } catch (error) {
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
        OneSignal.login(locator.get<AdminDataLayer>().externalKey!);
        await supabase.from('app_user').update({
          'external_key': locator.get<AdminDataLayer>().externalKey!
        }).eq('user_id', response.user!.id);
        return response;
      } else {
        throw Exception('Login failed: Invalid credentials.');
      }
    } catch (error) {
      throw Exception('Login failed: ${error.toString()}');
    }
  }

  // Get Current User function
  User? getCurrentUser() {
    try {
      return supabase.auth.currentUser;
    } catch (error) {
      throw Exception('Failed to get current user: ${error.toString()}');
    }
  }

  // Logout function
  Future logout() async {
    try {
      locator.get<AdminDataLayer>().onLogout();
      await supabase.auth.signOut();
    } catch (error) {
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
        return response.user!;
      } else {
        throw Exception('OTP verification failed. Please try again.');
      }
    } catch (error) {
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
        return response.user!;
      } else {
        throw Exception('OTP verification failed. Please try again.');
      }
    } catch (error) {
      throw Exception('OTP verification failed: ${error.toString()}');
    }
  }

  // Forgot Password function
  Future<void> forgotPassword({required String email}) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: ${error.toString()}');
    }
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

      } catch (error) {
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

      } catch (error) {
        throw Exception('Password update failed: ${error.toString()}');
      }
    }
}
