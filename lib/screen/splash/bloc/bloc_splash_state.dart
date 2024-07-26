part of 'bloc_splash_bloc.dart';

@immutable
sealed class BlocSplashState {}

// Initial state of the splash screen
final class BlocSplashInitial extends BlocSplashState {}

// State to trigger animation (fade-in)
final class BlocSplashAnimateFadein extends BlocSplashState {}

// State to trigger animation (fade-out)
final class BlocSplashAnimateFadeout extends BlocSplashState {}

// State to navigate to the home screen
final class BlocSplashHome extends BlocSplashState {}

// State to navigate to the start screen
final class BlocSplashNavigate extends BlocSplashState {}
