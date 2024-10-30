import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'scrollsplash_event.dart';
part 'scrollsplash_state.dart';

class ScrollsplashBloc extends Bloc<ScrollsplashEvent, ScrollsplashState> {
  int currentIndex = 0;
  ScrollsplashBloc() : super(ScrollsplashInitial()) {
    on<ChangeIndexEvent>(changeIndex);
  }

  FutureOr<void> changeIndex(
      ChangeIndexEvent event, Emitter<ScrollsplashState> emit) {
    currentIndex = event.currentIndex;
    emit(ChangedIndexState(currentIndex: event.currentIndex));
  }
}
