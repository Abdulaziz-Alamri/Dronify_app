part of 'services_bloc.dart';

@immutable
sealed class ServicesState {}

final class ServicesInitial extends ServicesState {}

final class Loadedstate extends ServicesState {}

final class ImagesUpdatedState extends ServicesState {
  final List<XFile> images;

  ImagesUpdatedState({required this.images});
}

final class LocationFetchedState extends ServicesState {
  final LatLng location;

  LocationFetchedState({required this.location});
}

final class DateSelectedState extends ServicesState {
  final String selectedDate;

  DateSelectedState({required this.selectedDate});
}

final class PinnedLocationState extends ServicesState {
  final LatLng location;

  PinnedLocationState({required this.location});
}

final class UnitCountUpdatedState extends ServicesState {
  final int unitCount;

  UnitCountUpdatedState({required this.unitCount});
}

final class IsFromRiyadhToggledState extends ServicesState {
  final bool isFromRiyadh;

  IsFromRiyadhToggledState({required this.isFromRiyadh});
}

final class AreaSetState extends ServicesState {
  final double area;

  AreaSetState({required this.area});
}

final class ShowHintState extends ServicesState {
  final String message;

  ShowHintState({required this.message});
}

final class ServiceSubmittedState extends ServicesState {}

final class ServiceErrorState extends ServicesState {
  final String message;

  ServiceErrorState({required this.message});
}
