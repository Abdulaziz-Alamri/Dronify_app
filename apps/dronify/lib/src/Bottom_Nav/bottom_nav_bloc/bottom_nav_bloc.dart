import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dronify/src/Cart/cart_screen.dart';
import 'package:dronify/src/Home/home_screen.dart';
import 'package:dronify/src/Order/order_screen.dart';
import 'package:dronify/src/profile/profile_screen.dart';
import 'package:flutter/material.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  List<Widget> views = [
    HomeScreen(),
    OrderScreen(),
    CartScreen(),
    ProfileScreen()
  ];

  int currentIndex = 0;

  BottomNavBloc() : super(BottomNavInitial()) {
    on<ChangeEvent>(changeMethod);
    on<HideBottomNavEvent>((event, emit) => emit(HideBottomNavState()));
    on<ShowBottomNavEvent>((event, emit) => emit(ShowBottomNavState()));
  }

  FutureOr<void> changeMethod(ChangeEvent event, Emitter<BottomNavState> emit) {
    currentIndex = event.index;
    emit(SuccessChangeViewState(currentIndex));
  }
}