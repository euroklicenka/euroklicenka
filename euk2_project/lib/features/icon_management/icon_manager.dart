import 'dart:ui' as ui;

import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

ui.Image? _clusterIcon;

///Returns an [Icon], representing the given location [type].
Icon getIconByType(EUKLocationType type) {
  switch (type) {
    case EUKLocationType.none:
      return const Icon(
        Icons.lock,
        color: Colors.deepOrangeAccent,
        size: 28,
      );
    case EUKLocationType.wc:
      return const Icon(
        Icons.wc,
        color: Colors.blue,
        size: 28,
      );
    case EUKLocationType.platform:
      return const Icon(
        Icons.accessible_sharp,
        color: Colors.red,
        size: 28,
      );
    case EUKLocationType.hospital:
      return const Icon(
        Icons.local_hospital,
        color: Colors.green,
        size: 28,
      );
    case EUKLocationType.gate:
      return const Icon(
        Icons.door_sliding,
        color: Colors.teal,
        size: 28,
      );
    case EUKLocationType.elevator:
      return const Icon(
        Icons.elevator,
        color: Colors.black38,
        size: 28,
      );
  }
}

///Returns a custom marker icon, based on an EUK location type.
Future<BitmapDescriptor> getMarkerIconByType(EUKLocationType type) async {
  Uint8List icon;
  const int size = 110;

  switch (type) {
    case EUKLocationType.none:
      icon = await _getBytesFromAsset("assets/images/map_marker_default.png", size);
      break;
    case EUKLocationType.wc:
      icon = await _getBytesFromAsset("assets/images/map_marker_wc.png", size);
      break;
    case EUKLocationType.platform:
      icon = await _getBytesFromAsset("assets/images/map_marker_platform.png", size);
      break;
    case EUKLocationType.hospital:
      icon = await _getBytesFromAsset("assets/images/map_marker_hospital.png", size);
      break;
    case EUKLocationType.gate:
      icon = await _getBytesFromAsset("assets/images/map_marker_gate.png", size);
      break;
    case EUKLocationType.elevator:
      icon = await _getBytesFromAsset("assets/images/map_marker_elevator.png", size);
      break;
  }

  return BitmapDescriptor.fromBytes(icon);
}

///Creates a new icon for a cluster.
///
/// [size] controls how big the icon is.
///
/// [text] controls what text is written at the cneter of the icon.
Future<BitmapDescriptor> getClusterIcon(int size, {String? text}) async {
  await _tryInitClusterIcon();

  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final double ratio = _clusterIcon!.width / _clusterIcon!.height;

  canvas.drawImageNine(_clusterIcon!, Rect.zero, Rect.fromCenter(center: Offset(size / 2, size / 2), width: size.toDouble() * ratio + 10, height: size.toDouble()), Paint());

  if (text != null) {
    final TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(
          fontSize: size / 3,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        shadows: const <Shadow>[
          Shadow(
            offset: Offset(1.0, 1.0),
            color: Color.fromARGB(255, 142, 11, 25),
          )
        ],
      ),
    );
    painter.layout();
    painter.paint(canvas, Offset(size / 2 - painter.width / 2, size / 2));
  }

  final img = await pictureRecorder.endRecording().toImage(size, size);
  final ByteData? data = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
}

///Returns a PNG image as bytes under a specific [path] with a [width].
Future<Uint8List> _getBytesFromAsset(String path, int width) async {
  final ByteData data = await rootBundle.load(path);
  final ui.Codec codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
  );
  final ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png,))!.buffer.asUint8List();
}

/// The cluster icon gets initialized if it wasn't already.
Future<void> _tryInitClusterIcon() async {
  if (_clusterIcon != null) return;
  final ui.ImageDescriptor descriptor = await ui.ImageDescriptor.encoded(await ImmutableBuffer.fromAsset("assets/images/map_cluster.png"));
  final ui.Codec codec = await descriptor.instantiateCodec();
  final ui.FrameInfo frame = await codec.getNextFrame();
  _clusterIcon = frame.image;
}
