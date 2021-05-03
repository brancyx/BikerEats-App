import 'package:bikereats/AllControllers/requestManager.dart';
import 'package:bikereats/AllModels/address.dart';
import 'package:bikereats/AllModels/routeDetails.dart';
import 'package:bikereats/configMaps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Handles all logic related to getting cycling routes
class RouteManager {
  /// Find address by the coordinates
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String st1, st2;
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestManager.getRequest(url);

    if (response != "failed") {
      st1 = response["results"][0]["address_components"][3]["long_name"];
      st2 = response["results"][0]["address_components"][4]["long_name"];

      placeAddress = st1 + ", " + st2;

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;
    }
    return placeAddress;
  }

  /// Get details of cycling route so it can be plotted on the map
  static Future<RouteDetails> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&avoid=highways&mode=walking&key=$mapKey";

    var res = await RequestManager.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    RouteDetails directionDetails = RouteDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

/// Get details list of Food Places json data
  static Future<List<dynamic>> obtainFoodPlaces(LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${finalPosition.latitude},${finalPosition.longitude}&radius=1500&type=restaurant&key=$mapKey";

    var res = await RequestManager.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    List<dynamic> result = res["results"];
    return result;
  }
}
