import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Parent class for marker factories.
abstract class AbstractFactory {
  /// Get markers to plot on the map.
  Future <Marker> getMarker(LatLng rackLatLng, int rackId);
}