import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Theme/app_colors.dart';
import '../../Theme/bloc/Them_cubit.dart';
import '../../repository/Get_token.dart';
import '../../widget/appbar/basic_app_appbar.dart';
import '../../widget/button/basic_app_button.dart';
import '../Auth/bloc/auth_bloc.dart';
import '../Auth/bloc/auth_event.dart';
import '../Auth/bloc/auth_state.dart';
import '../start/start.dart';
import '../../model/model_user.dart';

class DeleteUI extends StatefulWidget {
  const DeleteUI({super.key});

  @override
  _DeleteUIState createState() => _DeleteUIState();
}

class _DeleteUIState extends State<DeleteUI> {
  String? _selectedFeedback;
  bool _showTextField = false;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;

        return Scaffold(
          appBar: BasicAppbar(
            hideBack: false,
            title: Text(
              "BARBER",
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            action: Image.asset(
              isDarkMode
                  ? "assets/logos/logo_white.png"
                  : "assets/logos/logo_black.png",
            ),
          ),
          body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is DeleteSuccess) {
                _handleDeleteSuccess(context);
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is GetUser) {
                  return _buildDeleteUserContent(
                      isDarkMode, state.user.email.toString());
                }
                return Center(child: Text("Loading..."));
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeleteUserContent(bool isDarkMode, String email) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Please provide feedback:",
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          ..._buildFeedbackOptions(),
          if (_showTextField) _buildFeedbackTextField(isDarkMode),
          const Spacer(),
          BasicAppButton(
            loading: false,
            onPressed: () {
              String value = _selectedFeedback ?? _feedbackController.text;

              if (value.isEmpty) {
                _showTopSnackBar(
                    isDarkMode, "Plese Select Option", context, false);
              } else {
                FocusScope.of(context).unfocus();
                context.read<AuthBloc>().add(DeleteRequestedEvent(
                      user: User(
                        email: email,
                        message: value,
                      ),
                    ));
              }
            },
            title: "Delete user",
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeedbackOptions() {
    return [
      _buildRadioOption('Option 1', 'option1'),
      _buildRadioOption('Option 2', 'option2'),
      _buildRadioOption('Other', 'other'),
    ];
  }

  Widget _buildRadioOption(String title, String value) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: _selectedFeedback,
      onChanged: (newValue) {
        setState(() {
          _selectedFeedback = newValue;
          _showTextField = newValue == 'other';
        });
      },
    );
  }

  Widget _buildFeedbackTextField(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextField(
        controller: _feedbackController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Please specify',
          hintText: 'Enter additional feedback here',
          filled: true,
          fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        ),
        maxLines: 3,
      ),
    );
  }

  void _handleDeleteSuccess(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StartUI(),
      ),
    );

    Token.deleteToken();
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
