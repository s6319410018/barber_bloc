import 'package:barber_bloc/model/model_user.dart';
import 'package:barber_bloc/repository/Get_token.dart';
import 'package:barber_bloc/screen/Auth/signin.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../repository/Auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLogRequested);
    on<getRequested>(_ongetRequested);
  }

  void _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await Auth.register(event.user);

      await Future.delayed(const Duration(seconds: 2));

      if (response == "User registered successfully") {
        emit(AuthSuccess(response));
      } else {
        emit(AuthFailure(response));
      }
    } catch (e) {
      emit(AuthFailure('An error occurred: $e'));
    }
  }

  void _onLogRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final response = await Auth.login(event.user);

      await Future.delayed(const Duration(seconds: 2));

      if (response.token != null) {
        await Token.setToken(response.token!);

        emit(AuthSuccess("Login Success"));
      } else {
        emit(AuthFailure(response.message ?? 'Login Failed'));
      }
    } catch (e) {
      print(e);
      emit(AuthFailure('An error occurred: $e'));
    }
  }

  void _ongetRequested(getRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final token = await Token.getToken();

      if (token == null) {
        emit(const AuthFailure("Please login again"));
        return;
      }

      final response = await Auth.getData(token);

      if (response.email!.isNotEmpty && response.username!.isNotEmpty) {
        emit(GetUser(response));
      } else {
        emit(const AuthFailure("No data available"));
      }
    } catch (e) {
      print('Error: $e');
      emit(AuthFailure('An error occurred: ${e.toString()}'));
    }
  }
}
