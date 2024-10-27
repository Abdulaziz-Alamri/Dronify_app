import 'package:flutter/material.dart';

class CustomImageCards extends StatelessWidget {
  final List<String> imageUrls;

  CustomImageCards({super.key, required this.imageUrls});

  void zoom(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...List.generate(
          imageUrls.length < 3 ? imageUrls.length : 3,
          (index) {
            return GestureDetector(
              onTap: () => zoom(context, imageUrls[index]),
              child: SizedBox(
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
                    imageUrls[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image);
                    },
                  ),
                ),
              ),
            );
          },
        ),
        if (imageUrls.length > 3)
          GestureDetector(
            onTap: () => zoom(context, imageUrls[3]),
            child: SizedBox(
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
                    Image.network(
                      imageUrls[3],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image);
                      },
                    ),
                    Center(
                      child: Text(
                        '+${imageUrls.length - 3}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
