import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/AuthRepository.dart';
import '../../../repository/Get_token.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterRequestedEvent>(
      (event, emit) async {
        emit(AuthLoading());

        try {
          final response = await authRepository.register(event.user);
          await Future.delayed(const Duration(seconds: 2));

          if (response == "User registered successfully") {
            emit(AuthSuccess(message: response));
          } else {
            if (response.contains("Bad request")) {
              emit(const AuthFailure(
                  error: "Invalid request: Please check the input values."));
            } else if (response.contains("Unauthorized")) {
              emit(const AuthFailure(
                  error:
                      "Unauthorized: You do not have permission to perform this action."));
            } else if (response.contains("Forbidden")) {
              emit(const AuthFailure(error: "Forbidden: Access is denied."));
            } else if (response.contains("Not found")) {
              emit(const AuthFailure(
                  error:
                      "Not found: The requested resource could not be found."));
            } else if (response.contains("Internal server error")) {
              emit(const AuthFailure(
                  error: "Server error: Please try again later."));
            } else {
              emit(AuthFailure(
                  error: "An unexpected error occurred: $response"));
            }
          }
        } catch (e) {
          emit(AuthFailure(error: "An error occurred: $e"));
        }
      },
    );
    on<LoginRequestedEvent>(
      (event, emit) async {
        emit(AuthLoading());

        try {
          final response = await authRepository.login(event.user);

          await Future.delayed(const Duration(seconds: 2));

          if (response.token != null) {
            await Token.setToken(response.token!);

            emit(const AuthSuccess(message: "Login Success"));
          } else {
            emit(AuthFailure(error: response.message ?? 'Login Failed'));
          }
        } catch (e) {
          emit(AuthFailure(error: e.toString()));
        }
      },
    );
    on<GetRequestedEvent>(
      (event, emit) async {
        emit(AuthLoading());

        try {
          final token = await Token.getToken();

          if (token == null) {
            emit(const AuthFailure(error: "Please log in again."));
            return;
          }
          final response = await authRepository.getData(token);
          if (response.email?.isNotEmpty == true &&
              response.username?.isNotEmpty == true) {
            emit(GetUser(user: response));
          } else {
            emit(const AuthFailure(error: "Invalid user data received."));
          }
        } catch (e) {
          if (e.toString().contains('Token expired') ||
              e.toString().contains('Token is expired')) {
            emit(const AuthFailure(
                error: "Token expired. Please log in again."));
          } else {
            emit(AuthFailure(error: "An error occurred: ${e.toString()}"));
          }
        }
      },
    );
    on<LogoutRequestedEvent>(
      (event, emit) async {
        emit(AuthInitial());
        try {
          await Token.deleteToken();
          emit(AuthInitial());
        } catch (e) {
          emit(AuthFailure(error: e.toString()));
        }
      },
    );
    on<EditRequestedEvent>(
      (event, emit) async {
        emit(AuthLoading());

        try {
          final response = await authRepository.editProfile(event.user);

          emit(AuthSuccess(message: response.message.toString()));
        } catch (e, stackTrace) {
          print('Error editing profile: $e');
          print('Stack trace: $stackTrace');

          emit(AuthFailure(error: e.toString()));
        }
      },
    );
    on<DeleteRequestedEvent>(
      (event, emit) async {
        try {
          print('DeleteRequestedEvent received: ${event.user}');
          final response = await authRepository.delete(user: event.user);
          print('Delete operation response: ${response.message}');
          emit(DeleteSuccess(message: response.message.toString()));
        } catch (e) {
          emit(AuthFailure(error: e.toString()));
        }
      },
    );
  }
}
