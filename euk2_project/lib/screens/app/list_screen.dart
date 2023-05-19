import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:eurokey2/blocs/list_sorting_bloc/list_sorting_bloc.dart';
import 'package:eurokey2/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:eurokey2/features/icon_management/icon_manager.dart';
import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:eurokey2/utils/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:geolocator/geolocator.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: context.read<ListSortingBloc>().sortedLocations.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Žádné položky nebyly nalezeny. \n\n Zkus aktualizovat databázi v menu Více.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Scrollbar(
                  thumbVisibility: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        const Divider(),
                        Expanded(
                          child: RefreshIndicator(
                            displacement: 5,
                            onRefresh: () async {
                              setState(() {
                                context.read<LocationManagementBloc>().add(OnRecalculateLocationsDistance());
                                context.read<ListSortingBloc>().add(OnSortByLocationDistance());
                              });
                              await Future.delayed(const Duration(milliseconds: 250));
                            },
                            child: ScrollWrapper(
                              alwaysVisibleAtOffset: true,
                              enabledAtOffset: 40,
                              promptAlignment: Alignment.bottomCenter,
                              promptTheme: PromptButtonTheme(
                                color: Theme.of(context).colorScheme.surface,
                                icon: const Icon(Icons.arrow_upward),
                              ),
                              builder: (context, properties) => ListView.separated(
                                itemCount: context.read<ListSortingBloc>().sortedLocations.length,
                                itemBuilder: _buildListTile,
                                separatorBuilder: (BuildContext context, int index) => const Divider(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, int index) {
    final EUKLocationData data = context.read<ListSortingBloc>().sortedLocations[index];
    String distanceText;
    switch (context.read<LocationManagementBloc>().userLocation.accuracyStatus) {
      case LocationAccuracyStatus.precise:
        distanceText = '${data.distanceFromDevice.toStringAsFixed(2)} km';
        break;
      case LocationAccuracyStatus.reduced:
        distanceText = '~${data.distanceFromDevice.toStringAsFixed(2)} km';
        break;
      default:
        distanceText = '---- km';
        break;
    }
    return ListTile(
      title: Text(data.address),
      subtitle: Text('${data.city}, ${data.ZIP}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getIconByType(data.type),
          const SizedBox(
            height: 4,
          ),
          Text(distanceText),
        ],
      ),
      onTap: () => context.read<LocationManagementBloc>().add(OnFocusOnEUKLocation(data.id, zoom: 17)),
    );
  }
}

class AppBarListScreen extends StatelessWidget {
  const AppBarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EasySearchBar(
      title: const Center(
        child: Text('Seznam míst'),
      ),
      animationDuration: const Duration(milliseconds: 250),
      searchClearIconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      searchBackIconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      searchCursorColor: Theme.of(context).colorScheme.secondary,
      searchBackgroundColor: context.isAppInDarkMode ? const Color(0xFF161616) : Theme.of(context).colorScheme.surface,
      onSearch: (value) {},
    );
  }
}
