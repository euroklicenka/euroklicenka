
import 'package:eurokey2/features/location_data/euk_location_data.dart';
import 'package:eurokey2/widgets/popup_window.dart';
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
