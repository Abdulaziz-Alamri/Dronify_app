import 'package:flutter/material.dart';

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
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
        // SizedBox(
        //   height: 67,
        //   width: 70,
        //   child: Card(
        //       surfaceTintColor: const Color(0xff5669FF).withOpacity(0.6),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       elevation: 5,
        //       shadowColor: Colors.black,
        //       color: Colors.white,
        //       child: Stack(
        //         clipBehavior: Clip.none,
        //         children: [
        //           Image.asset(
        //             'assets/drone.png',
        //             fit: BoxFit.cover,
        //           ),
        //           const Center(
        //             child: Text(
        //               '+12',
        //               style: TextStyle(
        //                   fontSize: 18,
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.black),
        //             ),
        //           )
        //         ],
        //       )),
        // ),
      ],
    );
  }
}
