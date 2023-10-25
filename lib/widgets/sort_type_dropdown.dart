import 'package:eurokey2/blocs/list_organizing_bloc/list_organizing_bloc.dart';
import 'package:eurokey2/utils/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///A Dropdown for selecting the order type of a list.
class SortTypeDropdown extends StatefulWidget {
  const SortTypeDropdown({super.key});

  @override
  State<SortTypeDropdown> createState() => _SortTypeDropdownState();
}

class _SortTypeDropdownState extends State<SortTypeDropdown> {
  String currentValue = 'Vzdálenost';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        borderRadius: BorderRadius.circular(15),
        isDense: true,
        iconSize: 0,
        value: currentValue,
        onChanged: (value) =>
            setState(() => currentValue = value ?? 'Vzdálenost'),
        items: [
          buildItem(
            text: 'Vzdálenost',
            icon: Icons.directions_car,
            event: OnSortByLocationDistance(),
          ),
          buildItem(
            text: 'Adresa',
            icon: Icons.sort_by_alpha,
            event: OnSortByAddress(),
          ),
          buildItem(
            text: 'Město',
            icon: Icons.sort_by_alpha,
            event: OnSortByCity(),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildItem(
      {required String text,
      required ListOrganizingEvent event,
      required IconData icon,}) {
    return DropdownMenuItem<String>(
      value: text,
      onTap: () => context.read<ListOrganizingBloc>().add(event),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.isAppInDarkMode ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
