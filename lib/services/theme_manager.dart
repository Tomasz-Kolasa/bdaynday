import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _colorKey = 'theme_color';
  static const Color defaultThemeColor = Colors.deepPurple;

  static Future<void> saveColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey, color.value);
  }

  static Future<Color> loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    int colorValue = prefs.getInt(_colorKey) ?? defaultThemeColor.value;
    return Color(colorValue);
  }
}
