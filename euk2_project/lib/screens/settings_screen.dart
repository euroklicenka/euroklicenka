import 'package:flutter/material.dart';

bool isCheckedSettings1 = false;
bool isCheckedSettings2 = false;
bool isCheckedSettings3 = false;

///AppBar of the More Screen.
AppBar settingsAppBar = AppBar(
  title: const Text("Nastavení"),
);

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                isCheckedSettings1 = !isCheckedSettings1;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Nastavení 1", style: TextStyle(fontSize: 20)),
                Switch(
                    value: isCheckedSettings1,
                    onChanged: (bool change) {
                      setState(() {
                        isCheckedSettings1 = change;
                      });
                    })
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                isCheckedSettings2 = !isCheckedSettings2;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Nastavení 2", style: TextStyle(fontSize: 20)),
                Switch(
                    value: isCheckedSettings2,
                    onChanged: (bool change) {
                      setState(() {
                        isCheckedSettings2 = change;
                      });
                    })
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                isCheckedSettings3 = !isCheckedSettings3;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Nastavení 3", style: TextStyle(fontSize: 20)),
                Switch(
                    value: isCheckedSettings3,
                    onChanged: (bool change) {
                      setState(() {
                        isCheckedSettings3 = change;
                      });
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
