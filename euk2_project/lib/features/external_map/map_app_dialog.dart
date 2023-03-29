import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';

///A Selection menu, where the user can pick a Map application from
///the ones currently installed on the device.
void openMapAppDialog({required BuildContext context, required List<AvailableMap> maps, required Function(AvailableMap map) onSelect}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              for (var map in maps)
                ListTile(
                  onTap: () => onSelect(map),
                  title: Text(map.mapName),
                  leading: SvgPicture.asset(
                    map.icon,
                    height: 30.0,
                    width: 30.0,
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
