import 'dart:developer';

import 'package:dronify/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:dronify/models/order_model.dart';

class CartItemCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onDelete;
  final ServiceModel servic;
  const CartItemCard(
      {super.key,
      required this.order,
      required this.onDelete,
      required this.servic});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 130,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black,
                    color: Colors.white,
                    child: Image.network(
                      servic.mainImage,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      servic.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      order.squareMeters.toString() ?? 'No status',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xffA4A4AA)),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price: ${order.totalPrice ?? 0} SAR',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff072D6F)),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xff072D6F),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
