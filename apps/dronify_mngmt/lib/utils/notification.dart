import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void sendNotification(
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
      'contents': {'en': 'Your order is finsied'},
      'headings': {'en': 'Dronify'},
      'data': {
        'user_id': userId,
        'order_id': orderId,
      },
    }),
  );

  if (response.statusCode == 200) {
  } else {
  }
}
