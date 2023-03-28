import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

class EUKPopupWindow extends StatelessWidget {
  late String _address, _region, _city, _ZIP, _info;
  late double _lat, _long;

  EUKPopupWindow({super.key, required String address, required String region,
      required String city, required String ZIP, required String info,
      required double lat, required double long}) {
    _address = address;
    _region = region;
    _city = city;
    _ZIP = ZIP;
    _info = info;
    _lat = lat;
    _long = long;
  }

  @override
  Widget build(BuildContext context) {
    const double headerSize = 18;
    const double textSize = 16;
    const double elementSpace = 4;
    final Color? iconColor = Colors.amber[900];
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0, bottom: 6.0),
        child: Column(
          children: [
            Text(
              _address,
              maxLines: 3,
              style: const TextStyle(fontSize: headerSize, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Tooltip(
                              message: 'Město',
                              triggerMode: TooltipTriggerMode.tap,
                              child: Icon(
                                Icons.location_city_outlined,
                                color: iconColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '$_city, $_ZIP',
                                maxLines: 2,
                                style: const TextStyle(fontSize: textSize),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: elementSpace),
                        Row(
                          children: [
                            Tooltip(
                              message: 'Kraj',
                              triggerMode: TooltipTriggerMode.tap,
                              child: Icon(Icons.map, color: iconColor,),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _region,
                                maxLines: 2,
                                style: const TextStyle(fontSize: textSize),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: elementSpace),
                        Row(
                          children: [
                            Tooltip(
                              message: 'Info',
                              triggerMode: TooltipTriggerMode.tap,
                              child: Icon(Icons.info_outline, color: iconColor,),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _info,
                                style: const TextStyle(fontSize: textSize),
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              height: elementSpace,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final List<AvailableMap> availableMaps = await MapLauncher.installedMaps;

                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: SingleChildScrollView(
                            child: Container(
                              child: Wrap(
                                children: <Widget>[
                                  for (var map in availableMaps)
                                    ListTile(
                                      onTap: () => map.showDirections(
                                        destination: Coords(_lat, _long),
                                      ),
                                      title: Text(map.mapName),
                                      
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Navigovat', style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
