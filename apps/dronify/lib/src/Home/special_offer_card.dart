import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpecialOfferCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  const SpecialOfferCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      width: 380,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/budling water.png'),
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
            Positioned(left: 240, bottom: 75, child: Image.asset(imageUrl)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 2.0,
                              offset: Offset(1, 1),
                            ),
                            Shadow(
                              color: Colors.black,
                              blurRadius: 2.0,
                              offset: Offset(-1, -1),
                            ),
                            Shadow(
                              color: Colors.black,
                              blurRadius: 2.0,
                              offset: Offset(1, -1),
                            ),
                            Shadow(
                              color: Colors.black,
                              blurRadius: 2.0,
                              offset: Offset(-1, 1),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      onPressed: () {
                        Clipboard.setData(
                            const ClipboardData(text: "dronify2030"));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text(
                              '✔ copied!',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Grab offer',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff6A9B7E)),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
