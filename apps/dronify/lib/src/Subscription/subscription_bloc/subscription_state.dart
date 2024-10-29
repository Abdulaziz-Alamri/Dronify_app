part of 'subscription_bloc.dart';

@immutable
sealed class SubscriptionState {}

final class SubscriptionInitial extends SubscriptionState {}

final class Loadedstate extends SubscriptionState {}

class SelectedRadioState extends SubscriptionState {
  final int selectedIndex;
  final bool value;

  SelectedRadioState({required this.selectedIndex, required this.value});
}

final class ImagesUpdatedState extends SubscriptionState {
  final List<XFile> images;

  ImagesUpdatedState({required this.images});
}

final class DateSelectedState extends SubscriptionState {
  final String selectedDate;

  DateSelectedState({required this.selectedDate});
}

final class LocationFetchedState extends SubscriptionState {
  final LatLng location;

  LocationFetchedState({required this.location});
}

final class PinnedLocationState extends SubscriptionState {
  final LatLng location;

  PinnedLocationState({required this.location});
}

final class UnitCountUpdatedState extends SubscriptionState {
  final int unitCount;

  UnitCountUpdatedState({required this.unitCount});
}

final class IsFromRiyadhToggledState extends SubscriptionState {
  final bool isFromRiyadh;

  IsFromRiyadhToggledState({required this.isFromRiyadh});
}

final class AreaSetState extends SubscriptionState {
  final double area;

  AreaSetState({required this.area});
}

final class ShowHintState extends SubscriptionState {
  final String message;

  ShowHintState({required this.message});
}

final class SubscriptionSubmittedState extends SubscriptionState {}

final class SubscriptionErrorState extends SubscriptionState {
  final String message;

  SubscriptionErrorState({required this.message});
}
