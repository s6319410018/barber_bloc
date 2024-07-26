import 'package:barber_bloc/model/model_user.dart';
import 'package:barber_bloc/repository/Get_token.dart';
import 'package:barber_bloc/screen/Auth/signin.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

        emit(const AuthSuccess("Login Success"));
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
        emit(const AuthFailure("Please log in again."));
        return;
      }

      final response = await Auth.getData(token);

      if (response.email?.isNotEmpty == true &&
          response.username?.isNotEmpty == true) {
        emit(GetUser(response));
      } else {
        emit(const AuthFailure("Invalid user data received."));
      }
    } catch (e) {
      if (e.toString().contains('Token expired') ||
          e.toString().contains('Token is expired')) {
        emit(const AuthFailure("Token expired. Please log in again."));
      } else {
        emit(const AuthFailure('Please log in again.'));
      }
    }
  }
}
