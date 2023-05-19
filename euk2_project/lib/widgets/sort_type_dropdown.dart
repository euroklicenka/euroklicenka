import 'package:eurokey2/blocs/list_organizing_bloc/list_organizing_bloc.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        borderRadius: BorderRadius.circular(20),
        iconSize: 0,
        value: currentValue,
        onChanged: (value) => setState(() => currentValue = value ?? 'Vzdálenost'),
        items: [
          buildItem(
            text: 'Vzdálenost',
            event: OnSortByLocationDistance(),
          ),
          buildItem(
            text: 'Adresa',
            event: OnSortByAddress(),
          ),
          buildItem(
            text: 'Město',
            event: OnSortByCity(),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildItem({required String text, required ListOrganizingEvent event}) {
    return DropdownMenuItem<String>(
      value: text,
      onTap: () => context.read<ListOrganizingBloc>().add(event),
      child: Text(text),
    );
  }
}
