import 'package:dronify/Auth/otp_Screan.dart';
import 'package:dronify/Auth/sginin.dart';
import 'package:dronify/Bottom_Nav/bottom_nav.dart';
import 'package:dronify/Cart/cart_screen.dart';
import 'package:dronify/Home/home_screen.dart';
import 'package:dronify/Order/order_screen.dart';
import 'package:dronify/Subscription/subscription_screen.dart';
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
            debugShowCheckedModeBanner: false, home: SubscriptionScreen());
      },
    );
  }
}
