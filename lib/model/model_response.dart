class LoginResponse {
  final String? token;
  final String? message;

  LoginResponse({this.token, this.message});
}

class EditResponst {
  final String? username;
  final String? email;
  final bool? message;

  EditResponst({this.username, this.email, this.message});
}
