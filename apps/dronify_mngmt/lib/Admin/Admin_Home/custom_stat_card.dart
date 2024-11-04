import 'package:flutter/material.dart';

class CustomStatCard extends StatelessWidget {
  final String title;
  final String value;
  const CustomStatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          height: 55,
          width: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff072D6F)),
              ),
              if (int.parse(value) > 1000 && int.parse(value) < 1000000)
                Text(
                  '${(double.parse(value) / 1000).toStringAsFixed(1)}K',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff73DDFF)),
                )
              else if (int.parse(value) > 1000000)
                Text(
                  '${(double.parse(value) / 1000).toStringAsFixed(1)}M',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff73DDFF)),
                )
              else
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff73DDFF)),
                )
            ],
          )),
    );
  }
}
