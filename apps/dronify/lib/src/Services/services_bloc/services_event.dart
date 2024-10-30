part of 'services_bloc.dart';

@immutable
sealed class ServicesEvent {}

final class LoadEvent extends ServicesEvent {}

final class PickImageEvent extends ServicesEvent {}

final class RemovedImageEvent extends ServicesEvent {
  final List<XFile> images;

  RemovedImageEvent({required this.images});
}

final class FetchLocationEvent extends ServicesEvent {}

final class PickDateEvent extends ServicesEvent {
  final BuildContext context;

  PickDateEvent({required this.context});
}

final class PinLocationEvent extends ServicesEvent {
  final TapPosition tapPosition;
  final LatLng point;

  PinLocationEvent({required this.tapPosition, required this.point});
}

final class SetUnitCountEvent extends ServicesEvent {
  final int count;

  SetUnitCountEvent({required this.count});
}

final class ShowHintEvent extends ServicesEvent {
  final String message;

  ShowHintEvent({required this.message});
}

final class SetAreaEvent extends ServicesEvent {
  final double area;

  SetAreaEvent({required this.area});
}

final class ToggleIsFromRiyadhEvent extends ServicesEvent {}

final class SubmitServicesEvent extends ServicesEvent {}
