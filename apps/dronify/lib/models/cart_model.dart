import 'package:dronify/models/order_model.dart';

class CartModel {
  final List<OrderModel> items = [];

  double get totalPrice => items.fold(0, (sum, item) => sum + (item.totalPrice ?? 0));

  void addItem({required OrderModel item}) {
    items.add(item);
  }

  void removeItem(int itemId) {
    items.removeWhere((item) => item.orderId == itemId);
  }

  void clearCart() {
    items.clear();
  }
}
