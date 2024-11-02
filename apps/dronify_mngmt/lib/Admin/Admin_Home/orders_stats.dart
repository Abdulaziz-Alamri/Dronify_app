import 'package:dronify_mngmt/Admin/Admin_Home/custom_barchart.dart';
import 'package:flutter/material.dart';

class OrdersStats extends StatelessWidget {
  const OrdersStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 400,
      width: double.infinity,
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
        children: [
          const Text(
            'Number of orders for each Service',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Building Cleaning',
                  style: const TextStyle(
                    color: Color(0xff072D6F),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: '   '),
                TextSpan(
                  text: 'Nano Protection',
                  style: const TextStyle(
                    color: Color(0xff0D56D5),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: '   '),
                TextSpan(
                  text: 'Spot Painting',
                  style: const TextStyle(
                    color: Color(0xff73DDFF),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: CustomBarchart()),
        ],
      ),
    );
  }
}
