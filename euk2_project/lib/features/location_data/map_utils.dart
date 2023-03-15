import 'dart:ui';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/features/icon_management/icon_manager.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/popup_window/popup_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

  ///Builds a [EUKPopupWindow] from [EUKLocationData] and returns it.
  Widget buildPopUpWindow(EUKLocationData data) {
    return EUKPopupWindow(
      address: data.address,
      region: data.region,
      city: data.city,
      info: data.info,
      ZIP: data.ZIP,
    );
  }
