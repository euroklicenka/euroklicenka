import 'package:eurokey2/blocs/list_organizing_bloc/list_organizing_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///A Button for reversing the order of list items.
class SortOrderButton extends StatefulWidget {
  const SortOrderButton({super.key});

  @override
  State<SortOrderButton> createState() => _SortOrderButtonState();
}

class _SortOrderButtonState extends State<SortOrderButton> {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      splashRadius: 24,
      constraints: const BoxConstraints(),
      icon: Icon(context.watch<ListOrganizingBloc>().isReversed ? Icons.arrow_downward : Icons.arrow_upward),
      onPressed: () => context.read<ListOrganizingBloc>().add(OnReverseOrder()),
    );
  }
}
