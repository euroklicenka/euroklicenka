import 'package:eurokey2/blocs/external_map_bloc/external_map_bloc.dart';
import 'package:eurokey2/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:eurokey2/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:eurokey2/blocs/screen_navigation_bloc/screen_navigation_bloc.dart';
import 'package:eurokey2/blocs/theme_switching_bloc/theme_switching_bloc.dart';
import 'package:eurokey2/widgets/theme_dependent_icon.dart';
import 'package:eurokey2/widgets/update_database_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

///The Settings screen where the user can adjust various app settings
///or look up information.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => context
                          .read<ThemeSwitchingBloc>()
                          .add(OnOpenThemeDialog(context)),
                      title: const Text('Motiv rozhraní'),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: BlocBuilder<ThemeSwitchingBloc,
                            ThemeSwitchingState>(
                          builder: (context, state) {
                            if (state is ThemeSwitchingLightState) {
                              return const ThemeDependentIcon(Icons.light_mode);
                            } else if (state is ThemeSwitchingDarkState) {
                              return const ThemeDependentIcon(Icons.dark_mode);
                            } else {
                              return const ThemeDependentIcon(Icons.settings);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListTile(
                      onTap: () => context
                          .read<ExternalMapBloc>()
                          .add(OnChangeDefaultMapApp(context: context)),
                      title: const Text('Výchozí navigace'),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: (context
                                .watch<ExternalMapBloc>()
                                .defaultMapIcon
                                .isEmpty)
                            ? const ThemeDependentIcon(Icons.cancel_outlined)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SvgPicture.asset(
                                  context
                                      .watch<ExternalMapBloc>()
                                      .defaultMapIcon,
                                  width: 32,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Tooltip(
                      message:
                          'Pokusí se aplikace aktualizovat lokace z internetu při spuštění?',
                      showDuration: const Duration(milliseconds: 3000),
                      triggerMode: TooltipTriggerMode.longPress,
                      child: SwitchListTile.adaptive(
                        title: const Text('Aktualizovat místa při spuštění'),
                        value: context
                            .watch<LocationManagementBloc>()
                            .checkForDataOnline,
                        onChanged: (value) => context
                            .read<LocationManagementBloc>()
                            .add(OnChangeOnlineCheckDecision(decision: value)),
                      ),
                    ),
                    const DividerOptions(),
                    ListTile(
                      onTap: () => context
                          .read<MainScreenBloc>()
                          .add(OnOpenGuideScreen()),
                      title: const Text("Průvodce"),
                      leading: const ThemeDependentIcon(Icons.rocket_launch),
                    ),
                    const DividerOptions(),
                    ListTile(
                      onTap: () => context
                          .read<ScreenNavigationBloc>()
                          .add(OnOpenInformation(context: context)),
                      title: const Text("O aplikaci"),
                      leading: const ThemeDependentIcon(Icons.info),
                    ),
                    const DividerOptions(),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child:
                  BlocBuilder<LocationManagementBloc, LocationManagementState>(
                builder: (context, state) {
                  return AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceOut,
                    child: (state is LocationManagementUpdatingFinishedState)
                        ? databaseButtonFinished()
                        : (state is LocationManagementUpdatingDatabaseState)
                            ? databaseButtonDisabled(
                                context,
                                animController: _animController,
                              )
                            : databaseButton(context: context),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///The AppBar for the Settings Screen.
class AppBarSettingsScreen extends StatelessWidget {
  const AppBarSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Nastavení a informace'),
      centerTitle: true,
    );
  }
}

class DividerOptions extends StatelessWidget {
  const DividerOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      indent: 10,
      endIndent: 10,
    );
  }
}
