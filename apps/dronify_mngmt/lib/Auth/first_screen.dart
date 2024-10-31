import 'dart:developer';

import 'package:dronify_mngmt/Auth/sginin.dart';
import 'package:dronify_mngmt/Bottom_Nav/bottom_nav.dart';
import 'package:dronify_mngmt/Employee_Home/bloc/orders_bloc_bloc.dart';
import 'package:dronify_mngmt/Employee_Home/employee_home.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  Future<bool> _isUserLoggedIn() async {
    final user = Supabase.instance.client.auth.currentUser;
    log('${user != null}');
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error checking login status.'));
          } else if (snapshot.data == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              //check employee or admin and redirect to EmployeeHome or BottomNav
              if (supabase.auth.currentUser!.userMetadata?['role'] == 'admin') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNav(),
                  ),
                );
              } else if (supabase.auth.currentUser!.userMetadata?['role'] == 'employee') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeHome(),
                  ),
                );
              }
            });
          } else {
            // User is not logged in, go to SignInScreen
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
              );
            });
          }
          return const SizedBox();
        },
      ),
    );
  }
}
