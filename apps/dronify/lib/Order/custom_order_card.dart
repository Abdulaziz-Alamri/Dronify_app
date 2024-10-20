import 'package:flutter/material.dart';

class CustomOrderCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subTitle;

  const CustomOrderCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 60,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
            shadowColor: Colors.black,
            color: Colors.white,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(subTitle,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}
