import 'package:dronify_mngmt/Admin/All_employees/all_emp.dart';
import 'package:dronify_mngmt/Admin/Admin_Home/admin_home.dart';
import 'package:dronify_mngmt/Admin/live_chat/chat_screen.dart';
import 'package:dronify_mngmt/Bottom_Nav/bottom_nav.dart';
import 'package:dronify_mngmt/Employee_Home/employee_home.dart';
import 'package:dronify_mngmt/Employee_Order/confirm_screen.dart';
import 'package:dronify_mngmt/Employee_Order/order_screen.dart';
import 'package:dronify_mngmt/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
            debugShowCheckedModeBanner: false, home: BottomNav());
      },
    );
  }
}
