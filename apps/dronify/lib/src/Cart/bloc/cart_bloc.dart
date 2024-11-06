import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dronify/layer/data_layer.dart';
import 'package:dronify/models/cart_model.dart';
import 'package:dronify/models/order_model.dart';
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
    on<LoadCartItemsEvent>(loadCartItems);
    on<AddToCartEvent>(addItemToCart);
    on<RemoveFromCartEvent>(removeItemFromCart);
    on<SubmitCart>(submitCart);
    on<SuccessfulEvent>(successfulPayment);
    on<FailedEvent>(failedPayment);
  }

  FutureOr<void> loadCartItems(
      LoadCartItemsEvent event, Emitter<CartState> emit) {
    cart = dataLayer.cart;
    emit(CartUpdated(cart: cart));
  }

  FutureOr<void> addItemToCart(AddToCartEvent event, Emitter<CartState> emit) {
    dataLayer.cart.addItem(item: event.order);
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

    return PaymentConfig(
      publishableApiKey: dotenv.env['moyasar_test_key']!,
      amount: amount,
      description: 'Dronify Order',
      metadata: {'orderId': '1', 'customer': 'customer'},
      creditCard: CreditCardConfig(saveCard: true, manual: false),
    );
  }

  void onPaymentResult(
      result, BuildContext context, List<OrderModel> orders) async {
    if (result is PaymentResponse) {
      switch (result.status) {
        case PaymentStatus.paid:
          await handleSuccessfulPayment(context, orders);
          if (!isClosed) add(SuccessfulEvent());
          break;
        case PaymentStatus.failed:
          if (!isClosed) add(FailedEvent());
          break;
        case PaymentStatus.initiated:
        case PaymentStatus.authorized:
        case PaymentStatus.captured:
          break;
      }
    }
  }

  Future<void> handleSuccessfulPayment(
      BuildContext context, List<OrderModel> orders) async {
    List<OrderModel> processedOrders = List.from(orders);
    bool isDifferent = false;
    final orderIdData = await getOrderId(isChecking: true);
    if (orderIdData != processedOrders[0].orderId) {
      isDifferent = true;
    }
    for (int i = 0; i < processedOrders.length; i++) {
      if (isDifferent) {
        processedOrders[i].orderId = orderIdData! + i;
      }
      List<XFile> imageFiles = processedOrders[i]
              .images
              ?.map((imagePath) => XFile(imagePath))
              .toList() ??
          [];

      await saveOrder(
        orderId: processedOrders[i].orderId!,
        customerId: processedOrders[i].customerId!,
        serviceId: processedOrders[i].serviceId!,
        squareMeters: processedOrders[i].squareMeters!,
        reservationDate: processedOrders[i].reservationDate!,
        reservationTime: TimeOfDay.now(),
        totalPrice: processedOrders[i].totalPrice!,
        imageUrls: [],
        latitude: processedOrders[i].address![0],
        longitude: processedOrders[i].address![1],
        imageFiles: imageFiles,
      );
    }
  }

  FutureOr<void> removeItemFromCart(
      RemoveFromCartEvent event, Emitter<CartState> emit) {
    emit(CartLoading());
    dataLayer.cart.removeItem(event.orderId);
    cart = dataLayer.cart;
    emit(CartUpdated(cart: cart));
    add(LoadCartItemsEvent());
  }

  FutureOr<void> submitCart(SubmitCart event, Emitter<CartState> emit) {
    locator.get<DataLayer>().fetchCustomerOrders();
    dataLayer.cart.clearCart();
    cart.clearCart();
    emit(CartSubmitted(cart: dataLayer.cart));
    add(LoadCartItemsEvent());
  }

  FutureOr<void> failedPayment(FailedEvent event, Emitter<CartState> emit) {
    emit(CartPaymentFailed(message: 'Payment Failed'));
  }

  FutureOr<void> successfulPayment(
      SuccessfulEvent event, Emitter<CartState> emit) {
    emit(CartPaymentSuccessful(message: 'Payment Successfull!'));
  }
}
