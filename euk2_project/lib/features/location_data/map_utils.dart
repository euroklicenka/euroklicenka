
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/popup_window/popup_window.dart';
import 'package:flutter/material.dart';

  ///Builds a [EUKPopupWindow] from [EUKLocationData] and returns it.
  Widget buildPopUpWindow(EUKLocationData data) {
    return EUKPopupWindow(
      address: data.address,
      region: data.region,
      city: data.city,
      info: data.info,
      ZIP: data.ZIP,
      lat: data.lat,
      long: data.long,
    );
  }
