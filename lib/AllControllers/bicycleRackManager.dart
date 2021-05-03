import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bikereats/AllControllers/abstractFactory.dart';
import 'package:bikereats/AllControllers/factoryProducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class BicycleRackManager {
  
  /// Convert original format of an image to bytes format
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
  
  /// add Bicycle racks to a map of Bicycle racks
  void setBicycleRacks(BuildContext context, Set<Marker> markers) async {
      String data = await DefaultAssetBundle.of(context)
          .loadString("assets/bicycle-rack.geojson");
      final jsonResult = json.decode(data);
      var rackLat;
      var rackLng;
      var rackLatLng;
      int rackListLength = jsonResult["features"].length;
      AbstractFactory fac = FactoryProducer().getFactory("bicycle");
      if (fac != null) {
          for (var rackId = 0; rackId < rackListLength; rackId++) {
          rackLat = jsonResult["features"][rackId]["geometry"]["coordinates"][1];
          rackLng = jsonResult["features"][rackId]["geometry"]["coordinates"][0];
          rackLatLng = LatLng(rackLat, rackLng);
          Marker cycleMarker = await fac.getMarker(rackLatLng, rackId);
          markers.add(cycleMarker);
        }
      }
  }
}