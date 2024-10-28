import 'package:dronify_mngmt/Admin/EmployeeDetails/employee.dart';
import 'package:dronify_mngmt/Admin/All_employees/employeecard.dart';
import 'package:dronify_mngmt/Admin/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/utils/setup.dart';
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
            backgroundColor: Colors.white,
            pinned: false,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // final List<Map<String, dynamic>> employees = List.generate(
                //   10,
                //   (index) => {
                //     'name': 'Employee ${index + 1}',
                //     'phone': '0966 ${9000 + index}',
                //     'rating': (index % 5 + 1).toDouble(),
                //     'image': 'assets/Avatar.png',
                //   },
                // );

                final employee = locator.get<AdminDataLayer>().allEmployees[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeDetailsPage(
                          employee:employee
                        ),
                      ),
                    );
                  },
                  child: EmployeeCardWidget(
                   employee:employee
                  ),
                );
              },
              childCount: locator.get<AdminDataLayer>().allEmployees.length,
            ),
          ),
        ],
      ),
    );
  }
}
