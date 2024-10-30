part of 'scrollsplash_bloc.dart';

@immutable
sealed class ScrollsplashState {}

final class ScrollsplashInitial extends ScrollsplashState {}

final class ChangedIndexState extends ScrollsplashState {
  final int currentIndex;
  ChangedIndexState({required this.currentIndex});
}
