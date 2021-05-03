import 'package:bikereats/AllModels/address.dart';
import 'package:bikereats/AllModels/routeDetails.dart';
import "package:flutter/cupertino.dart";

/// The subject in the observer pattern that broadcast changes in the app
class AppData extends ChangeNotifier
{
  Address pickUpLocation, dropOffLocation;
  RouteDetails currentRoute;

  void updatePickUpLocationAddress(Address pickUpAddress)
  {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress)
  {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }

  void updateCurrentRoute(RouteDetails selectedRoute) {
    currentRoute = selectedRoute;
    notifyListeners();
  }
}