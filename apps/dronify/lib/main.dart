import 'package:dronify/Auth/sginin.dart';
import 'package:dronify/Cart/cart_screen.dart';
import 'package:dronify/Home/home_screen.dart';
import 'package:dronify/Order/order_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: CartScreen());
  }
}
