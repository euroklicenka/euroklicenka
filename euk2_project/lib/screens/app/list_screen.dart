import 'package:euk2_project/blocs/list_sorting_bloc/list_sorting_bloc.dart';
import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:euk2_project/features/icon_management/icon_manager.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    child: ListView.separated(
                      itemCount: context
                          .read<ListSortingBloc>()
                          .sortedLocations
                          .length,
                      itemBuilder: _buildListTile,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, int index) {
    final EUKLocationData data = context.read<ListSortingBloc>().sortedLocations[index];

    return ListTile(
      title: Text(data.address),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${data.city}, ${data.ZIP}'),
          const SizedBox(height: 4),
          Text('${data.distanceFromDevice.toStringAsFixed(2)} km'),
        ],
      ),
      trailing: getIconByType(data.type),
      onTap: () => context.read<LocationManagementBloc>().add(OnFocusOnEUKLocation(data.id, zoom: 17)),
    );
  }
}

class AppBarListScreen extends StatelessWidget {
  const AppBarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('List lokací'),
      centerTitle: true,
    );
  }
}
