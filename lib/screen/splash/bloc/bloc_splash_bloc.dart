import 'package:barber_bloc/repository/Get_token.dart';
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
part 'bloc_splash_event.dart';
part 'bloc_splash_state.dart';

class BlocSplashBloc extends Bloc<BlocSplashEvent, BlocSplashState> {
  BlocSplashBloc() : super(BlocSplashInitial()) {
    on<StartRedirect>(_onStartRedirect);
  }
  Future<void> _onStartRedirect(
      StartRedirect event, Emitter<BlocSplashState> emit) async {
    String? tokenStore = await Token.getToken();

    emit(BlocSplashAnimateFadein());
    await Future.delayed(const Duration(seconds: 2));

    emit(BlocSplashAnimateFadeout());
    await Future.delayed(const Duration(seconds: 2));

    if (tokenStore != null) {
      emit(BlocSplashHome());
    } else {
      emit(BlocSplashNavigate());
    }
  }
}
