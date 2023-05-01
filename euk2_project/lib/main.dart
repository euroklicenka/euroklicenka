import 'package:eurokey2/blocs/external_map_bloc/external_map_bloc.dart';
import 'package:eurokey2/blocs/list_sorting_bloc/list_sorting_bloc.dart';
import 'package:eurokey2/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:eurokey2/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:eurokey2/blocs/screen_navigation_bloc/screen_navigation_bloc.dart';
import 'package:eurokey2/blocs/theme_switching_bloc/theme_switching_bloc.dart';
import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:eurokey2/features/user_data_management/user_data_manager.dart';
import 'package:eurokey2/screens/main_screen.dart';
import 'package:eurokey2/themes/theme_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late UserDataManager _dataManager;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _dataManager = await UserDataManager.create();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ScreenNavigationBloc(),
        ),
        BlocProvider(
          create: (context) => LocationManagementBloc(navigationBloc: BlocProvider.of<ScreenNavigationBloc>(context)),
        ),
        BlocProvider(
          create: (context) => MainScreenBloc(dataManager: _dataManager, locationBloc: BlocProvider.of<LocationManagementBloc>(context))..add(OnAppInit()),
        ),
        BlocProvider(
          create: (context) => ListSortingBloc(locManager: BlocProvider.of<LocationManagementBloc>(context).locationManager),
        ),
        BlocProvider(
          create: (context) => ThemeSwitchingBloc(dataManager: _dataManager),
        ),
        BlocProvider(
          create: (context) => ExternalMapBloc(dataManager: _dataManager),
        ),
      ],
      child: BlocBuilder<ThemeSwitchingBloc, ThemeSwitchingState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: defaultLightTheme,
            darkTheme: defaultDarkTheme,
            themeMode: context.watch<ThemeSwitchingBloc>().currentTheme,
            scaffoldMessengerKey: snackBarKey,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
