import 'package:flutter/material.dart';

//const int itemCount = 20;

///AppBar of the List Screen.
AppBar listAppBar = AppBar(
  title: const Text("List"),
);


final List<String> destination = [
  "Hypermarket Kaufland, Olomoucká 2995, 746 O1, Opava",
  "Železniční stanice Opava východ, Jánská 691/1 746 01, Opava",
  "Hypermarket Kaufland, Hlučínská 1698/5, 747 05, Opava",
  "Centrum Sociálních Služeb, Hrabyně 3/202, 747 67, Hrabyně",
  "Veřejné WC u železniční stanice, 747 41, Hradec nad Moravicí",
  "Rekreační areál Štěrkovna, 748 01, Hlučín",
  "Fakultní nemocnice Ostrava, 17. listopadu 1790, 708 52 Ostrava"
];


class ListPage extends StatelessWidget {
  const ListPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: 7,
            itemBuilder: (BuildContext context, int index){
            return Card(
              elevation: 4.5,
              child: ListTile(
                leading: CircleAvatar(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      //color: Colors.cyan,
                      borderRadius: BorderRadius.circular(13.9)
                    ),
                    //child: Text("H"),
                  ),
                ),
                trailing: const Text("..."),
                title: Text(destination[index]),
               //subtitle: Text("Sub"),
                onTap: () => debugPrint("City: ${destination.elementAt(index)}"),
              ),
            );
        }),
    );
  }

}
