part of 'bottom_nav_bloc.dart';

@immutable
sealed class BottomNavState {}

final class BottomNavInitial extends BottomNavState {}

final class LoadedIndex extends BottomNavState {
   final int index;
  LoadedIndex({required this.index});
}

class SuccessChangeViewState extends BottomNavState {
  final int currentPageIndex;
  SuccessChangeViewState(this.currentPageIndex);
}
class HideBottomNavState extends BottomNavState {}

class ShowBottomNavState extends BottomNavState {}