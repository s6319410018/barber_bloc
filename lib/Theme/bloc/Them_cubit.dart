import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  // กำหนดสถานะเริ่มต้นเป็น ThemeMode.system
  ThemeCubit() : super(ThemeMode.system);

  // ฟังก์ชันสำหรับการเปลี่ยนธีม
  void updateTheme(ThemeMode themeMode) => emit(themeMode);

  // การแปลงข้อมูลจาก JSON ไปเป็น ThemeMode
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values[json['theme'] as int];
  }

  // การแปลง ThemeMode ไปเป็น JSON
  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'theme': state.index};
  }
}
