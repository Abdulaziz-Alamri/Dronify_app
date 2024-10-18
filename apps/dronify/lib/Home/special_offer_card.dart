import 'package:flutter/material.dart';

class SpecialOfferCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  const SpecialOfferCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 290,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Color(0xffEAF6EF),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: 160, bottom: 120, child: Image.asset(imageUrl)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff33383F),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff33383F),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Grab offer'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
