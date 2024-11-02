import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  int rating = 0;
  OrderBloc() : super(OrderInitial()) {
    on<RateOrderEvent>(rateOrder);
  }

  FutureOr<void> rateOrder(
      RateOrderEvent event, Emitter<OrderState> emit) async {
    rating = event.rating;
    emit(RateOrderState(rating: event.rating));
  }
}
