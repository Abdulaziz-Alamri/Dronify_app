import 'dart:developer';
import 'dart:io';

import 'package:dronify_mngmt/Admin/EmployeeDetails/completed_orders_data.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';

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
  required List<XFile> imageFiles,
}) async {
  try {
    final orderResponse = await supabase
        .from('orders')
        .insert({
          'customer_id': customerId,
          'employee_id': employeeId,
          'service_id': serviceId,
          'square_meters': squareMeters,
          'reservation_date': reservationDate.toIso8601String(),
          'reservation_time':
              '${reservationTime.hour}:${reservationTime.minute}',
          'total_price': totalPrice,
        })
        .select('order_id')
        .single();

    if (orderResponse['order_id'] != null) {
      final orderId = orderResponse['order_id'];

      for (var imageFile in imageFiles) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${basename(imageFile.path)}';
        final storagePath = 'orders/$orderId/$fileName';

        try {
          // Upload image to Supabase storage
          await supabase.storage.from('order_images').upload(
                storagePath,
                File(imageFile.path),
              );

          final imageUrl =
              supabase.storage.from('order_images').getPublicUrl(storagePath);

          imageUrls.add(imageUrl);

          // Insert image details into the database
          await supabase.from('images').insert({
            'order_id': orderId,
            'image_url': imageUrl,
          });
        } catch (error) {
          throw Exception('Failed to upload image: $error');
        }
      }

      // Insert the address into the database
      await supabase.from('address').insert({
        'order_id': orderId,
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

setOrderAccepted() async {}

cancelOrder({required OrderModel order}) async {
  await supabase.from('orders').delete().eq('order_id', order.orderId!);
}

Future<CompletedOrdersData> getCompletedOrdersData(
    {required String employeeId}) async {
  try {
    final response =
        await supabase.from('orders').select().eq('employee_id', employeeId);

    int totalOrders = response.length;
    int completedOrdersCount =
        response.where((order) => order['status'] == 'complete').length;

    // Calculate the percentage of completed orders
    final completedPercentage =
        totalOrders > 0 ? (completedOrdersCount / totalOrders) : 0.0;

    // Fetch the list of completed orders
    List<OrderModel> completedOrdersList = response
        .where((order) => order['status'] == 'complete')
        .map<OrderModel>((order) => OrderModel.fromJson(order))
        .toList();

    return CompletedOrdersData(
      completedPercentage: completedPercentage,
      completedOrders: completedOrdersList,
    );
  } catch (error) {
    print("Error fetching completed orders data: $error");
    return CompletedOrdersData(completedPercentage: 0.0, completedOrders: []);
  }
}
