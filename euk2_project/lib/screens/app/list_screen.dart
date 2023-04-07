import 'package:euk2_project/blocs/list_sorting_bloc/list_sorting_bloc.dart';
import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:euk2_project/features/icon_management/icon_manager.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = true;
        });
      } else if (_scrollController.offset <= 300 && _showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: context
                  .read<ListSortingBloc>()
                  .sortedLocations
                  .isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Žádné položky nebyly nalezeny. \n\n Zkus aktualizovat databázi v menu Více.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
                  : Scrollbar(
                thumbVisibility: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      const Divider(),
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: context
                              .read<ListSortingBloc>()
                              .sortedLocations
                              .length,
                          itemBuilder: _buildListTile,
                          separatorBuilder:
                              (BuildContext context, int index) =>
                          const Divider(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_showScrollToTopButton)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                child: const Icon(Icons.arrow_upward),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, int index) {
    final EUKLocationData data =
    context.read<ListSortingBloc>().sortedLocations[index];
    final String distanceText = context
        .read<LocationManagementBloc>()
        .userLocation
        .isSameAsDefaultPos()
        ? '---- km'
        : '${data.distanceFromDevice.toStringAsFixed(2)} km';

    return ListTile(
        title: Text(data.address),
    subtitle: Text('${data.city}, ${data.ZIP}'),
    trailing: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
    getIconByType(data.type),
    const SizedBox(
    height: 4,
    ),
    Text(
    distanceText,
    ),
    ],
    ),
      onTap: () => context
          .read<LocationManagementBloc>()
          .add(OnFocusOnEUKLocation(data.id, zoom: 17)),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class AppBarListScreen extends StatelessWidget {
  const AppBarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Seznam míst'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => _SearchDialog(),
            );
          },
        ),
      ],
    );
  }
}

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
      title: const Text('Hledat Euroklíč lokality'),
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