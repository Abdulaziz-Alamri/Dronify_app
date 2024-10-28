import 'package:dronify_mngmt/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EmployeeCardWidget extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeCardWidget({
    super.key,
   required this.employee
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 6, // Adjusted shadow elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: Colors.black.withOpacity(0.25), // Darker shadow color
        color: Colors.white, // Set background to white
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(employee.imageUrl ?? 'assets/pfp_emp.png'),
                radius: 30,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(employee.phone),
                ],
              ),
              const Spacer(),
              RatingBarIndicator(
                rating: employee.rating ?? 0,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
