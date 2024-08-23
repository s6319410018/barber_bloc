import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../Theme/app_colors.dart';
import '../../Theme/bloc/Them_cubit.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final bool loading;

  const BasicAppButton({
    required this.loading,
    required this.onPressed,
    required this.title,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: _buttonStyle(isDarkMode),
      child: loading
          ? LoadingAnimationWidget.staggeredDotsWave(
              color: !isDarkMode ? Colors.white : Colors.black,
              size: MediaQuery.of(context).size.width * 0.1,
            )
          : Text(
              title,
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
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
    );
  }

  ButtonStyle _buttonStyle(bool isDarkMode, {double? height}) {
    return ElevatedButton.styleFrom(
      backgroundColor:
          isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
      minimumSize: Size.fromHeight(height ?? 80),
      foregroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      shadowColor:
          isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
