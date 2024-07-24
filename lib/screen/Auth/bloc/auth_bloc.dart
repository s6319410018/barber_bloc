import 'package:bloc/bloc.dart';
import '../../../repository/Auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
  }

  void _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await Auth.register(event.user);
      print(response);
      if (response == "faile") {
        emit(AuthFailure(response));
      }
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthSuccess(response));
    } catch (e) {
      emit(
        AuthFailure(
          e.toString(),
        ),
      );
    }
  }
}
