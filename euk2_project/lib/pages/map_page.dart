import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

///AppBar of the More Screen.
AppBar? mapAppBar;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const frydekMistek = CameraPosition(
    target: LatLng(49.68852076393301, 18.350360094562493),
    zoom: 16,
  );

  MapType _currentMapType = MapType.normal;
  late GoogleMapController _googleMapController;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  final Set<Marker> markers = Set();
  LocationData? currentLocation;

  void getCurrentLocation() {
    Location location = Location();

    location.getLocation().then((location) => currentLocation = location);
  }

  void _changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        initialCameraPosition: frydekMistek,
        markers: getmarkers(),
        onMapCreated: (controller) => _googleMapController = controller,
        mapType: _currentMapType,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 95.0, right: 0.0),
        child: Column(
            children: [
              FloatingActionButton(
                backgroundColor: Colors.black12,
                foregroundColor: Colors.white,
                onPressed: () => _changeMapType(),
                child: Icon(_currentMapType == MapType.normal ? Icons.terrain_outlined : Icons.terrain),
              ),
              const SizedBox(
                height: 15,
              ),
              FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.black,
                onPressed: () => _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(frydekMistek)),
                child: const Icon(Icons.center_focus_strong),
              ),
            ],
          ),
      ),
    );
  }

  Set<Marker> getmarkers() {
    //markers to place on map
    setState(() {
      markers.add(const Marker(
        //add first marker
        markerId: MarkerId("Místo 1"),
        position: LatLng(49.68746018682944, 18.347490078175422),
        //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Kaufland',
          snippet: 'Toalety',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(const Marker(
        //add second marker
        markerId: MarkerId("Místo 2"),
        position: LatLng(49.69232909080795, 18.34361978613874),
        //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: '5. ZŠ',
          snippet: 'Toalety',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: const MarkerId("Místo 3"),
        position: const LatLng(49.690405721115575, 18.352883328092165),
        //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Nemocnice F-M',
          snippet: 'Toalety',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue), //Icon for Marker
      ));

      //add more markers here
    });

    return markers;
  }
}
