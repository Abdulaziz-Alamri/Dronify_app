import 'package:dronify_mngmt/Admin_Home/All_employees/employeecard.dart';
import 'package:flutter/material.dart';

class AllEmp extends StatelessWidget {
  const AllEmp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/appbar1.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              title: const Text(
                'All Employees',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            backgroundColor: Colors.transparent,
            pinned: false,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final List<Map<String, dynamic>> employees = List.generate(
                  10,
                  (index) => {
                    'name': 'Employee ${index + 1}',
                    'phone': '0966 578${9000 + index}',
                    'rating': (index % 5 + 1).toDouble(),
                    'image': 'assets/Avatar.png',
                  },
                );

                // Access employee data
                final employee = employees[index];

                return EmployeeCardWidget(
                  name: employee['name']!,
                  phone: employee['phone']!,
                  rating: employee['rating']!,
                  image: employee['image']!,
                );
              },
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
