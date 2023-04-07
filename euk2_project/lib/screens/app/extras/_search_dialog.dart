import 'package:euk2_project/blocs/list_sorting_bloc/list_sorting_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _SearchDialog extends StatefulWidget {
  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hledat EUK lokality'),
      content: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Hledat...',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          context.read<ListSortingBloc>().add(OnFilterLocations(value));
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Zavřít'),
        ),
      ],
    );
  }
}