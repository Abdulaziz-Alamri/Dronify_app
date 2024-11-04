import 'package:dronify_mngmt/Admin/Admin_Home/custom_barchart.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersStats extends StatelessWidget {
  const OrdersStats({super.key});

  Future<List<Map<String, dynamic>>> fetchOrderCountsByService() async {
    final response =
        await Supabase.instance.client.rpc('fetch_order_counts_by_service');

    if (response is PostgrestResponse) {
      throw Exception('Error fetching data: $response');
    }

    if (response is List) {
      return response.map((e) {
        return {
          "service_id": (e["service_id"] as int)
              .toDouble(),
          "order_count": (e["order_count"] as int)
              .toDouble(),
        };
      }).toList();
    } else {
      throw Exception('Unexpected response format');
    }
  }

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
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchOrderCountsByService(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  Center(child: Image.asset('assets/drone.gif'));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final data = snapshot.data!;
                  return CustomBarchart(data: data);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
