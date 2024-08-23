import 'package:equatable/equatable.dart';

import '../../../model/model_user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RegisterRequestedEvent extends AuthEvent {
  final User user;

  const RegisterRequestedEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class LoginRequestedEvent extends AuthEvent {
  final User user;

  const LoginRequestedEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteRequestedEvent extends AuthEvent {
  final User user;

  const DeleteRequestedEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class EditRequestedEvent extends AuthEvent {
  final User user;

  const EditRequestedEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class GetRequestedEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LogoutRequestedEvent extends AuthEvent {}
