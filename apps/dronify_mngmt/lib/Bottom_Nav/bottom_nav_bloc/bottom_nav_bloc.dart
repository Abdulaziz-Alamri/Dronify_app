import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dronify_mngmt/Admin/All_employees/all_emp.dart';
import 'package:dronify_mngmt/Admin/Admin_Orders/all_orders.dart';
import 'package:dronify_mngmt/Admin/Admin_Home/admin_home.dart';
import 'package:dronify_mngmt/Admin/Admin_Profile/profile_screen.dart';

import 'package:flutter/material.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  List<Widget> views = [AdminHome(), AllOrders(), AllEmp(), ProfileScreen()];

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
