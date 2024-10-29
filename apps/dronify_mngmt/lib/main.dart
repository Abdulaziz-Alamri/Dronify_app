
import 'package:dronify_mngmt/Employee_Home/employee_home.dart';

import 'package:dronify_mngmt/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  await Future.delayed(Duration(seconds: 2));
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
