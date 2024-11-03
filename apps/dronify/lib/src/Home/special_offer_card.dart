import 'package:flutter/material.dart';

class SpecialOfferCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  const SpecialOfferCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.description,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/DALL·E 2024-11-03 20.54.35 - A high-rise glass building with water spraying gently from the top, cascading down the facade in a light, minimal effect. The water droplets flow down 1.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Container(
        width: 270,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(left: 280, bottom: 75, child: Image.asset(imageUrl)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xff33383F),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff33383F),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Grab offer'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
