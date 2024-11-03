import 'dart:developer';
import 'package:dronify/layer/data_layer.dart';
import 'package:dronify/models/service_model.dart';
import 'package:dronify/src/Bottom_Nav/bottom_nav.dart';
import 'package:dronify/src/Cart/bloc/cart_bloc.dart';
import 'package:dronify/src/Cart/bloc/cart_event.dart';
import 'package:dronify/src/Cart/bloc/cart_state.dart';
import 'package:dronify/src/Cart/cart_item_card.dart';
import 'package:dronify/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moyasar/moyasar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<ServiceModel> allServices = locator.get<DataLayer>().allServices;

    return BlocProvider(
      create: (context) => CartBloc()..add(LoadCartItemsEvent()),
      child: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Payment successful!")),
            );
          }
        },
        child: Builder(builder: (context) {
          final bloc = context.read<CartBloc>();
          return Scaffold(
            backgroundColor: const Color(0xffF5F5F7),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 80.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/appbar1.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    title: const Text(
                      'Cart',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  pinned: false,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Items',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(
                          color: Color(0xffCDCDCD),
                          indent: 4,
                          endIndent: 4,
                        ),
                        const SizedBox(height: 15),
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            if (state is CartLoading) {
                              return Image.asset(
                                'assets/drone.gif',
                                height: 50,
                                width: 50,
                              );
                            } else if (state is CartUpdated) {
                              return Column(
                                children: [
                                  ...state.cart.items.map((item) {
                                    final service = (item.serviceId != null &&
                                            item.serviceId! <=
                                                allServices.length)
                                        ? allServices[item.serviceId! - 1]
                                        : null;

                                    return Column(
                                      children: [
                                        CartItemCard(
                                          order: item,
                                          servic: service!,
                                          onDelete: () {
                                            context.read<CartBloc>().add(
                                                RemoveFromCartEvent(
                                                    item.orderId!));
                                          },
                                        ),
                                        const SizedBox(height: 15),
                                      ],
                                    );
                                  }).toList(),
                                  const Divider(
                                    color: Color(0xffCDCDCD),
                                    indent: 4,
                                    endIndent: 4,
                                  ),
                                ],
                              );
                            }
                            return const Center(
                                child: Text('No items in the cart.'));
                          },
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Discount Codes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter discount code',
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.local_offer),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            if (state is CartUpdated) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    height: 80,
                                    width: 400,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 2,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${state.cart.totalPrice} SAR',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              height: 40,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF072D6F),
                                                    Color(0xFF0A3F9A),
                                                    Color(0xFF0A43A4),
                                                    Color(0xFF0D56D5),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (bloc
                                                      .cart.items.isNotEmpty)
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .vertical(
                                                          top: Radius.circular(
                                                              25.0),
                                                        ),
                                                      ),
                                                      builder: (BuildContext
                                                          context) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 12,
                                                            left: 12,
                                                            right: 12,
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom,
                                                          ),
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                CreditCard(
                                                                  config: bloc
                                                                      .pay(),
                                                                  onPaymentResult:
                                                                      (result) async {
                                                                    bloc.onPaymentResult(
                                                                        result,
                                                                        context,
                                                                        state
                                                                            .cart
                                                                            .items);
                                                                    Navigator.pop(
                                                                        context,
                                                                        'Payment successful');
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) async {
                                                      if (value ==
                                                          'Payment successful') {
                                                        bloc.cart.clearCart();
                                                        bloc.add(
                                                            LoadCartItemsEvent());
                                                        await Future.delayed(
                                                            const Duration(
                                                                seconds: 2));
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const BottomNav(
                                                                    index: 1,
                                                                  )),
                                                        );
                                                      }
                                                    });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Pay',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, Size size) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
