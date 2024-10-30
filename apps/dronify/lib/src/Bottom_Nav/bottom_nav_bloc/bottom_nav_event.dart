part of 'bottom_nav_bloc.dart';

@immutable
sealed class BottomNavEvent {}

class LoadEvent extends BottomNavEvent {
  final int index;
  LoadEvent({required this.index});
}
class ChangeEvent extends BottomNavEvent {
  final int index;
  ChangeEvent({required this.index});
}
class HideBottomNavEvent extends BottomNavEvent {}

class ShowBottomNavEvent extends BottomNavEvent {}