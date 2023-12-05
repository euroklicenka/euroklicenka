import 'package:eurokey2/features/data_management/user_data_manager.dart';
import 'package:eurokey2/features/data_management/yaml_data_manager.dart';
import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:eurokey2/models/eurolock_model.dart';
import 'package:eurokey2/models/location_model.dart';
import 'package:eurokey2/models/preferences_model.dart';
import 'package:eurokey2/screens/main_screen.dart';
import 'package:eurokey2/themes/theme_collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late UserDataManager _dataManager;
late YAMLDataManager _yamlManager;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _dataManager = await UserDataManager.create();
  _yamlManager = await YAMLDataManager.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationModel()),
        ChangeNotifierProvider(create: (context) => PreferencesModel()),
        ChangeNotifierProvider(create: (context) => EurolockModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: defaultLightTheme,
        darkTheme: defaultDarkTheme,
        // themeMode: context.watch<ThemeSwitchingBloc>().currentTheme,
        scaffoldMessengerKey: snackBarKey,
        // FIXME: Maybe use routes here?
        home: const MainScreen(),
      ),
    );
  }
}
