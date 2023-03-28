import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:euk2_project/features/external_map/map_app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:meta/meta.dart';

part 'external_map_event.dart';

part 'external_map_state.dart';

///Handles events dealing with external map applications.
class ExternalMapBloc extends Bloc<ExternalMapEvent, ExternalMapState> {
  ExternalMapBloc() : super(ExternalMapInitial()) {
    on<OnOpenForNavigation>(_onNavigate);
  }

  FutureOr<void> _onNavigate(OnOpenForNavigation event, emit) {
    openMapAppDialog(
      context: event.context,
      onSelect: (map) => {
        map.showDirections(
          destination: Coords(event.lat, event.long),
        )
      },
    );
  }
}
