import 'package:dronify/src/Bottom_Nav/bottom_nav.dart';
import 'package:dronify/src/Scrollable_Splash/splash_screen.dart';
import 'package:dronify/src/live_chat/live_chat.dart';
import 'package:dronify/test.dart';
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
        return MaterialApp(
            debugShowCheckedModeBanner: false, home: SplashScreen());
      },
    );
  }
}
