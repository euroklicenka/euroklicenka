part of 'external_map_bloc.dart';

@immutable
abstract class ExternalMapEvent { const ExternalMapEvent(); }

class OnOpenForNavigation extends ExternalMapEvent {
  final BuildContext context;
  final double lat, long;

  const OnOpenForNavigation({
    required this.context,
    required this.lat,
    required this.long,
  });
}

class OnChangeDefaultMapApp extends ExternalMapEvent {
  final BuildContext context;

  const OnChangeDefaultMapApp({
    required this.context,
  });
}
