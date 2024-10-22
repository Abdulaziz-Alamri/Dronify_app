import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Flutter Sample App"),
          automaticallyImplyLeading: false
      ),
      body: const Center(
        child: Text("Done!",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0
          ),),
      ),
    );
  }
}