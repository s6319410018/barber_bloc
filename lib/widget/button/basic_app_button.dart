import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Theme/app_colors.dart';
import '../../Theme/bloc/Them_cubit.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  const BasicAppButton({
    required this.onPressed,
    required this.title,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        disabledForegroundColor: Colors.amber,
        disabledBackgroundColor: Colors.amber,
        backgroundColor: isDarkMode
            ? AppColors.lightBackground
            : AppColors.darkBackground, // Set background color to black
        minimumSize: Size.fromHeight(height ?? 80),
        foregroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        shadowColor:
            isDarkMode ? AppColors.lightBackground : AppColors.darkBackground,
      ),
      child: Text(
        title,
        style: TextStyle(
          color:
              isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        ),
      ),
    );
  }
}
