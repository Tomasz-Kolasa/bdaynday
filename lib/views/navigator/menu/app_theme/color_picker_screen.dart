import 'package:flutter/material.dart';
import 'package:urodziny_imieniny/app_settings/app_settings.dart';
import 'package:urodziny_imieniny/services/theme_manager.dart';
import 'package:urodziny_imieniny/states/my_app_state.dart';
import 'package:urodziny_imieniny/views/navigator/menu/app_theme/sample_box.dart';

class ColorPickerScreen extends StatelessWidget {
  final MyAppState appState;

  ColorPickerScreen({required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wybierz kolor")),
      body: Column(
        children: [
          for(var themeColor in AppSettings.appThemes)
            ElevatedButton(
              onPressed: () {
                ThemeManager.saveColor(themeColor);
                appState.addUserMessage('zmiana będzie widoczna po restarcie aplikacji');
                // Navigator.of(context).pop();
              },
              child: SampleBox(color: themeColor,),
            )
        ],
      ),
    );
  }
}