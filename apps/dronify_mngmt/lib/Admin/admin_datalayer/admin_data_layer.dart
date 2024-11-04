import 'package:dronify_mngmt/models/employee_model.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:dronify_mngmt/models/service_model.dart';
import 'package:dronify_mngmt/utils/db_operations.dart';
import 'package:get_storage/get_storage.dart';

class AdminDataLayer {
  List<ServiceModel> allServices = [];
  List<OrderModel> completeOrders = [];
  List<OrderModel> incompleteOrders = [];
  List<OrderModel> availableOrders = [];

  List<OrderModel> empCompleteOrders = [];
  List<OrderModel> empIncompleteOrders = [];
  List<OrderModel> empAvailableOrders = [];
  List<EmployeeModel> allEmployees = [];

  EmployeeModel? currentEmployee;

  String? externalKey;
  final box = GetStorage();

  AdminDataLayer() {
    loadData();
    fetchServices();
    fetchOrders();
    fetchEmployees();

    if (supabase.auth.currentUser != null) {
      if (supabase.auth.currentUser!.userMetadata?['role'] == 'employee') {
        fetchEmpOrders();
      }
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
    completeOrders.clear();
    incompleteOrders.clear();
    availableOrders.clear();
    try {
      final completeOrdersResponse = await supabase
          .from('orders')
          .select(
              '*, app_user!inner(name, phone), service(name), images(image_url, type), address(latitude, longitude)')
          .eq('status', 'complete');

      for (var element in completeOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        completeOrders.add(order);
      }

      final incompleteOrdersResponse = await supabase
          .from('orders')
          .select(
              '*, app_user!inner(name, phone), service(name), images(image_url, type), address(latitude, longitude)')
          .eq('status', 'confirmed');

      for (var element in incompleteOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        incompleteOrders.add(order);
      }

      final availableOrdersResponse = await supabase
          .from('orders')
          .select(
              '*, app_user!inner(name, phone), service(name), images(image_url, type), address(latitude, longitude)')
          .eq('status', 'pending');

      for (var element in availableOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        availableOrders.add(order);
      }
    } catch (error) {
    }
  }

  fetchEmpOrders() async {
    empCompleteOrders.clear();
    empIncompleteOrders.clear();
    empAvailableOrders.clear();
    try {
      try {
        if (supabase.auth.currentUser != null) {
          if (supabase.auth.currentUser!.userMetadata?['role'] == 'employee') {
            final employeeData = await supabase
                .from('employee')
                .select('*, app_user(name, email, phone, role)')
                .eq('employee_id', supabase.auth.currentUser!.id);

            currentEmployee = EmployeeModel.fromJson(employeeData[0]);
          }
        }
      } catch (e) {
      }

      final completeOrdersResponse = await supabase
          .from('orders')
          .select(
              '*, app_user!inner(name, phone), service(name),address(latitude, longitude), images(image_url, type)')
          .eq('status', 'complete')
          .eq('employee_id', supabase.auth.currentUser!.id);

      for (var element in completeOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        empCompleteOrders.add(order);
      }

      final incompleteOrdersResponse = await supabase
          .from('orders')
          .select(
              '*, app_user!inner(name, phone), service(name), address(latitude, longitude), images(image_url, type)')
          .eq('status', 'confirmed')
          .eq('employee_id', supabase.auth.currentUser!.id);

      for (var element in incompleteOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        empIncompleteOrders.add(order);
      }

      final availableOrdersResponse = await supabase
          .from('orders')
          .select(
              '*, app_user!inner(name, phone), service(name),address(latitude, longitude), images(image_url,type)')
          .eq('status', 'pending');

      for (var element in availableOrdersResponse) {
        OrderModel order = OrderModel.fromJson(element);
        empAvailableOrders.add(order);
      }
    } catch (error) {
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
    }
  }
}
