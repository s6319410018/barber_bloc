class User {
  String? username;
  String? email;
  String? password;
  String? role;

  User({this.username, this.email, this.password, this.role});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['role'] = this.role;
    return data;
  }
}
