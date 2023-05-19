import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:eurokey2/blocs/list_organizing_bloc/list_organizing_bloc.dart';
import 'package:eurokey2/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:eurokey2/features/icon_management/icon_manager.dart';
import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:eurokey2/utils/build_context_extensions.dart';
import 'package:eurokey2/utils/general_utils.dart';
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
    return BlocBuilder<ListOrganizingBloc, ListOrganizingState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: _getBody(context, state),
        );
      },
    );
  }

  Widget _getBody(BuildContext context, state) {
    if (state is ListOrganizingSortingState) {
      return const Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Uspořádávání listu'),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: context.read<ListOrganizingBloc>().organizedLocations.isEmpty
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
                                  context.read<ListOrganizingBloc>().add(OnSortByLocationDistance());
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
                                  itemCount: context.read<ListOrganizingBloc>().organizedLocations.length,
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
  }

  Widget _buildListTile(BuildContext context, int index) {
    final EUKLocationData data = context.read<ListOrganizingBloc>().organizedLocations[index];
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
          const SizedBox(height: 4),
          Text(distanceText),
        ],
      ),
      onTap: () async {
        final locBloc = context.read<LocationManagementBloc>();
        await hideVirtualKeyboard();
        locBloc.add(OnFocusOnEUKLocation(data.id, zoom: 17));
      },
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
      animationDuration: const Duration(milliseconds: 260),
      searchClearIconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      searchBackIconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      searchCursorColor: Theme.of(context).colorScheme.secondary,
      searchBackgroundColor: context.isAppInDarkMode ? const Color(0xFF191919) : Theme.of(context).colorScheme.surface,
      onSearch: (value) => context.read<ListOrganizingBloc>().add(OnFilterByText(value)),
      suggestions: context.read<ListOrganizingBloc>().getSuggestions(),
      searchHintText: 'Ostrava...',
      onSuggestionTap: (value) async {
        final locBloc = context.read<LocationManagementBloc>();
        try {
          await hideVirtualKeyboard();
          final String id = locBloc.locationManager.locations.firstWhere((element) => element.address == value).id;
          locBloc.add(OnFocusOnEUKLocation(id, zoom: 17));
        } catch (e) {
          //Intentionally Blank
        }
      },
      suggestionBuilder: (value) {
        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.location_on),
              title: Text(value),
            ),
            const Divider(height: 6),
          ],
        );
      },
    );
  }
}
