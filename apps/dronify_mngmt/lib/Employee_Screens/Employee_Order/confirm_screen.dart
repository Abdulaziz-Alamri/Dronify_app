import 'dart:io';
import 'package:dronify_mngmt/Admin_Screens/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/Employee_Screens/Employee_Home/employee_home.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:dronify_mngmt/utils/db_operations.dart';
import 'package:dronify_mngmt/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ConfirmScreen extends StatelessWidget {
  final OrderModel order;
  final List<File> images;
  final String description;

  const ConfirmScreen({
    super.key,
    required this.order,
    required this.images,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F7),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Confirmation',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Images',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                height: 100,
                width: 345,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: images.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                images[index],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image);
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text('No images available'),
                      ),
              ),
              const SizedBox(height: 50),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                height: 200,
                width: 345,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xffA4A4AA),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          width: 335,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF072D6F),
                Color(0xFF0A3F9A),
                Color(0xFF0A43A4),
                Color(0xFF0D56D5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ElevatedButton(
            onPressed: () async {
              final imageFiles =
                  images.map((image) => XFile(image.path)).toList();
              await setOrderComplete(
                  order: order,
                  imageFiles: imageFiles,
                  description: description);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EmployeeHome(employee: locator.get<AdminDataLayer>().currentEmployee!)));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Confirm Complete Order',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
