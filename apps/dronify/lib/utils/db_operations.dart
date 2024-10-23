import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;


Future<void> saveOrder({
  required String customerId,
  required String employeeId,
  required int serviceId,
  required double squareMeters,
  required DateTime reservationDate,
  required TimeOfDay reservationTime,
  required double totalPrice,
  required List<String> imageUrls,
  required String latitude,
  required String longitude,
}) async {
  final supabase = Supabase.instance.client;

  try {
    final orderResponse = await supabase
        .from('orders')
        .insert({
          'customer_id': customerId,
          'employee_id': employeeId,
          'service_id': serviceId,
          'square_meters': squareMeters,
          'reservation_date': reservationDate.toString(),
          'reservation_time': '${reservationTime.hour}:${reservationTime.minute}',
          'total_price': totalPrice,
        })
        .select('order_id')
        .single();

    if (orderResponse['order_id'] != null) {
      for (var imageUrl in imageUrls) {
        await supabase.from('images').insert({
          'order_id': orderResponse['order_id'],
          'image_url': imageUrl,
        });
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
  } catch (error) {
    print("Error saving order: $error");
    throw error;
  }
}

