import 'package:equatable/equatable.dart';

import '../../../model/model_user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteSuccess extends AuthState {
  final String message;

  const DeleteSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetUser extends AuthState {
  User user = User();

  GetUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class AuthLoggedOut extends AuthState {}
