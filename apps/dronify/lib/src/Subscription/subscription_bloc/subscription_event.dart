part of 'subscription_bloc.dart';

@immutable
sealed class SubscriptionEvent {}

final class LoadEvent extends SubscriptionEvent {}

final class SelectRadioEvent extends SubscriptionEvent {
  final int selectedIndex;
  final bool value;

  SelectRadioEvent({required this.selectedIndex, required this.value});
}

final class PickImageEvent extends SubscriptionEvent {}

final class RemovedImageEvent extends SubscriptionEvent {
  final List<XFile> images;

  RemovedImageEvent({required this.images});
}

final class PickDateEvent extends SubscriptionEvent {
  final BuildContext context;

  PickDateEvent({required this.context});
}

final class FetchLocationEvent extends SubscriptionEvent {}

final class PinLocationEvent extends SubscriptionEvent {
  final TapPosition tapPosition;
  final LatLng point;

  PinLocationEvent({required this.tapPosition, required this.point});
}

final class SetUnitCountEvent extends SubscriptionEvent {
  final int count;

  SetUnitCountEvent({required this.count});
}

final class ToggleIsFromRiyadhEvent extends SubscriptionEvent {}

final class SubmitSubscriptionEvent extends SubscriptionEvent {}
