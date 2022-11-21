import 'package:flutter/material.dart';

class TestLocationData {
  final String _address;
  final String _city;
  final String _ZIP;
  final TestLocationType _type;

  TestLocationData(this._address, this._city, this._ZIP, this._type);

  String get ZIP => _ZIP;
  String get city => _city;
  String get address => _address;
  TestLocationType get type => _type;
}

enum TestLocationType {
  wc,
  platform,
  hospital
}
