import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'bloc_start_event.dart';
import 'bloc_start_state.dart';

class BlocStartBloc extends Bloc<BlocStartEvent, BlocStartState> {
  final Duration textAnimationDuration = const Duration(milliseconds: 150);
  final Duration fadeDuration = const Duration(seconds: 3);

  Timer? _timer;
  int _currentIndex = 0;
  String _displayedText = '';

  final List<String> _words = [
    "Best Cuts in Town",
    "Exceptional Service Every Time",
    "Your Style, Our Expertise",
    "Where Your Look Comes Alive",
  ];

  BlocStartBloc() : super(BlocStartInitial()) {
    on<StartAnimationEvent>(_onStartAnimationEvent);
    on<BlocStartFadeEvent>(_onBlocStartFadeEvent);
  }

  Future<void> _onStartAnimationEvent(
      StartAnimationEvent event, Emitter<BlocStartState> emit) async {
    _timer?.cancel();
    int charIndex = 0;
    _displayedText = '';

    while (charIndex < _words[_currentIndex].length) {
      _displayedText += _words[_currentIndex][charIndex];
      charIndex++;
      emit(StartTextAnimationState(displayedText: _displayedText));
      await Future.delayed(textAnimationDuration);
    }

    await Future.delayed(const Duration(seconds: 1), () {
      _displayedText = '';
      _currentIndex = (_currentIndex + 1) % _words.length;
      add(StartAnimationEvent()); // Trigger the next animation
    });
  }

  Future<void> _onBlocStartFadeEvent(
      BlocStartFadeEvent event, Emitter<BlocStartState> emit) async {
    double startOpacity = event.startOpacity ?? 0.0;
    double endOpacity = event.endOpacity ?? 1.0;
    double opacity = startOpacity;
    double opacityStep =
        (endOpacity - startOpacity) / (fadeDuration.inMilliseconds / 30);

    while ((startOpacity < endOpacity && opacity < endOpacity) ||
        (startOpacity > endOpacity && opacity > endOpacity)) {
      opacity += opacityStep;
      emit(BlocStartFadeState(opacity: opacity));
      await Future.delayed(const Duration(milliseconds: 30));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
