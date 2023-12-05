import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:eurokey2/models/eurolock_model.dart';
import 'package:eurokey2/models/location_model.dart';
import 'package:eurokey2/utils/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Future<List<Widget>> _loadData(LatLng location) async {
    return await Provider.of<EurolockModel>(context, listen: false)
        .sortList(location);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationModel>(
      builder: (context, location, child) {
        return FutureBuilder<List<Widget>>(
          future: _loadData(location.currentPosition),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              assert(snapshot.data != null);
              return ListView(children: snapshot.data!); // snapshot.data!
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Loading data...'),
              );
            }
          },
        );
      },
    );
  }
}

class AppBarListScreen extends StatelessWidget {
  const AppBarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eurolocks = Provider.of<EurolockModel>(context, listen: false);
    return EasySearchBar(
      title: const Center(
        child: Text('Seznam míst'),
      ),
      animationDuration: const Duration(milliseconds: 260),
      searchClearIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.secondary),
      searchBackIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.secondary),
      searchCursorColor: Theme.of(context).colorScheme.secondary,
      searchBackgroundColor: context.isAppInDarkMode
          ? const Color(0xFF191919)
          : Theme.of(context).colorScheme.surface,
      onSearch: (value) => eurolocks.onSearch(value),
      searchHintText: 'Ostrava...',
    );
  }
}
