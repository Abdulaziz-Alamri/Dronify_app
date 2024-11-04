import 'package:dronify/models/customer_model.dart';
import 'package:dronify/models/service_model.dart';
import 'package:dronify/models/order_model.dart';
import 'package:dronify/models/cart_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataLayer {
  final CartModel cart = CartModel();
  List<ServiceModel> allServices = [];
  CustomerModel? customer;
  List<OrderModel> allCustomerOrders = [];

  String? externalKey;
  final box = GetStorage();

  final supabase = Supabase.instance.client;

  DataLayer() {
    loadData();
    fetchServices();
    if (supabase.auth.currentUser != null) {
      fetchCustomerOrders();
    }
  }

  loadData() async {
    if (box.hasData('external_key')) {
      externalKey = box.read('external_key');
    }
  }

  saveData() async {
    await box.write('external_key', externalKey);
  }

  onLogout() async {
    box.erase();
  }

  Future<List<OrderModel>> fetchCustomerOrders() async {
    allCustomerOrders.clear();
    final allOrdersResponse = await supabase
        .from('orders')
        .select('*')
        .eq('user_id', supabase.auth.currentUser!.id);

    if (allOrdersResponse.isNotEmpty) {
      for (var map in allOrdersResponse) {
        OrderModel order = OrderModel.fromJson(map);
        allCustomerOrders.add(order);
      }
    }
    return allCustomerOrders;
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
    }
  }

  // Store or update customer data in Supabase
  Future<void> upsertCustomer(CustomerModel customer) async {
    try {
      await supabase.from('app_user').upsert(customer.toJson());
    } catch (e) {
    }
  }

  Future<CustomerModel?> getCustomer(String customerId) async {
    try {
      final response = await supabase
          .from('app_user')
          .select()
          .eq('user_id', customerId)
          .maybeSingle();


      if (response != null) {
        final fetchedCustomer = CustomerModel.fromJson({
          'customer_id': response['user_id'] ?? '',
          'name': response['name'] ?? 'Unknown',
          'email': response['email'] ?? 'no-email@example.com',
          'phone': response['phone'] ?? 'N/A',
          'role': response['role'] ?? 'customer'
        });

       
        return fetchedCustomer;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void saveCustomerData(CustomerModel customerData) {
    customer = customerData;
  }

  Future<void> updateCustomerProfile({
    required String name,
    required String phone,
  }) async {
    final userId = supabase.auth.currentUser!.id;
    await supabase.from('app_user').update({
      'name': name,
      'phone': phone,
    }).eq('user_id', userId);
  }
}
