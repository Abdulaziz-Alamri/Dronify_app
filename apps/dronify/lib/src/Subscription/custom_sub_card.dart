import 'package:dronify/src/Subscription/subscription_bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomSubCard extends StatelessWidget {
  final int duration;
  final String description;
  final double price;
  final int index;
  final int selectedIndex;
  final bool value;
  final SubscriptionBloc bloc;
  const CustomSubCard(
      {super.key,
      required this.duration,
      required this.description,
      required this.price,
      required this.index,
      required this.selectedIndex,
      required this.value,
      required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 67,
          width: 308,
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
          child: Row(
            children: [
              Radio(
                  value: index,
                  groupValue: selectedIndex,
                  activeColor: const Color(0xff072D6F),
                  onChanged: (value) {
                    bloc.add(
                        SelectRadioEvent(selectedIndex: index, value: true));
                  }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$duration-Months',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff072D6F))),
                  SizedBox(
                    width: 150,
                    child: Text(
                      description,
                      softWrap: true,
                      style: const TextStyle(
                          fontSize: 7, color: Color(0xff072D6F)),
                    ),
                  ),
                ],
              ),
              const VerticalDivider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SAR $price',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff072D6F)),
                  ),
                  Text('/ $duration months',
                      style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff072D6F)))
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
      ],
    );
  }
}
