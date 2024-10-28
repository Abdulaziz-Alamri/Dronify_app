import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageGalleryWidget extends StatelessWidget {
  final List<XFile> images;
  final Function(BuildContext, File) onZoom;

  const ImageGalleryWidget({
    Key? key,
    required this.images,
    required this.onZoom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return images.isNotEmpty
        ? Container(
            height: 100,
            width: 345,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: images.map((image) {
                return GestureDetector(
                  onTap: () => onZoom(context, File(image.path)),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(image.path),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        : const Text('No images selected');
  }
}
