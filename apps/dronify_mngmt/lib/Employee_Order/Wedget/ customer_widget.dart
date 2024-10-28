import 'package:dronify_mngmt/Employee_Order/custom_custmer_wedget.dart';
import 'package:flutter/material.dart';

class CustomerWidget extends StatelessWidget {
  final String orderNumber;
  final String name;
  final String phone;

  const CustomerWidget({
    Key? key,
    required this.orderNumber,
    required this.name,
    required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCustmerWedget(
      ordernumber: orderNumber,
      title: name,
      subTitle: phone,
    );
  }
}
