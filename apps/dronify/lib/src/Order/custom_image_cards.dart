import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImageCards extends StatelessWidget {
  final List<String> images;
  const CustomImageCards({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...List.generate(images.length, (index) {
          return SizedBox(
            height: 67,
            width: 70,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 5,
              shadowColor: Colors.black,
              color: Colors.white,
              child: Image.file(
                File(images[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
      ],
    );
  }
}
