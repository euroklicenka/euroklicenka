part of 'external_map_bloc.dart';

@immutable
abstract class ExternalMapEvent { const ExternalMapEvent(); }

///Request navigation in another supported map app.
class OnOpenForNavigation extends ExternalMapEvent {
  final BuildContext context;
  final double lat, long;

  const OnOpenForNavigation({
    required this.context,
    required this.lat,
    required this.long,
  });
}

///Request to change the default map app.
class OnChangeDefaultMapApp extends ExternalMapEvent {
  final BuildContext context;

  const OnChangeDefaultMapApp({
    required this.context,
  });
}

///Assign default map app data directly.
class OnFinishDefaultMapAppSetting extends ExternalMapEvent {
  final BuildContext context;
  final int mapIndex;
  final String mapIcon;

  const OnFinishDefaultMapAppSetting({
    required this.context,
    required this.mapIndex,
    required this.mapIcon,
  });
}

class OnInit extends ExternalMapEvent {}
