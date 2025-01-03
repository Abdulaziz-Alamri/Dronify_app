import 'dart:io';
import 'package:dronify_mngmt/Admin_Screens/EmployeeDetails/completed_orders_data.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:dronify_mngmt/utils/notification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';

final supabase = Supabase.instance.client;

setOrderComplete({
  required OrderModel order,
  required List<XFile> imageFiles,
  required String description,
}) async {
  // upload 'after images' (images table)
  List<String> imageUrls = [];
  for (var imageFile in imageFiles) {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${basename(imageFile.path)}';
    final storagePath = 'orders/${order.orderId}/$fileName';

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
      await supabase.from('images').insert(
          {'order_id': order.orderId, 'image_url': imageUrl, 'type': 'after'});
    } catch (error) {
      throw Exception('Failed to upload image: $error');
    }
  }

  // update order description and order status to complete (orders table)
  try {
    await supabase
        .from('orders')
        .update({'emp_description': description, 'status': 'complete'}).eq(
            'order_id', order.orderId!);
  } catch (e) {
    throw Exception('Failed to updating order: $e');
  }

  // send notification to customer
  final userResponse = await supabase
      .from('orders')
      .select('user_id')
      .eq('order_id', order.orderId!)
      .single();

  //  fetch external_key
  final externalKeyResponse = await supabase
      .from('app_user')
      .select('external_key')
      .eq('user_id', userResponse['user_id'])
      .single();

  final String externalKey = externalKeyResponse['external_key'].toString();
  sendCompleteOrderNotification(
      externalKey: externalKey,
      userId: userResponse['user_id'],
      orderId: order.orderId!);
}

setOrderConfrimed(
    {required String employeeId,
    required String newStatus,
    required int orderId}) async {
  await supabase.from('orders').update(
      {'employee_id': employeeId, 'status': newStatus}).eq('order_id', orderId);

  // send notification to customer
  final userResponse = await supabase
      .from('orders')
      .select('user_id')
      .eq('order_id', orderId)
      .single();

  //  fetch external_key
  final externalKeyResponse = await supabase
      .from('app_user')
      .select('external_key')
      .eq('user_id', userResponse['user_id'])
      .single();

  final String externalKey = externalKeyResponse['external_key'].toString();
  sendConfirmedOrderNotification(externalKey: externalKey);
}

cancelOrder({required OrderModel order}) async {
  final userId = await supabase
      .from('orders')
      .select('user_id')
      .eq('order_id', order.orderId!)
      .single();

  final balance = await supabase
      .from('app_user')
      .select('balance')
      .eq('user_id', userId['user_id'])
      .single();

  double newBalance = balance['balance'] == null
      ? order.totalPrice!
      : (double.parse(balance['balance'].toString()) + order.totalPrice!);

  var data = <Future>[];

  data.addAll([
    supabase.from('orders').delete().eq('order_id', order.orderId!),
    supabase
        .from('app_user')
        .update({'balance': newBalance}).eq('user_id', userId['user_id'])
  ]);

  await Future.wait(data);
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
    return CompletedOrdersData(completedPercentage: 0.0, completedOrders: []);
  }
}

updateExternalKey({required String externalKey}) async {
  await supabase.from('app_user').update({'external_key': externalKey}).eq(
      'user_id', supabase.auth.currentUser!.id);
}
