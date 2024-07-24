import 'package:barber_bloc/Theme/app_colors.dart';
import 'package:barber_bloc/screen/start/start.dart';
import 'package:barber_bloc/widget/dialog/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_bloc.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_state.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_event.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Theme/bloc/Them_cubit.dart';

import '../../model/model_user.dart';
import '../../widget/appbar/basic_app_appbar.dart';
import '../../widget/button/basic_app_button.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  String _dropdownvalue = 'customer';
  var items = [
    'customer',
    'barber',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeState) {
          final isDarkMode = themeState == ThemeMode.dark;
          return Scaffold(
            appBar: isDarkMode
                ? BasicAppbar(
                    action: Image.asset("assets/logos/logo_white.png"),
                  )
                : BasicAppbar(
                    action: Image.asset("assets/logos/logo_black.png"),
                  ),
            bottomNavigationBar: _signinText(isDarkMode, context),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _registerText(isDarkMode),
                  const SizedBox(height: 50),
                  _fullNameField(isDarkMode),
                  const SizedBox(height: 20),
                  _emailField(isDarkMode),
                  const SizedBox(height: 20),
                  _passwordField(isDarkMode, context),
                  const SizedBox(height: 20),
                  _roleField(isDarkMode),
                  const SizedBox(height: 20),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthFailure) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(
                              state.error,
                              style: GoogleFonts.kanit(color: Colors.amber),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else if (state is AuthSuccess &&
                          state.message != "faile") {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Success'),
                            content: Text(
                              state.message,
                              style: GoogleFonts.kanit(color: Colors.amber),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _usernameController.clear();
                                  _emailController.clear();
                                  _passwordController.clear();
                                  setState(() {
                                    _dropdownvalue = "customer";
                                  });
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return BasicAppButton(
                          loading: true,
                          onPressed: () {},
                          title: 'Sign Up',
                        );
                      }

                      return BasicAppButton(
                        loading: false,
                        onPressed: () {
                          User user = User(
                            username: _usernameController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            role: _dropdownvalue,
                          );
                          context.read<AuthBloc>().add(RegisterRequested(user));
                        },
                        title: 'Sign Up',
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _Showdialog(BuildContext context, String message) {
    return AlertDialog(
      title: Text('Error'),
      content: Text(message),
      backgroundColor: Colors.amber,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  Widget _registerText(bool isDarkMode) {
    return Text(
      'Register',
      style: GoogleFonts.nunito(
        fontSize: MediaQuery.of(context).size.width * 0.1,
        color:
            isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
        shadows: [
          Shadow(
            color: isDarkMode
                ? AppColors.lightBackground.withOpacity(0.3)
                : AppColors.darkBackground.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(bool isDarkMode) {
    return TextField(
      keyboardType: TextInputType.name,
      controller: _usernameController,
      decoration: InputDecoration(
        fillColor:
            isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        filled: true,
        hintText: "Enter Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
              color: isDarkMode
                  ? AppColors.lightBackground
                  : AppColors.darkBackground),
        ),
      ),
      style: GoogleFonts.nunito(
        fontSize: MediaQuery.of(context).size.width * 0.035,
        color:
            isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
        shadows: [
          Shadow(
            color: isDarkMode
                ? AppColors.lightBackground.withOpacity(0.3)
                : AppColors.darkBackground.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _emailField(bool isDarkMode) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      decoration: InputDecoration(
        fillColor:
            isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        filled: true,
        hintText: "Enter Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
              color: isDarkMode
                  ? AppColors.lightBackground
                  : AppColors.darkBackground),
        ),
      ),
      style: GoogleFonts.nunito(
        fontSize: MediaQuery.of(context).size.width * 0.035,
        color:
            isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
        shadows: [
          Shadow(
            color: isDarkMode
                ? AppColors.lightBackground.withOpacity(0.3)
                : AppColors.darkBackground.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _passwordField(bool isDarkMode, BuildContext context) {
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      controller: _passwordController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
            color: isDarkMode
                ? AppColors.lightBackground
                : AppColors.darkBackground,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // Toggle password visibility
            });
          },
        ),
        fillColor:
            isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        filled: true,
        hintText: "Enter Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
              color: isDarkMode
                  ? AppColors.lightBackground
                  : AppColors.darkBackground),
        ),
      ),
      style: GoogleFonts.nunito(
        fontSize: MediaQuery.of(context).size.width * 0.035,
        color:
            isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
        shadows: [
          Shadow(
            color: isDarkMode
                ? AppColors.lightBackground.withOpacity(0.3)
                : AppColors.darkBackground.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _roleField(bool isDarkMode) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        color:
            isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color:
              isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
          width: 1,
        ),
      ),
      child: DropdownButton<String>(
        alignment: Alignment.center,
        value: _dropdownvalue,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color:
              isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        ),
        iconEnabledColor:
            isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
        isExpanded: true,
        dropdownColor:
            isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
        underline: const SizedBox(),
        borderRadius: BorderRadius.circular(30),
        onChanged: (String? newValue) {
          setState(() {
            _dropdownvalue = newValue!;
          });
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                value,
                style: GoogleFonts.nunito(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  color: isDarkMode
                      ? AppColors.darkBackground
                      : AppColors.lightBackground,
                  shadows: [
                    Shadow(
                      color: isDarkMode
                          ? AppColors.darkBackground.withOpacity(0.3)
                          : AppColors.lightBackground.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _signinText(bool isDarkMode, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Do you have an account? ',
            style: GoogleFonts.nunito(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              color: isDarkMode
                  ? AppColors.lightBackground
                  : AppColors.darkBackground,
              shadows: [
                Shadow(
                  color: isDarkMode
                      ? AppColors.lightBackground.withOpacity(0.3)
                      : AppColors.darkBackground.withOpacity(0.3),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: isDarkMode
                  ? AppColors.lightBackground
                  : AppColors.darkBackground,
            ),
            onPressed: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => StartUI(),
              //   ),
              // );
            },
            child: Text(
              'Sign In',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.035,
                color: isDarkMode
                    ? AppColors.lightBackground
                    : AppColors.darkBackground,
                shadows: [
                  Shadow(
                    color: isDarkMode
                        ? AppColors.lightBackground.withOpacity(0.3)
                        : AppColors.darkBackground.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
