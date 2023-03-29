import 'package:euk2_project/blocs/external_map_bloc/external_map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';

///A Selection menu, where the user can pick a Map application from
///the ones currently installed on the device.
void openMapAppDialog({required BuildContext context, required List<AvailableMap> maps, required Function(AvailableMap map) onSelect}) {

  ///Builds a Grid Tile for a map.
  Widget buildGridTile(BuildContext context, int index) {
    return MaterialButton(
      onPressed: () => {}, //onSelect(maps[index]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
              child: SvgPicture.asset(maps[index].icon, width: 64,),
          ),
          const SizedBox(height: 8),
          Text(maps[index].mapName),
        ],
      ),
    );
  }

  showModalBottomSheet(

    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 8),
          child: Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Otevřít v aplikaci',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: GridView.builder(
                      itemCount: maps.length,
                      itemBuilder: buildGridTile,
                      // shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                SwitchListTile.adaptive(
                  title: const Text('Použít vždy'),
                  value: context.watch<ExternalMapBloc>().nextAppIsDefault,
                  onChanged: context.read<ExternalMapBloc>().updateNextAppIsDefault,
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
