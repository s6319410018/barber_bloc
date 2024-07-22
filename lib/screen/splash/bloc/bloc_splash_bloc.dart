import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bloc_splash_event.dart';
part 'bloc_splash_state.dart';

class BlocSplashBloc extends Bloc<BlocSplashEvent, BlocSplashState> {
  BlocSplashBloc() : super(BlocSplashInitial()) {
    on<BlocSplashEvent>((event, emit) async {
      emit(BlocSplashAnimate());
      await Future.delayed(const Duration(seconds: 5));
      emit(BlocSplashNavigate());
    });
  }
}
