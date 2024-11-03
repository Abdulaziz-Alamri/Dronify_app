import 'package:dronify/models/service_model.dart';
import 'package:dronify/src/Services/services.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final int serviceId;
  final String imageUrl;
  final String title;
  final String description;
  final String iconPath;

  const ServiceCard({
    super.key,
    required this.serviceId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Services(
              service: ServiceModel.fromJson(
                {
                  'service_id': serviceId,
                  'name': title,
                  'description': description,
                  'main_image': imageUrl,
                  'price_per_sqm': 3,
                  'icon_path': iconPath,
                },
              ),
              iconpath: iconPath,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 145,
        width: 380,
        decoration: BoxDecoration(
          color: const Color(0xfff2f2f2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100, // تقليل ارتفاع الصورة إلى 100
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff172B4D),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
