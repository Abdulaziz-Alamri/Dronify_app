import 'package:dronify_mngmt/Admin_Screens/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:dronify_mngmt/models/service_model.dart';
import 'package:dronify_mngmt/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CompleteOrderCard extends StatelessWidget {
  final OrderModel order;

  const CompleteOrderCard(
      {super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    ServiceModel service =
        locator.get<AdminDataLayer>().allServices[order.serviceId! - 1];
    return Row(
      children: [
        SizedBox(
          height: 60,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
            shadowColor: Colors.black,
            color: Colors.white,
            child: Image.network(
              service.mainImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               service.name,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                service.description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        RatingBarIndicator(
          rating: order.orderRating ?? 0,
          itemBuilder: (context, index) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 20.0,
          direction: Axis.horizontal,
        ),
      ],
    );
  }
}
