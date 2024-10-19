import 'package:flutter/material.dart';

class CustomImageCards extends StatelessWidget {
  const CustomImageCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...List.generate(3, (index) {
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
              child: Image.asset(
                'assets/drone.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
        SizedBox(
          height: 67,
          width: 70,
          child: Card(
              surfaceTintColor: Color(0xff5669FF).withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 5,
              shadowColor: Colors.black,
              color: Colors.white,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    'assets/drone.png',
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Text(
                      '+12',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  )
                ],
              )),
        ),
      ],
    );
  }
}
