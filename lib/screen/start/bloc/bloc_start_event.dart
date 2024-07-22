import 'package:meta/meta.dart';

@immutable
abstract class BlocStartEvent {}

class StartAnimationEvent extends BlocStartEvent {}

class BlocStartFadeEvent extends BlocStartEvent {
  final double? startOpacity;
  final double? endOpacity;

  BlocStartFadeEvent({
    this.startOpacity,
    this.endOpacity,
  });
}
