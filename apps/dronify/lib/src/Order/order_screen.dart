import 'package:dronify/models/order_model.dart';
import 'package:dronify/models/service_model.dart';
import 'package:dronify/src/Order/custom_image_cards.dart';
import 'package:dronify/src/Order/custom_order_card.dart';
import 'package:dronify/utils/db_operations.dart';
import 'package:dronify/utils/payment.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moyasar/moyasar.dart';
import 'package:sizer/sizer.dart';

class OrderScreen extends StatelessWidget {
  final OrderModel order;
  final List<XFile> images;
  // final ServiceModel service;
  const OrderScreen({super.key, required this.order, required this.images});

  @override
  Widget build(BuildContext context) {
    final ServiceModel service = ServiceModel(
        serviceId: 1,
        name: 'Building Cleaning',
        description:
            'A competitive type of auction in which participants compete for a contract, offering each time a price lower than that of competitors',
        mainImage: 'assets/drone.png',
        pricePerSqm: 3);
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
            const SizedBox(
              height: 20,
            ),
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
                      subTitle: '0512341234')),
            ),
            const SizedBox(
              height: 15,
            ),
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
                      imageUrl: 'assets/drone.png',
                      title:
                          'Date: ${DateFormat.yMMMd().format(order.reservationDate!)}',
                      subTitle:
                          'Time: ${order.reservationTime!.hour}:${order.reservationTime!.minute}'),
                  const Divider(
                    color: Color(0xffEDEDED),
                    height: 30,
                  ),
                  Text(
                    'Price: ${order.totalPrice} SAR',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    color: Color(0xffEDEDED),
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        service.description,
                        style: TextStyle(color: Color(0xffA4A4AA)),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color(0xffEDEDED),
                    height: 30,
                  ),
                  Row(
                    children: [
                      Image.asset('assets/drone_icon.png'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        service.name,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.track_changes_outlined,
                        color: Color(0xff072D6F),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${order.address}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_outlined,
                        color: Color(0xff072D6F),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${order.reservationTime!.hour}:${order.reservationTime!.minute}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
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
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: CustomImageCards(
                  images: order.images!,
                )),
            const SizedBox(
              height: 40,
            ),
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
                    saveOrder(
                        customerId: order.customerId!,
                        employeeId: order.employeeId!,
                        serviceId: order.serviceId!,
                        squareMeters: order.squareMeters!,
                        reservationDate: order.reservationDate!,
                        reservationTime: TimeOfDay.now(),
                        totalPrice: order.totalPrice!,
                        imageUrls: [],
                        latitude: order.address![0],
                        longitude: order.address![1],
                        imageFiles: images);

                    // showModalBottomSheet(
                    //   context: context,
                    //   backgroundColor: Colors.white,
                    //   shape: const RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.vertical(
                    //       top: Radius.circular(25.0),
                    //     ),
                    //   ),
                    //   builder: (BuildContext context) {
                    //     return Padding(
                    //       padding: const EdgeInsets.all(12),
                    //       child: CreditCard(
                    //         config: pay(totalPrice: 1000, orderId: 2321213),
                    //         onPaymentResult: (result) async {
                    //           onPaymentResult(result, context);
                    //           Navigator.pop(context, 'Payment successful');
                    //         },
                    //       ),
                    //     );
                    //   },
                    // ).then((value) async {
                    //   if (value == 'Payment successful') {
                    //     await Future.delayed(const Duration(seconds: 5));
                    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //         content: Text('The payment is done successfully')));
                    //   }
                    // });
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
