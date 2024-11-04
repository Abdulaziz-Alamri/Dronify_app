import 'package:flutter/material.dart';

class EmptyTabImage extends StatelessWidget {
  final String imagePath;
  final String message;
  const EmptyTabImage({super.key, required this.imagePath, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: 150,
          width: 150,
        ),
        const SizedBox(height: 10),
        Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff072D6F),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
