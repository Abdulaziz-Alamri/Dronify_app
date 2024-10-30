import 'dart:developer';

import 'package:dronify_mngmt/Employee_Home/bloc/orders_bloc_bloc.dart';
import 'package:dronify_mngmt/models/employee_model.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:dronify_mngmt/models/service_model.dart';

class AdminDataLayer {
  List<ServiceModel> allServices = [];
  List<OrderModel> completeOrders = [];
  List<OrderModel> incompleteOrders = [];
  List<OrderModel> availableOrders = [];

  List<OrderModel> emoCompleteOrders = [];
  List<OrderModel> empIncompleteOrders = [];
  List<OrderModel> empAvailableOrders = [];
  List<EmployeeModel> allEmployees = [];

  AdminDataLayer() {
    fetchServices();
    fetchOrders();
    fetchEmployees();

    fetchEmpOrders();
  }

  fetchServices() async {
    final response = await supabase
        .from('service')
        .select('*')
        .order('service_id', ascending: true);

    for (var object in response) {
      ServiceModel service = ServiceModel.fromJson(object);
      allServices.add(service);
    }
  }

  fetchOrders() async {
    try {
      final completeOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name), images(image_url), address(latitude, longitude)')
          .eq('status', 'complete');

      for (var element in completeOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        completeOrders.add(order);
      }

      final incompleteOrdersResponse = await supabase
          .from('orders')
          .select(
              '*, app_user!inner(name, phone), service(name), images(image_url), address(latitude, longitude)')
          .eq('status', 'confirmed');

      for (var element in incompleteOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        incompleteOrders.add(order);
      }

      final availableOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name), images(image_url), address(latitude, longitude)')
          .eq('status', 'pending');

      for (var element in availableOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        availableOrders.add(order);
      }
    } catch (error) {
      print("Error fetching orders: $error");
    }
  }

  fetchEmpOrders() async {
    try {
      final completeOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name)')
          .eq('status', 'complete')
          .eq('user_id', '4252d26b-19f6-4f98-9f5a-a3ddc18f2fdd');

      for (var element in completeOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        completeOrders.add(order);
      }

      final incompleteOrdersResponse = await supabase
          .from('orders')
          .select(
              '*, app_user!inner(name, phone), service(name), address(latitude, longitude), images(image_url)')
          .eq('status', 'confirmed')
          .eq('user_id', '4252d26b-19f6-4f98-9f5a-a3ddc18f2fdd');

      for (var element in incompleteOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        incompleteOrders.add(order);
      }

      final availableOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name)')
          .eq('status', 'pending');

      for (var element in availableOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        availableOrders.add(order);
      }
    } catch (error) {
      print("Error fetching orders: $error");
    }
  }

  fetchEmployees() async {
    try {
      final employeesResponse = await supabase.from('employee').select(
          'employee_id, position, rating, image_url, app_user(name, email, phone, role)');

      for (var element in employeesResponse) {
        EmployeeModel emp = EmployeeModel.fromJson(element);
        allEmployees.add(emp);
      }
    } catch (error) {
      print("Error fetching employees: $error");
    }
  }
}
