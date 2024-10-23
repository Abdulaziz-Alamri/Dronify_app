import 'package:dronify/src/Bottom_Nav/bottom_nav.dart';
import 'package:dronify/src/Order/order_screen.dart';
import 'package:dronify/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() async {
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
