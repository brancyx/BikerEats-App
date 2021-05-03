import 'dart:async';
import 'package:bikereats/AllControllers/routeManager.dart';
import 'package:bikereats/AllWidgets/near_me.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

/// UI to display map & nearest food places to the user
class FoodScreen extends StatefulWidget {
  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen>
    with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  final panelController = PanelController();
  final double tabBarHeight = 200;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await RouteManager.searchCoordinateAddress(position, context);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(1.339040, 103.857590),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Nearby"),
      ),
      body: Stack(
        children: [
          GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {
                  bottomPaddingOfMap = 0.0;
                });

                locatePosition();
              }),
          SlidingUpPanel(
            backdropEnabled: true,
            header: Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 180.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 50,
                height: 8,
              ),
            ),
            collapsed: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(color: Colors.green[400]),
                    alignment: Alignment.topCenter,
                    height: 60.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 50,
                            height: 8,
                          ),
                        ),
                        Text("Explore food nearby!",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            panelBuilder: (scrollController) => buildSlidingPanel(
              scrollController: scrollController,
              panelController: panelController,
            ),
            panel: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: NearMeWidget(),
            ),
            minHeight: 60,
            maxHeight: 400,
          )
        ],
      ),
    );
  }
}

/// Create and display slide up panel
Widget buildSlidingPanel({
  @required PanelController panelController,
  @required ScrollController scrollController,
}) =>
    DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.green,
                title: const Text("Explore food nearby: ",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                actions: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 50,
                height: 8,
              ),
            ])));
