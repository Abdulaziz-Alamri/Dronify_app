import 'package:dronify/Data_layer/data_layer.dart';
import 'package:dronify/models/cart_model.dart';
import 'package:dronify/src/Bottom_Nav/bottom_nav.dart';
import 'package:dronify/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:get_it/get_it.dart';

import 'package:dronify/models/order_model.dart';
import 'package:dronify/models/service_model.dart';
import 'package:dronify/src/Order/custom_image_cards.dart';
import 'package:dronify/src/Order/custom_order_card.dart';

class OrderScreen extends StatelessWidget {
  final OrderModel order;
  final ServiceModel service;
  final List<XFile> images;

  const OrderScreen(
      {super.key,
      required this.order,
      required this.images,
      required this.service});

  @override
  Widget build(BuildContext context) {
    final dataLayer = GetIt.instance<DataLayer>();

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
          'Order',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 75,
                width: 345,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const CustomOrderCard(
                  imageUrl: 'assets/drone12.png',
                  title: 'Customer Name',
                  subTitle: '0512341234',
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              height: 420,
              width: 345,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomOrderCard(
                    imageUrl: '${service.mainImage}',
                    title:
                        'Date: ${DateFormat.yMMMd().format(order.reservationDate!)}',
                    subTitle:
                        'Time: ${order.reservationTime!.hour}:${order.reservationTime!.minute}',
                  ),
                  const Divider(color: Color(0xffEDEDED), height: 30),
                  Text(
                    'Price: ${order.totalPrice} SAR',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Color(0xffEDEDED), height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        service.description,
                        style: TextStyle(color: Color(0xffA4A4AA)),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xffEDEDED), height: 30),
                  Row(
                    children: [
                      Image.asset('assets/drone_icon.png'),
                      const SizedBox(width: 10),
                      Text(
                        service.name,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.track_changes_outlined,
                          color: Color(0xff072D6F)),
                      SizedBox(width: 10),
                      Text(
                        '${order.address}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.access_time_filled_outlined,
                          color: Color(0xff072D6F)),
                      SizedBox(width: 10),
                      Text(
                        '${order.reservationTime!.hour}:${order.reservationTime!.minute}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              height: 100,
              width: 345,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: CustomImageCards(images: order.images!),
            ),
            const SizedBox(height: 40),
            Center(
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
                  onPressed: () {
                    dataLayer.addToCart(order);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Order added to cart successfully!')));
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNav(index: 1)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
