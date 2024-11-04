
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:moyasar/moyasar.dart';

// PaymentConfig pay({required double totalPrice,required int orderId}) {
//     final paymentConfig = PaymentConfig(
//       publishableApiKey: '${dotenv.env['moyasar_test_key']}',
//       amount: (totalPrice * 100).toInt(),
//       description: 'Dronify Order',
//       metadata: {'orderId': orderId, 'customer': 'customer'},
//       creditCard: CreditCardConfig(saveCard: true, manual: false),
//     );
//     return paymentConfig;
//   }

//   void onPaymentResult(result, BuildContext context) {
//     if (result is PaymentResponse) {
//       switch (result.status) {
//         case PaymentStatus.paid:
//           break;
//         case PaymentStatus.failed:
//           break;
//         case PaymentStatus.initiated:
//         case PaymentStatus.authorized:
//         case PaymentStatus.captured:
//       }
//     }
//   }