import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bikereats/AllControllers/abstractFactory.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart';

class BicycleRackFactory extends AbstractFactory {
  @override
  Future <Marker> getMarker(LatLng rackLatLng, int rackId) async {
    ///
    final Uint8List markerIcon = await getBytesFromAsset('images/bicycleRackIcon.png', 100);
    Marker cycleMarker = Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon),
          position: rackLatLng,
          markerId: MarkerId("rackId " + rackId.toString()),
        );
    return cycleMarker;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

}