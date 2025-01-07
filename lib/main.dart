import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urodziny_imieniny/services/theme_manager.dart';
import './states/my_app_state.dart';
import 'views/app_scaffold.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Color savedColor = await ThemeManager.loadColor();
  runApp(MyApp(savedColor));
}

class MyApp extends StatelessWidget {
  const MyApp(this.themeColor, {super.key});

  final Color themeColor;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Urodziny Imieniny',

        locale: Locale('pl', 'PL'),
        supportedLocales: [
          //const Locale('en', 'US'),
          const Locale('pl', 'PL'),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'urodziny imieniny'),
      ),
    );
  }
}
