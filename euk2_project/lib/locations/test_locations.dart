import 'package:euk2_project/locations/location_data_test.dart';
import 'package:flutter/material.dart';

/// Location data for testing purposes.
final List<TestLocationData> testDestinations = [
  TestLocationData('Hypermarket Kaufland, Olomoucká 2995', 'Opava', '746 O1', TestLocationType.wc),
  TestLocationData('Železniční stanice Opava východ', 'Opava', '747 05', TestLocationType.wc),
  TestLocationData('Centrum Sociálních Služeb, Hrabyně 3/202', 'Hrabyně', '747 67', TestLocationType.wc),
  TestLocationData('Veřejné WC u železniční stanice', 'Hradec nad Moravicí', '747 41', TestLocationType.wc),
  TestLocationData('Rekreační areál Štěrkovna', 'Hlučín', '748 01', TestLocationType.wc),
  TestLocationData('Fakultní nemocnice Ostrava, 17. listopadu 1790', 'Ostrava', '708 52', TestLocationType.hospital),
];

Icon getIconByType(TestLocationType type) {
  switch (type) {
    case TestLocationType.wc:
      return const Icon(Icons.wc, color: Colors.blue, size: 28,);
    case TestLocationType.platform:
      return const Icon(Icons.accessible_sharp, color: Colors.red, size: 28,);
    case TestLocationType.hospital:
      return const Icon(Icons.local_hospital, color: Colors.green, size: 28,);
  }
}
