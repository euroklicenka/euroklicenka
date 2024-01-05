import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:eurokey2/providers/eurolock_provider.dart';
import 'package:eurokey2/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  PreferredSizeWidget appBar(BuildContext context) {
    final eurolockProvider =
        Provider.of<EurolockProvider>(context, listen: false);
    return EasySearchBar(
      title: const Center(
        child: Text('Seznam nejbližších míst'),
      ),
      animationDuration: const Duration(milliseconds: 260),
      onSearch: (value) => eurolockProvider.onSearch(value),
      searchHintText: 'Ostrava...',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
  Future<List<Widget>> _loadData(
    BuildContext context,
    EurolockProvider eukProvider,
    LocationProvider locationProvider,
  ) async {
    return await eukProvider.getList(
      context,
      locationProvider.currentUserPosition,
      locationProvider.currentMapPosition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<EurolockProvider, LocationProvider>(
      builder: (context, eukProvider, locationProvider, child) {
        return FutureBuilder<List<Widget>>(
          future: _loadData(context, eukProvider, locationProvider),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              assert(snapshot.data != null);
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
