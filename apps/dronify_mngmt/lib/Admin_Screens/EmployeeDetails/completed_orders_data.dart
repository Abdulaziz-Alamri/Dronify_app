import 'package:dronify_mngmt/models/order_model.dart';

class CompletedOrdersData {
  final double completedPercentage;
  final List<OrderModel> completedOrders;

  CompletedOrdersData({
    required this.completedPercentage,
    required this.completedOrders,
  });
}