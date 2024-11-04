import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void sendCompleteOrderNotification(
    {required String externalKey,
    required String userId,
    required int orderId}) async {
  const url = 'https://api.onesignal.com/notifications?c=push';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${dotenv.env['onesignal_rest_key']}',
    },
    body: jsonEncode({
      'app_id': '${dotenv.env['onesignal_key']}',
      'target_channel': 'push',
      'include_external_user_ids': [externalKey],
      'contents': {'en': 'Your Order has been completed'},
      'headings': {'en': 'Dronify'},
      'data': {
        'user_id': userId,
        'order_id': orderId,
      },
    }),
  );

  if (response.statusCode == 200) {
  } else {}
}

void sendConfirmedOrderNotification({required String externalKey}) async {
  const url = 'https://api.onesignal.com/notifications?c=push';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${dotenv.env['onesignal_rest_key']}',
    },
    body: jsonEncode({
      'app_id': '${dotenv.env['onesignal_key']}',
      'target_channel': 'push',
      'include_external_user_ids': [externalKey],
      'contents': {
        'en': 'Your order has been assigned, we will contact you soon'
      },
      'headings': {'en': 'Dronify'},
    }),
  );

  if (response.statusCode == 200) {
  } else {}
}

void sendAvailableOrderNotification({required String externalKey}) async {
  const url = 'https://api.onesignal.com/notifications?c=push';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${dotenv.env['onesignal_rest_key']}',
    },
    body: jsonEncode({
      'app_id': '${dotenv.env['onesignal_key']}',
      'target_channel': 'push',
      'include_external_user_ids': [externalKey],
      'contents': {'en': 'New Orders Available'},
      'headings': {'en': 'Dronify'},
    }),
  );

  if (response.statusCode == 200) {
  } else {}
}
