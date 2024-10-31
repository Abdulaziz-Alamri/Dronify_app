import 'dart:developer';

import 'package:dronify_mngmt/Admin/EmployeeDetails/complete_order_card.dart';
import 'package:dronify_mngmt/Admin/EmployeeDetails/completed_orders_data.dart';
import 'package:dronify_mngmt/Employee_Home/bloc/orders_bloc_bloc.dart';
import 'package:dronify_mngmt/models/employee_model.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final EmployeeModel employee;

  const EmployeeDetailsScreen({super.key, required this.employee});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  late Future<CompletedOrdersData> completedOrdersData;

  @override
  void initState() {
    completedOrdersData =
        getCompletedOrdersData(employeeId: widget.employee.employeeId);
    super.initState();
  }

  Future<CompletedOrdersData> getCompletedOrdersData(
      {required String employeeId}) async {
    try {
      final response =
          await supabase.from('orders').select().eq('employee_id', employeeId);

      int totalOrders = response.length;
      int completedOrdersCount =
          response.where((order) => order['status'] == 'complete').length;

      // Calculate the percentage of completed orders
      final completedPercentage =
          totalOrders > 0 ? (completedOrdersCount / totalOrders) : 0.0;

      // Fetch the list of completed orders
      List<OrderModel> completedOrdersList = response
          .where((order) => order['status'] == 'complete')
          .map<OrderModel>((order) => OrderModel.fromJson(order))
          .toList();

      return CompletedOrdersData(
        completedPercentage: completedPercentage,
        completedOrders: completedOrdersList,
      );
    } catch (error) {
      print("Error fetching completed orders data: $error");
      return CompletedOrdersData(completedPercentage: 0.0, completedOrders: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.employee.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(
                          widget.employee.imageUrl ?? 'assets/pfp_emp.png'),
                      radius: 50,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${widget.employee.name}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Phone: ${widget.employee.phone}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Rating: ',
                                style: TextStyle(fontSize: 18),
                              ),
                              RatingBarIndicator(
                                rating: widget.employee.rating ?? 0,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(right: 17.h),
                child: Text(
                  'Complete Orders',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
              ),
              FutureBuilder<CompletedOrdersData>(
                future: completedOrdersData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LinearProgressIndicator(
                      minHeight: 2.5.h,
                      value: 0,
                      backgroundColor: Colors.white,
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error loading data');
                  } else {
                    return Container(
                      height: 2.5.h,
                      width: 81.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.4)),
                      ),
                      child: LinearProgressIndicator(
                        minHeight: 2.5.h,
                        value: snapshot.data?.completedPercentage ?? 0.0,
                        borderRadius: BorderRadius.circular(25),
                        backgroundColor: Colors.white,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xff072D6F)),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Employee Name', 'John Doe'),
                    const SizedBox(height: 16),
                    _buildTextField('Email', 'john.doe@example.com'),
                    const SizedBox(height: 16),
                    _buildTextField('Gender', 'Male'),
                    const SizedBox(height: 16),
                    _buildTextField('Date of Birth', '01/01/1990'),
                    const SizedBox(height: 16),
                    _buildTextField('Phone Number', '0966 5789033'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 16),
              FutureBuilder<CompletedOrdersData>(
                future: completedOrdersData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading data');
                  } else {
                    return Column(
                      children: List.generate(
                          snapshot.data?.completedOrders.length ?? 0, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            children: [
                              if (index == 0)
                                Text(
                                  'Completed Orders',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp),
                                ),
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: CompleteOrderCard(
                                  order: snapshot.data!.completedOrders[index],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: const Color(0xffF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}