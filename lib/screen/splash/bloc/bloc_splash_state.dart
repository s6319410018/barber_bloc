part of 'bloc_splash_bloc.dart';

@immutable
sealed class BlocSplashState {}

final class BlocSplashInitial extends BlocSplashState {}

final class BlocSplashAnimate extends BlocSplashState {}

final class BlocSplashNavigate extends BlocSplashState {}
