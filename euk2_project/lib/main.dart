import 'package:euk2_project/main_screen.dart';
import 'package:euk2_project/screens/main_screen_bloc/main_screen_bloc.dart';
import 'package:euk2_project/themes/theme_collection.dart';
import 'package:euk2_project/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeManager _themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: yellowTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      home: BlocProvider(
        create: (context) => MainScreenBloc()..add(OnAppInit()),
        child: const MainScreen(),
      ),
    );
  }
}
