import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:euk2_project/features/icon_management/icon_manager.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as d;

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<EUKLocationData> sortedLocations = [];

  List<EUKLocationData> sortLocationsByDistance() {
    final LatLng userLocation = context.read<LocationManagementBloc>().userLocation.currentPosition;
    final List<EUKLocationData> locations = List.from(context.read<LocationManagementBloc>().locationManager.locations);
    const d.Distance distance = d.Distance();

    locations.sort((a, b) {
      final d.LatLng posUser = d.LatLng(userLocation.latitude, userLocation.longitude);
      final d.LatLng posA = d.LatLng(a.lat, a.long);
      final d.LatLng posB = d.LatLng(b.lat, b.long);
      final double aDistance = distance.as(d.LengthUnit.Kilometer, posUser, posA) as double;
      final double bDistance = distance.as(d.LengthUnit.Kilometer, posUser, posB) as double;
      return aDistance.compareTo(bDistance);
    });

    return locations;
  }

  @override
  void initState() {
    super.initState();
    sortedLocations = sortLocationsByDistance();
  }

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
                itemCount: sortedLocations.length,
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
    final EUKLocationData data = sortedLocations[index];

    final double distance = Geolocator.distanceBetween(
      context.read<LocationManagementBloc>().userLocation.currentPosition.latitude,
      context.read<LocationManagementBloc>().userLocation.currentPosition.longitude,
      data.location.latitude,
      data.location.longitude,
    );

    return ListTile(
      title: Text(data.address),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${data.city}, ${data.ZIP}'),
          SizedBox(height: 4),
          Text('${distance.toStringAsFixed(2)} km'),
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
