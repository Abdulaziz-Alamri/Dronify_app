import 'dart:developer';
import 'dart:io';

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
      'admin_id': 'a581cd5e-c67c-4522-a4bb-01b795c43387',
    });
    await supabase.from('chat_message').insert({
      'chat_id': chatId,
      'sender_id': 'a581cd5e-c67c-4522-a4bb-01b795c43387',
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
}
