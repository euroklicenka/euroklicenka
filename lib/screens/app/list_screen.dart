import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:eurokey2/models/eurolock_model.dart';
import 'package:eurokey2/models/location_model.dart';
import 'package:flutter/material.dart';
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
  Future<List<Widget>> _loadData(
    BuildContext context,
    EurolockModel eukModel,
    LocationModel locModel,
  ) async {
    return await eukModel.getList(context, locModel.currentPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<EurolockModel, LocationModel>(
      builder: (context, eukModel, locModel, child) {
        return FutureBuilder<List<Widget>>(
          future: _loadData(context, eukModel, locModel),
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
