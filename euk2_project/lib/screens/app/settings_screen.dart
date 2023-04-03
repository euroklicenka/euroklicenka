import 'package:euk2_project/blocs/external_map_bloc/external_map_bloc.dart';
import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:euk2_project/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:euk2_project/widgets/update_database_button.dart';
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

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
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
          ListTile(
            onTap: () => context.read<ExternalMapBloc>().add(OnChangeDefaultMapApp(context: context)),
            title: const Text('Výchozí navigace'),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: (context.watch<ExternalMapBloc>().defaultMapIcon.isEmpty)
                  ? const Icon(Icons.cancel_outlined)
                  : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SvgPicture.asset(
                  context.watch<ExternalMapBloc>().defaultMapIcon,
                  width: 32,
                ),
              ),
            ),
          ),
          const DividerOptions(),
          ListTile(
            onTap: () => context.read<MainScreenBloc>().add(OnOpenGuideScreen()),
            title: const Text("Průvodce"),
            leading: const Icon(Icons.rocket_launch),
          ),
          const DividerOptions(),
          ListTile(
            onTap: () {},
            title: const Text("Informace o aplikaci"),
            leading: const Icon(Icons.bookmarks_outlined),
          ),
          const DividerOptions(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: BlocBuilder<LocationManagementBloc, LocationManagementState>(
                  builder: (context, state) {
                    return AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.bounceOut,
                      child: (state is LocationManagementUpdatingFinished)
                          ? databaseButtonFinished()
                          : (state is LocationManagementUpdatingDatabase)
                          ? databaseButtonDisabled(animController: _animController)
                          : databaseButton(context: context),
                    );
                  },
                ),
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
      title: const Text('Nastavení a Informace'),
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
