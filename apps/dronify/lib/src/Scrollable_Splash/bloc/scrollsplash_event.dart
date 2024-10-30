part of 'scrollsplash_bloc.dart';

@immutable
sealed class ScrollsplashEvent {}

final class ChangeIndexEvent extends ScrollsplashEvent {
  final int currentIndex;
  ChangeIndexEvent({required this.currentIndex});
}
