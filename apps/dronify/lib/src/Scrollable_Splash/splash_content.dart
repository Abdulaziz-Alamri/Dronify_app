import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const SplashContent({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Image.asset(
                  'assets/splash_shape.png',
                ),
              ),
              if (imagePath != 'assets/splash_drone2.png')
                Positioned(
                  bottom: 120,
                  right: 40,
                  child: Center(
                    child: Image.asset(
                      imagePath,
                    ),
                  ),
                )
              else
                Center(
                  child: Image.asset(
                    imagePath,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
