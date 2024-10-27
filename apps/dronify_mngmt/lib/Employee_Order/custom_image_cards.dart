import 'package:flutter/material.dart';

class CustomImageCards extends StatelessWidget {
  final List<String> imageUrls;

  CustomImageCards({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...List.generate(imageUrls.length, (index) {
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
              child: Image.network(
                imageUrls[index], // جلب الصورة من الرابط
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image);
                },
              ),
            ),
          );
        }),
        // SizedBox(
        //   height: 67,
        //   width: 70,
        //   child: Card(
        //       surfaceTintColor: Color(0xff5669FF).withOpacity(0.6),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       elevation: 5,
        //       shadowColor: Colors.black,
        //       color: Colors.white,
        //       child: Stack(
        //         clipBehavior: Clip.none,
        //         children: [
        //           Image.network(
        //             imageUrls[3], // استخدم صورة إضافية
        //             fit: BoxFit.cover,
        //             errorBuilder: (context, error, stackTrace) {
        //               return Icon(Icons.broken_image);
        //             },
        //           ),
        //           Center(
        //             child: Text(
        //               '+${imageUrls.length - 3}', // عرض العدد المتبقي من الصور
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
