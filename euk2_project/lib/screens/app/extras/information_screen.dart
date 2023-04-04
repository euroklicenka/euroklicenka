import 'package:flutter/material.dart';

///The information screen, that shows general info about the app as well as
///it's version.
class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
      ),
      body: const Center(
        child: Text('Future Information screen here!!!'),
      ),
    );
  }
}
