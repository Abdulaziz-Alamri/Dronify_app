import 'dart:developer';

import 'package:dronify/models/customer_model.dart';
import 'package:dronify/models/service_model.dart';
import 'package:dronify/models/order_model.dart';
import 'package:dronify/models/cart_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataLayer {
  final CartModel cart = CartModel();
  List<ServiceModel> allServices = [];
  CustomerModel? customer;
  List<OrderModel> allCustomerOrders = [];

  final supabase = Supabase.instance.client;

  DataLayer() {
    fetchServices();
    if (supabase.auth.currentUser != null) {
      fetchCustomerOrders();
    }
  }

  fetchCustomerOrders() async {
    final allOrdersResponse = await supabase
        .from('orders')
        .select('*')
        .eq('user_id', '4252d26b-19f6-4f98-9f5a-a3ddc18f2fdd');
    log('$allOrdersResponse');
    if (allOrdersResponse.isNotEmpty)
      for (var map in allOrdersResponse) {
        OrderModel order = OrderModel.fromJson(map);
        allCustomerOrders.add(order);
      }
          log('$allCustomerOrders');

  }

  void addToCart(OrderModel order) {
    cart.addItem(item: order);
  }

  // Fetch services from Supabase
  Future<void> fetchServices() async {
    try {
      final response = await supabase
          .from('service')
          .select('*')
          .order('service_id', ascending: true);

      for (var object in response) {
        ServiceModel service = ServiceModel.fromJson(object);
        allServices.add(service);
      }
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  // Store or update customer data in Supabase
  Future<void> upsertCustomer(CustomerModel customer) async {
    try {
      await supabase.from('app_user').upsert(customer.toJson());
      print('Customer upserted successfully');
    } catch (e) {
      print('Error upserting customer: $e');
    }
  }

  Future<CustomerModel?> getCustomer(String customerId) async {
    try {
      final response = await supabase
          .from('app_user')
          .select()
          .eq('user_id', customerId)
          .maybeSingle();

      print("Supabase response: $response");

      // تحقق من أن البيانات المسترجعة ليست null قبل إنشاء CustomerModel
      if (response != null && response is Map<String, dynamic>) {
        final fetchedCustomer = CustomerModel.fromJson({
          'customer_id': response['user_id'] ?? '',
          'name': response['name'] ?? 'Unknown',
          'email': response['email'] ?? 'no-email@example.com',
          'phone': response['phone'] ?? 'N/A',
          'role': response['role'] ?? 'customer'
        });

        print(
            'Customer data fetched successfully: ${fetchedCustomer.toJson()}');
        return fetchedCustomer;
      } else {
        print('No customer data found for user ID: $customerId');
        return null;
      }
    } catch (e) {
      print('Error fetching customer: $e');
      return null;
    }
  }

  void saveCustomerData(CustomerModel customerData) {
    customer = customerData;
    print('Customer data saved locally: ${customerData.toJson()}');
  }
}
