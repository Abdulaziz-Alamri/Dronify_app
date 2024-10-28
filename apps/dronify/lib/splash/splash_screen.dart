import 'package:dronify/src/Auth/first_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // Display splash screen for 5 seconds before navigating
    await Future.delayed(Duration(seconds: 4));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FirstScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Set GIF size to 90% of the screen width
          double gifSize = constraints.maxWidth * 0.9;

          return Stack(
            children: [
              // Background image covering the entire screen
              Positioned.fill(
                child: Image.asset(
                  'assets/Splash (1).png',
                  fit: BoxFit.cover,
                ),
              ),
              // Centered large GIF
              Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/move.gif',
                    width: gifSize,
                    height: gifSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
