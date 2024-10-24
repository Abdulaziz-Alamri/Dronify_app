import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> saveOrder(
    {required String customerId,
    required String employeeId,
    required int serviceId,
    required double squareMeters,
    required DateTime reservationDate,
    required TimeOfDay reservationTime,
    required double totalPrice,
    required List<String> imageUrls,
    required String latitude,
    required String longitude,
    required List<XFile> imageFiles}) async {
  final supabase = Supabase.instance.client;

  try {
    final orderResponse = await supabase
        .from('orders')
        .insert({
          'user_id': customerId,
          'employee_id': employeeId,
          'service_id': serviceId,
          'square_meters': squareMeters,
          'reservation_date': reservationDate.toString(),
          'reservation_time':
              '${reservationTime.hour}:${reservationTime.minute}',
          'total_price': totalPrice,
        })
        .select('order_id')
        .single();

    for (var imageFile in imageFiles) {
      final storagePath = '';

      await supabase.storage.from('order_images').upload(
            storagePath,
            File(imageFile.path),
          );
      if (orderResponse['order_id'] != null) {
        try {
          // Get the public URL of the uploaded image
          final imageUrl =
              supabase.storage.from('order_images').getPublicUrl(storagePath);

          imageUrls.add(imageUrl);

          // Insert the image into the images table
          await supabase.from('images').insert({
            'order_id': orderResponse['order_id'],
            'image_url': imageUrl,
          });
        } catch (error) {
          throw Exception('Failed to upload image: $error');
        }

        await supabase.from('address').insert({
          'order_id': orderResponse['order_id'],
          'latitude': latitude,
          'longitude': longitude,
        });

        print("Order saved successfully.");
      } else {
        throw Exception("Failed to insert the order.");
      }
    }
  } catch (error) {
    print("Error saving order: $error");
    throw error;
  }
}
