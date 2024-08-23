class User {
  String? username;
  String? email;
  String? password;
  String? newPassword;
  String? role;
  String? message;
  Map<String, String>? profile;
  List<String> appointments;
  List<String> reviews;

  User({
    this.username,
    this.email,
    this.password,
    this.newPassword,
    this.role,
    this.message,
    this.profile,
    List<String>? appointments,
    List<String>? reviews,
  })  : appointments = appointments ?? [],
        reviews = reviews ?? [];

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        email = json['email'],
        password = json['password'],
        newPassword = json['newPassword'],
        role = json['role'],
        message = json['message'],
        profile = Map<String, String>.from(json['profile'] ?? {}),
        appointments = List<String>.from(json['appointments'] ?? []),
        reviews = List<String>.from(json['reviews'] ?? []);

  get firstName => null;

  get lastName => null;

  get phoneNumber => null;

  get address => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['newPassword'] = newPassword;
    data['role'] = role;
    data['message'] = message;
    data['profile'] = profile;
    data['appointments'] = appointments;
    data['reviews'] = reviews;
    return data;
  }
}
