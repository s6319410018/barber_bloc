import 'package:equatable/equatable.dart';

import '../../../model/model_user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RegisterRequested extends AuthEvent {
  final User user;

  const RegisterRequested(this.user);

  @override
  List<Object> get props => [user];
}

class LoginRequested extends AuthEvent {
  final User user;

  const LoginRequested(this.user);

  @override
  List<Object> get props => [user];
}

class getRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}
