abstract class OrderEvent {}

class FetchOrderData extends OrderEvent {
  final int orderId;
  FetchOrderData(this.orderId);
}

class GetCurrentLocation extends OrderEvent {}

class PickImages extends OrderEvent {}
