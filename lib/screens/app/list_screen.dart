import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:eurokey2/models/eurolock_model.dart';
import 'package:eurokey2/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  EasySearchBar appBar(BuildContext context) {
    final eukModel = Provider.of<EurolockModel>(context, listen: false);
    return EasySearchBar(
      title: const Center(
        child: Text('Seznam nejbližších míst'),
      ),
      animationDuration: const Duration(milliseconds: 260),
      searchClearIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.secondary),
      searchBackIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.secondary),
      searchCursorColor: Theme.of(context).colorScheme.secondary,
      searchBackgroundColor: Theme.of(context).colorScheme.surface,
      onSearch: (value) => eukModel.onSearch(value),
      searchHintText: 'Ostrava...',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: const ListScreenBody(),
    );
  }
}

class ListScreenBody extends StatefulWidget {
  const ListScreenBody({super.key});

  @override
  State<ListScreenBody> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreenBody> {
  Future<List<Widget>> _loadData(BuildContext context, LatLng location) async {
    return await Provider.of<EurolockModel>(context, listen: false)
        .getList(context, location);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationModel, EurolockModel>(
      builder: (context, locModel, eukModel, child) {
        return FutureBuilder<List<Widget>>(
          future: _loadData(context, locModel.currentPosition),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              assert(snapshot.data != null);
              eukModel.cleanupCurrentEUK();
              return ListView(children: snapshot.data!); // snapshot.data!
            } else if (snapshot.hasError) {
              throw Exception(snapshot.error.toString());
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
