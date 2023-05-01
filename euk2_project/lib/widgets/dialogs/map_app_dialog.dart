import 'package:eurokey2/blocs/external_map_bloc/external_map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';

///A Selection menu, where the user can pick a Map application from
///the ones currently installed on the device.
///
/// It displays all [maps] in a grid, shows a [headerText] above the window,
/// shows a toggle to set the next selected map as a default when [showDefaultSwitch] is on,
/// allows an action to be taken [onSelect] and when [onSelectNone] has an action assigned,
/// shows a special button below the window.
void openMapAppDialog({required BuildContext context, required List<AvailableMap> maps, required Function(AvailableMap map) onSelect, String headerText = 'Otevřít v aplikaci', bool showDefaultSwitch = true, Function()? onSelectNone}) {
  final dialogFlexibleHeight = MediaQuery.of(context).size.height * 0.3;

  ///Builds a Grid Tile for a map.
  Widget buildGridTile(BuildContext context, int index) {
    return MaterialButton(
      onPressed: () => onSelect(maps[index]),
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
    constraints: BoxConstraints(maxHeight: (dialogFlexibleHeight < 250) ? 250 : dialogFlexibleHeight),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                headerText,
                style: const TextStyle(
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
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 16,
                    ),
                  ),
                ),
              ),
              const Divider(),
              if (showDefaultSwitch)
                SwitchListTile.adaptive(
                  title: const Text('Použít vždy'),
                  value: context.watch<ExternalMapBloc>().nextAppIsDefault,
                  onChanged: context.read<ExternalMapBloc>().updateNextAppIsDefault,
                ),
              if (onSelectNone != null)
                ListTile(
                  onTap: onSelectNone,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cancel_outlined),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Zrušit výchozí',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
