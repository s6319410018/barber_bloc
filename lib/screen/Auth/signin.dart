import 'package:barber_bloc/Theme/app_colors.dart';
import 'package:barber_bloc/Theme/bloc/Them_cubit.dart';
import 'package:barber_bloc/model/model_user.dart';
import 'package:barber_bloc/repository/AuthRepository.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_bloc.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_event.dart';
import 'package:barber_bloc/screen/Auth/bloc/auth_state.dart';
import 'package:barber_bloc/screen/Auth/signup.dart';
import 'package:barber_bloc/screen/Home/home_ui.dart';
import 'package:barber_bloc/widget/appbar/basic_app_appbar.dart';
import 'package:barber_bloc/widget/button/basic_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'controller/signup_controller.dart';

class SigninUipage extends StatelessWidget {
  const SigninUipage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeState) {
            final isDarkMode = themeState == ThemeMode.dark;
            return Scaffold(
              appBar: BasicAppbar(
                action: Image.asset(
                  isDarkMode
                      ? "assets/logos/logo_white.png"
                      : "assets/logos/logo_black.png",
                ),
              ),
              bottomNavigationBar: _buildSignupText(isDarkMode, context),
              body: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLoginText(isDarkMode, context),
                    const SizedBox(height: 50),
                    _buildEmailField(isDarkMode, controller, context),
                    const SizedBox(height: 20),
                    _buildPasswordField(isDarkMode, controller, context),
                    const SizedBox(height: 20),
                    _buildSignInButton(context, controller, isDarkMode),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoginText(bool isDarkMode, BuildContext context) {
    return Text(
      'Login',
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

  Widget _buildEmailField(
      bool isDarkMode, AuthController controller, BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: controller.emailController,
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
                : AppColors.darkBackground,
          ),
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

  Widget _buildPasswordField(
      bool isDarkMode, AuthController controller, BuildContext context) {
    return Obx(
      () => TextField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: controller.obscureText.value,
        controller: controller.passwordController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              controller.obscureText.value
                  ? FontAwesomeIcons.eyeSlash
                  : FontAwesomeIcons.eye,
              color: isDarkMode
                  ? AppColors.lightBackground
                  : AppColors.darkBackground,
            ),
            onPressed: controller.toggleObscureText,
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
                  : AppColors.darkBackground,
            ),
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
      ),
    );
  }

  Widget _buildSignupText(bool isDarkMode, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignupPage(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Do you have an account? Sign up',
              style: GoogleFonts.nunito(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                color: isDarkMode
                    ? AppColors.lightBackground
                    : AppColors.darkBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInButton(
      BuildContext context, AuthController controller, bool isDarkMode) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthFailure) {
          _showTopSnackBar(isDarkMode, state.error, context, false);
        } else if (state is AuthSuccess) {
          controller.clearFields();
          _showTopSnackBar(isDarkMode, state.message, context, true);
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeUi()),
          );
        }
      },
      builder: (context, state) {
        return BasicAppButton(
          loading: state is AuthLoading,
          onPressed: () {
            if (controller.emailController.text.trim().isEmpty ||
                controller.passwordController.text.trim().isEmpty) {
              _showTopSnackBar(
                  isDarkMode, "Please input data in the form", context, false);
              return;
            }
            final user = User(
              email: controller.emailController.text.trim(),
              password: controller.passwordController.text.trim(),
            );
            context.read<AuthBloc>().add(LoginRequestedEvent(user: user));
          },
          title: 'Sign In',
        );
      },
    );
  }

  void _showTopSnackBar(
      bool isDarkMode, String message, BuildContext context, bool status) {
    showTopSnackBar(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 60),
      Overlay.of(context),
      CustomSnackBar.success(
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? AppColors.lightBackground.withOpacity(0.3)
                : AppColors.darkBackground.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        backgroundColor: status ? AppColors.S_Status : AppColors.F_Status,
        message: message,
      ),
    );
  }
}
