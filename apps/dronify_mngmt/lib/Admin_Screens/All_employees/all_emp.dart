import 'package:dronify_mngmt/Admin_Screens/EmployeeDetails/employee_details_screen.dart';
import 'package:dronify_mngmt/Admin_Screens/All_employees/employeecard.dart';
import 'package:dronify_mngmt/Admin_Screens/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/Auth/signup.dart';
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final employee =
                    locator.get<AdminDataLayer>().allEmployees[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EmployeeDetailsScreen(employee: employee),
                      ),
                    );
                  },
                  child: EmployeeCardWidget(employee: employee),
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
