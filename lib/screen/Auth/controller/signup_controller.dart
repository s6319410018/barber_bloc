import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  // TextEditingController instances
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Rx variables
  final RxBool obscureText = true.obs;
  final RxString dropdownValue = 'customer'.obs;

  // Dropdown items
  final items = ['customer', 'barber'].obs;

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  void clearFields() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    dropdownValue.value = 'customer';
  }
}
