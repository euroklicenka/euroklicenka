
import 'package:euk2_project/screens/intro_screen.dart';
import 'package:euk2_project/screens/splash.dart';
import 'package:euk2_project/themes/theme_collection.dart';
import 'package:euk2_project/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


int? initScreen;

Future<void> main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt('onBoard');
  await prefs.setInt('onBoard', 1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ThemeManager _themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: yellowTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,

      initialRoute: initScreen == 0 || initScreen == null ? 'onBoard' : 'home',
      routes: {
        'home' : (context) => SplashScreenPage(),
        'onBoard' : (context) => IntroScreen(),
      },

      //home: const MainScreen(),
    );
  }
}
