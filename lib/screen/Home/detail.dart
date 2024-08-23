import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String email;
  final String role;

  const UserDetailPage({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.role,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$firstName $lastName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name: $firstName $lastName'),
            const SizedBox(height: 10),
            Text('Phone Number: $phoneNumber'),
            const SizedBox(height: 10),
            Text('Address: $address'),
            const SizedBox(height: 10),
            Text('Email: $email'),
            const SizedBox(height: 10),
            Text('Role: $role'),
          ],
        ),
      ),
    );
  }
}
