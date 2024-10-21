import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dronify_mngmt/Admin_Home/admin_home.dart';

import 'package:flutter/material.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  List<Widget> views = [
   AdminHome(),
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
