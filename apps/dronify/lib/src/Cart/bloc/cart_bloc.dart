import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dronify/Data_layer/data_layer.dart';
import 'package:dronify/models/cart_model.dart';
import 'package:dronify/models/order_model.dart';
import 'package:dronify/src/Cart/bloc/cart_event.dart';
import 'package:dronify/src/Cart/bloc/cart_state.dart';
import 'package:dronify/utils/db_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moyasar/moyasar.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final DataLayer dataLayer = GetIt.instance<DataLayer>();
  CartModel cart = CartModel();

  CartBloc() : super(CartLoading()) {
    on<LoadCartItemsEvent>((event, emit) => _loadCartItems(emit));
    on<AddToCartEvent>((event, emit) => _addItemToCart(event.order, emit));
    on<RemoveFromCartEvent>(
        (event, emit) => _removeItemFromCart(event.orderId, emit));
    on<SubmitCart>((event, emit) => _submitCart(emit));
  }

  void _loadCartItems(Emitter<CartState> emit) {
    emit(CartUpdated(cart: dataLayer.cart));
  }

  void _addItemToCart(OrderModel order, Emitter<CartState> emit) {
    dataLayer.cart.addItem(item: order);
    cart = dataLayer.cart;
    emit(CartUpdated(cart: dataLayer.cart));
  }

  double get totalPrice =>
      dataLayer.cart.items.fold(0, (sum, item) => sum + (item.totalPrice ?? 0));

  PaymentConfig pay() {
    log('0');
    final paymentConfig = PaymentConfig(
      publishableApiKey: dotenv.env['moyasar_test_key']!,
      amount: (totalPrice * 100).toInt(),
      description: 'Dronify Order',
      metadata: {'orderId': '1', 'customer': 'customer'},
      creditCard: CreditCardConfig(saveCard: true, manual: false),
    );
    return paymentConfig;
  }

  void onPaymentResult(result, BuildContext context, OrderModel order) {
    if (result is PaymentResponse) {
      switch (result.status) {
        case PaymentStatus.paid:
          log('1');
          saveOrder(
              customerId: order.customerId!,
              serviceId: order.serviceId!,
              squareMeters: order.squareMeters!,
              reservationDate: order.reservationDate!,
              reservationTime: TimeOfDay.now(),
              totalPrice: order.totalPrice!,
              imageUrls: [],
              latitude: order.address![0],
              longitude: order.address![1],
              imageFiles: order.images!.map((image) => XFile(image)).toList());
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Payment successful!'),
          ));
          break;
        case PaymentStatus.failed:
          _showSnackBar(context, 'Payment failed. Please try again.');
          break;
        case PaymentStatus.initiated:
        case PaymentStatus.authorized:
        case PaymentStatus.captured:
          break;
      }
    }
  }

  void _handleSuccessfulPayment(BuildContext context, OrderModel order) async {
    log('2');
    List<XFile> images = order.images!.map((path) => XFile(path)).toList();
    await saveOrder(
        customerId: order.customerId!,
        serviceId: order.serviceId!,
        squareMeters: order.squareMeters!,
        reservationDate: order.reservationDate!,
        reservationTime: TimeOfDay.now(),
        totalPrice: order.totalPrice!,
        imageUrls: [],
        latitude: order.address![0],
        longitude: order.address![1],
        imageFiles: images);
    // dataLayer.cart.clearCart();
    add(LoadCartItemsEvent());
    _showSnackBar(context, 'Payment successful!');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _removeItemFromCart(int orderId, Emitter<CartState> emit) {
    dataLayer.cart.removeItem(orderId);
    emit(CartUpdated(cart: dataLayer.cart));
  }

  void _submitCart(Emitter<CartState> emit) {
    dataLayer.cart.clearCart();
    emit(CartSubmitted(cart: dataLayer.cart));
  }
}
