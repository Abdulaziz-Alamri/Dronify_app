import 'dart:developer';
import 'dart:io';

import 'package:dronify/models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';

final supabase = Supabase.instance.client;

Future<void> saveOrder({
  required String customerId,
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
    log('im here');
    final orderResponse = await supabase
        .from('orders')
        .insert({
          'user_id': customerId,
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
      log('$orderId');

      for (var imageFile in imageFiles) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${basename(imageFile.path)}';
        final storagePath = 'orders/$orderId/$fileName';

        try {
          await supabase.storage.from('order_images').upload(
                storagePath,
                File(imageFile.path),
              );

          final imageUrl =
              supabase.storage.from('order_images').getPublicUrl(storagePath);

          imageUrls.add(imageUrl);

          await supabase.from('images').insert(
              {'order_id': orderId, 'image_url': imageUrl, 'type': 'before'});
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

checkChat({required String chatId}) async {
  final response = await supabase
      .from('live_chat')
      .select('chat_id')
      .eq('user_id', supabase.auth.currentUser!.id)
      .eq('status', 'started')
      .maybeSingle();

  if (response != null) {
    return response['chat_id'].toString();
  } else {
    await supabase.from('live_chat').insert({
      'chat_id': chatId,
      'user_id': supabase.auth.currentUser!.id,
      'admin_id': '0cf2efe9-94b7-482b-9c85-de2122e4a675',
    });
    await supabase.from('chat_message').insert({
      'chat_id': chatId,
      'sender_id': '0cf2efe9-94b7-482b-9c85-de2122e4a675',
      'message': 'How may I assist you?',
    });
    return chatId;
  }
}

endChat({required String chatId}) async {
  await supabase
      .from('live_chat')
      .update({'status': 'ended'}).eq('chat_id', chatId);
}

saveSubscription({
  required int duration,
  required double squareMeters,
  required DateTime reservationDate,
  required double totalPrice,
  required List<XFile> imageFiles,
  required String latitude,
  required String longitude,
}) async {
  try {
    final subscriptionResponse = await supabase
        .from('subscriptions')
        .insert({
          'user_id': supabase.auth.currentUser?.id,
          'duration': duration,
          'square_meters': squareMeters,
          'reservation_date': reservationDate.toString(),
          'total_price': totalPrice,
          'ending_at': DateTime(
            reservationDate.year,
            reservationDate.month + duration,
            reservationDate.day,
          ).toString()
        })
        .select('sub_id')
        .single();

    if (subscriptionResponse['sub_id'] != null) {
      final subId = subscriptionResponse['sub_id'];

      List<String> imageUrls = [];
      for (var imageFile in imageFiles) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${basename(imageFile.path)}';
        final storagePath = 'subscriptions/$subId/$fileName';

        try {
          await supabase.storage.from('subscription_images').upload(
                storagePath,
                File(imageFile.path),
              );

          final imageUrl = supabase.storage
              .from('subscription_images')
              .getPublicUrl(storagePath);

          imageUrls.add(imageUrl);

          log('$subId');

          await supabase
              .from('subscription_images')
              .insert({'sub_id': subId, 'image_url': imageUrl});
        } catch (error) {
          throw Exception('Failed to upload image: $error');
        }
      }

      // Insert the address into the database
      await supabase.from('subscription_address').insert({
        'sub_id': subId,
        'latitude': latitude,
        'longitude': longitude,
      });

      print("Subscription saved successfully.");
    } else {
      throw Exception("Failed to insert the Subscription.");
    }
  } catch (error) {
    print("Error saving Subscription: $error");
    throw error;
  }

  Future<void> upsertCustomer(CustomerModel customer) async {
    try {
      final response =
          await supabase.from('customers').upsert(customer.toJson());
      if (response.error != null) {
        throw Exception(response.error!.message);
      }
    } catch (e) {
      print('Error upserting customer: $e');
    }
  }

  Future<CustomerModel?> getCustomer(String customerId) async {
    try {
      final response = await supabase
          .from('customers')
          .select()
          .eq('customer_id', customerId)
          .single();

      if (response != null) {
        throw Exception(response);
      }

      if (response != null) {
        return CustomerModel.fromJson(response);
      }

      return null;
    } catch (e) {
      print('Error fetching customer: $e');
      return null;
    }
  }
}

updateExternalKey({required String externalKey}) async {
  await supabase.from('app_user').update({'external_key': externalKey});
}
