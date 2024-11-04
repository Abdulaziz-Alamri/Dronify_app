import 'package:dronify/src/Bottom_Nav/bottom_nav.dart';
import 'package:dronify/src/Order/order_bloc/order_bloc.dart';
import 'package:dronify/utils/db_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingScreen extends StatelessWidget {
  final int orderId;
  const RatingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    TextEditingController reviewController = TextEditingController();
    return BlocProvider(
      create: (context) => OrderBloc(),
      child: Builder(builder: (context) {
        final bloc = context.read<OrderBloc>();
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: Center(
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  // if (state is RateOrderState)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AlertDialog(
                        title: const Text('Rate Your Order'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                                'Please rate your experience with this order.'),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    index < bloc.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                  ),
                                  onPressed: () {
                                    bloc.add(RateOrderEvent(rating: index + 1));
                                  },
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: reviewController,
                              decoration: const InputDecoration(
                                labelText: 'Write a review',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const BottomNav()));
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await rateOrder(
                                  rating: bloc.rating,
                                  orderId: orderId,
                                  review: reviewController.text);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const BottomNav()));
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
