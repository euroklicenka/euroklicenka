import 'package:euk2_project/blocs/external_map_bloc/external_map_bloc.dart';
import 'package:euk2_project/blocs/list_sorting_bloc/list_sorting_bloc.dart';
import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:euk2_project/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:euk2_project/blocs/screen_navigation_bloc/screen_navigation_bloc.dart';
import 'package:euk2_project/blocs/theme_switching_bloc/theme_switching_bloc.dart';
import 'package:euk2_project/features/snack_bars/snack_bar_management.dart';
import 'package:euk2_project/features/user_data_management/user_data_manager.dart';
import 'package:euk2_project/screens/main_screen.dart';
import 'package:euk2_project/themes/theme_collection.dart';
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
          create: (context) => ListSortingBloc(locations: context.read<LocationManagementBloc>().locationManager.locations),
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
