import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:eurokey2/models/eurolock_model.dart';
import 'package:eurokey2/models/location_model.dart';
import 'package:eurokey2/utils/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

///Screen that shows the primary map with EUK locations.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  final location = Location();

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final here = await location.getLocation();

    assert(here.latitude != null);
    assert(here.longitude != null);

    final cameraPosition = CameraPosition(
        target: LatLng(here.latitude!, here.longitude!), zoom: 15);

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    mapController = controller;
  }

  Future<Map<String, Marker>> _loadData(LatLng location) async {
    return await Provider.of<EurolockModel>(context, listen: false)
        .getMarkers(location);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationModel>(
      builder: (context, location, child) {
        mapController
            ?.moveCamera(CameraUpdate.newLatLng(location.currentPosition));
        return FutureBuilder<Map<String, Marker>>(
          future: _loadData(location.currentPosition),
          builder: (context, snapshot) {
            Map<String, Marker> _markers = {};
            if (snapshot.hasData) {
              _markers = snapshot.data!;
            } else if (snapshot.hasError) {
              // FIXME: handle error here
            } else {
              _markers.clear();
            }
            return GoogleMap(
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: location.currentPosition,
                zoom: 15.0,
              ),
              markers: _markers.values.toSet(),
            );
          },
        );
      },
    );
  }
}

///The AppBar for the Map Screen.
class AppBarMapScreen extends StatelessWidget {
  const AppBarMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LocationModel>(context, listen: false);
    return EasySearchBar(
      title: const Center(
        child: Text('Mapa míst'),
      ),
      animationDuration: const Duration(milliseconds: 260),
      searchClearIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.secondary),
      searchBackIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.secondary),
      searchCursorColor: Theme.of(context).colorScheme.secondary,
      searchBackgroundColor: context.isAppInDarkMode
          ? const Color(0xFF191919)
          : Theme.of(context).colorScheme.surface,
      onSearch: (value) => model.onSearch(value),
      searchHintText: 'Ostrava...',
    );
  }
}
