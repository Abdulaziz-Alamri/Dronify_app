import 'package:dronify_mngmt/Admin_Home/admin_home.dart';
import 'package:dronify_mngmt/Admin_Profile/profile_screen.dart';
import 'package:dronify_mngmt/Bottom_Nav/bottom_nav.dart';
import 'package:dronify_mngmt/Employee_Home/employee_home.dart';
import 'package:dronify_mngmt/Order/confirm_screen.dart';
import 'package:dronify_mngmt/Order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return  MaterialApp(
            debugShowCheckedModeBanner: false, home: ProfileScreen());
      },
    );
  }
}
