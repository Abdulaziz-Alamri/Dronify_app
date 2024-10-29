import 'package:dronify/models/service_model.dart';
import 'package:dronify/utils/db_operations.dart';
import 'package:get_it/get_it.dart';
import 'package:dronify/models/order_model.dart';
import 'package:dronify/models/cart_model.dart';

class DataLayer {
  final CartModel cart = CartModel();
  List<ServiceModel> allServices = [];
  DataLayer() {
    fetchServices();
  }
  void addToCart(OrderModel order) {
    cart.addItem(item: order);
  }

  void loadData() {}
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
}
