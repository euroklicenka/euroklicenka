import 'package:flutter/material.dart';

class TestLocationData {
  final String _address;
  final String _city;
  final String _ZIP;
  final EUKLocationType _type;

  TestLocationData(this._address, this._city, this._ZIP, this._type);

  String get ZIP => _ZIP;
  String get city => _city;
  String get address => _address;
  EUKLocationType get type => _type;
}

enum EUKLocationType {
  none,
  wc,
  platform,
  hospital
}
