import 'package:dronify_mngmt/Order/order_screen.dart';
import 'package:dronify_mngmt/employee_home.dart';
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
        return const MaterialApp(
            debugShowCheckedModeBanner: false, home: OrderScreen());
      },
    );
  }
}
