import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: Colors.black,
      selectionHandleColor: Colors.black,
    ),
    hoverColor: Colors.black,
    // textButtonTheme: const TextButtonThemeData(
    //   style: ButtonStyle(
    //     surfaceTintColor: WidgetStatePropertyAll(Colors.white),
    //     backgroundColor: WidgetStatePropertyAll(Colors.white),
    //     foregroundColor: WidgetStatePropertyAll(Colors.white),
    //     overlayColor: WidgetStatePropertyAll(Colors.white),
    //   ),
    // ),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    brightness: Brightness.light,
    fontFamily: 'Satoshi',
    sliderTheme: SliderThemeData(
      overlayShape: SliderComponentShape.noOverlay,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(30),
      hintStyle: const TextStyle(
        color: Color(0xff383838),
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.white, width: 0.4),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black, width: 0.4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white),
      labelSmall: TextStyle(color: Colors.white),
    ),
  );

  static final darkTheme = ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.white,
      selectionHandleColor: Colors.white,
    ),
    hoverColor: Colors.white,
    // textButtonTheme: const TextButtonThemeData(
    //   style: ButtonStyle(
    //     surfaceTintColor: WidgetStatePropertyAll(Colors.black),
    //     backgroundColor: WidgetStatePropertyAll(Colors.black),
    //     foregroundColor: WidgetStatePropertyAll(Colors.black),
    //     overlayColor: WidgetStatePropertyAll(Colors.black),
    //   ),
    // ),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,
    fontFamily: 'Satoshi',
    sliderTheme: SliderThemeData(
        overlayShape: SliderComponentShape.noOverlay,
        activeTrackColor: Color(0xffB7B7B7),
        inactiveTrackColor: Colors.grey.withOpacity(0.3),
        thumbColor: Color(0xffB7B7B7)),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        hintStyle: const TextStyle(
          color: Color(0xffA7A7A7),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.all(30),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white, width: 0.4)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white, width: 0.4))),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black),
      displaySmall: TextStyle(color: Colors.black),
      headlineMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
      labelLarge: TextStyle(color: Colors.black),
      labelSmall: TextStyle(color: Colors.black),
    ),
  );
}
