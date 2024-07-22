import 'package:meta/meta.dart';

@immutable
abstract class BlocStartState {}

/// Represents the initial state of the Bloc.
class BlocStartInitial extends BlocStartState {}

/// Represents the state for handling text animation.
class StartTextAnimationState extends BlocStartState {
  final String displayedText;

  StartTextAnimationState({
    required this.displayedText,
  });

  /// Creates a copy of this state with the provided text.
  StartTextAnimationState copyWith({
    String? displayedText,
  }) {
    return StartTextAnimationState(
      displayedText: displayedText ?? this.displayedText,
    );
  }
}

/// Represents the state for handling fade effects.
class BlocStartFadeState extends BlocStartState {
  final double opacity;

  BlocStartFadeState({required this.opacity});

  /// Creates a copy of this state with the provided opacity.
  BlocStartFadeState copyWith({
    double? opacity,
  }) {
    return BlocStartFadeState(
      opacity: opacity ?? this.opacity,
    );
  }
}
