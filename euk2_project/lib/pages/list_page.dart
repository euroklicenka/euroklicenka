import 'package:flutter/material.dart';

const int itemCount = 20;

///AppBar of the List Screen.
AppBar listAppBar = AppBar(
  title: const Text("List"),
);

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: itemCount,
        itemBuilder: _listBuilder
    );
  }

  ///Builds the scrollable list.
  Widget _listBuilder(BuildContext ctx, int i) {
    return ListTile(
      title: Text("Adresa ${(i + 1)}"),
      subtitle: const Text('Město, Kraj'),
      leading: const Icon(Icons.accessible_sharp, color: Colors.red, size: 36,),
      trailing: const Icon(Icons.navigate_next),
      onTap: () {
        debugPrint("${(i)}");
      },
    );
  }
}
