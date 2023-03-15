import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:euk2_project/features/icon_management/icon_manager.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///The screen that shows the list of all EUK Locations.
class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<LocationManagementBloc>();
    return Column(
      children: [
        Expanded(
          child: bloc.locationManager.locations.isEmpty
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
                      itemCount: bloc.locationManager.locations.length,
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
    final EUKLocationData data = context.read<LocationManagementBloc>().locationManager.locations[index];
    return ListTile(
      title: Text(data.address),
      subtitle: Text('${data.city}, ${data.ZIP}'),
      trailing: getIconByType(data.type),
      onTap: () => context.read<LocationManagementBloc>().add(OnFocusOnEUKLocation(data.id, zoom: 17)),
    );
  }
}

///The AppBar for the List Screen.
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
