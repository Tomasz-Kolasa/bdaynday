import 'package:flutter/material.dart';
import 'package:urodziny_imieniny/services/menu_item_handlers/menu_item_handler.dart';
import 'package:urodziny_imieniny/views/navigator/menu/app_theme/color_picker_screen.dart';

class AppThemeHandler extends MenuItemHandler{

  AppThemeHandler(super.context);

  @override
  void handleMenuItem() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ColorPickerScreen(appState: appState,)),
    );
  }
}