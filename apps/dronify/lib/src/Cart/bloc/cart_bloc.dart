import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dronify/layer/data_layer.dart';
import 'package:dronify/models/cart_model.dart';
import 'package:dronify/models/order_model.dart';
import 'package:dronify/models/payment_model.dart';
import 'package:dronify/src/Cart/bloc/cart_event.dart';
import 'package:dronify/src/Cart/bloc/cart_state.dart';
import 'package:dronify/utils/db_operations.dart';
import 'package:dronify/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moyasar/moyasar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final DataLayer dataLayer = GetIt.instance<DataLayer>();
  final SupabaseClient supabase = Supabase.instance.client;
  CartModel cart = CartModel();

  CartBloc() : super(CartLoading()) {
    on<LoadCartItemsEvent>((event, emit) => _loadCartItems(emit));
    on<AddToCartEvent>((event, emit) => _addItemToCart(event.order, emit));
    on<RemoveFromCartEvent>(
        (event, emit) => _removeItemFromCart(event.orderId, emit));
    on<SubmitCart>((event, emit) => _submitCart(emit));
  }

  void _loadCartItems(Emitter<CartState> emit) {
    cart = dataLayer.cart;
    emit(CartUpdated(cart: cart));
  }

  void _addItemToCart(OrderModel order, Emitter<CartState> emit) {
    dataLayer.cart.addItem(item: order);
    cart = dataLayer.cart;
    emit(CartUpdated(cart: dataLayer.cart));
  }

  double get totalPrice {
    final price = dataLayer.cart.items
        .fold(0, (num sum, item) => sum + (item.totalPrice ?? 0))
        .toDouble();
    return price > 0 ? price : 0;
  }

  PaymentConfig pay() {
    final amount = (totalPrice * 100).toInt();

    if (amount <= 0) {
      log("Error: Total price must be positive for payment.");
    }

    return PaymentConfig(
      publishableApiKey: dotenv.env['moyasar_test_key']!,
      amount: amount,
      description: 'Dronify Order',
      metadata: {'orderId': '1', 'customer': 'customer'},
      creditCard: CreditCardConfig(saveCard: true, manual: false),
    );
  }

  void onPaymentResult(result, BuildContext context, List<OrderModel> orders) {
    if (result is PaymentResponse) {
      switch (result.status) {
        case PaymentStatus.paid:
          _handleSuccessfulPayment(context, orders);
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

  Future<void> _handleSuccessfulPayment(
      BuildContext context, List<OrderModel> orders) async {
    for (var order in orders) {
      List<XFile> imageFiles =
          order.images?.map((imagePath) => XFile(imagePath)).toList() ?? [];

      saveOrder(
        orderId: order.orderId!,
        customerId: order.customerId!,
        serviceId: order.serviceId!,
        squareMeters: order.squareMeters!,
        reservationDate: order.reservationDate!,
        reservationTime: TimeOfDay.now(),
        totalPrice: order.totalPrice!,
        imageUrls: [],
        latitude: order.address![0],
        longitude: order.address![1],
        imageFiles: imageFiles ?? [],
      );

      //   await _savePayment(
      //       orderId: order.orderId!,
      //       customerId: order.customerId!,
      //       amount: order.totalPrice!);
    }

    add(LoadCartItemsEvent());
    _showSnackBar(context, 'Payment successful!');
  }

  // Future<void> _savePayment({
  //   required int orderId,
  //   required String customerId,
  //   required double amount,
  // }) async {
  //   try {
  //     // final payment = PaymentModel(
  //     //   orderId: orderId,
  //     //   userId: customerId,
  //     //   amount: amount,
  //     // );

  //     // final paymentData = payment.toJson();
  //     //   paymentData.remove('payment_id');
  //     //  log('$paymentData');
  //     await supabase.from('payment').insert({
  //       'order_id': orderId,
  //       'user_id': customerId,
  //       'amount': amount,
  //     });
  //     log("Payment saved for order ID: $orderId");
  //   } catch (error) {
  //     log("Error saving payment: $error");
  //   }
  // }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _removeItemFromCart(int orderId, Emitter<CartState> emit) {
    emit(CartLoading());

    dataLayer.cart.removeItem(orderId);

    cart = dataLayer.cart;

    emit(CartUpdated(cart: cart));

    add(LoadCartItemsEvent());
  }

  void _submitCart(Emitter<CartState> emit) async {
    locator.get<DataLayer>().fetchCustomerOrders();
    dataLayer.cart.clearCart();
    cart.clearCart();
    emit(CartSubmitted(cart: dataLayer.cart));
    add(LoadCartItemsEvent());
  }
}
