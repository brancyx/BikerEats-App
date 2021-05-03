import 'dart:async';
import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:bikereats/AllControllers/bicycleRackManager.dart';
import 'package:bikereats/AllControllers/weatherManager.dart';
import 'package:bikereats/AllModels/favourite.dart';
import 'package:bikereats/AllModels/history.dart';
import 'package:bikereats/AllScreens/exploreScreen.dart';
import 'package:bikereats/AllControllers/profileManager.dart';
import 'package:bikereats/AllScreens/searchScreen.dart';
import 'package:bikereats/AllControllers/routeManager.dart';
import 'package:bikereats/AllWidgets/near_me.dart';
import 'package:bikereats/DataHandler/appData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

/// UI for handling a user's cycling journey
class CycleScreen extends StatefulWidget {
  static const String idScreen = "cycle";

  @override
  _CycleScreenState createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen>
    with SingleTickerProviderStateMixin {
  double ratings = 0.00001;

  addNewHistory(String startpoint, String endpoint, double ratings) {
    final FirebaseDatabase _database = FirebaseDatabase.instance;
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    if (startpoint.length > 0 && endpoint.length > 0) {
      History history = new History(startpoint.toString(), endpoint.toString(),
          (ratings + 0.00001).toDouble());
      _database.reference()
        ..child("users")
            .child(_firebaseAuth.currentUser.uid)
            .child("history")
            .push()
            .set(history.toJson());
    }
  }

  addToFavourites(String startpoint, double startlat, double startlong,
      String endpoint, double endlat, double endlong) {
    final FirebaseDatabase _database = FirebaseDatabase.instance;
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    if (startpoint.length > 0 && endpoint.length > 0) {
      Favourites favourites = new Favourites(
          startpoint.toString(),
          startlat.toDouble(),
          startlong.toDouble(),
          endpoint.toString(),
          endlat.toDouble(),
          endlong.toDouble());
      _database.reference()
        ..child("users")
            .child(_firebaseAuth.currentUser.uid)
            .child("favourites")
            .push()
            .set(favourites.toJson());
    }
  }

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  BitmapDescriptor pinLocationIcon;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  Set<Marker> markers = {};
  Set<Circle> circles = {};

  static bool favourited = false;

  final panelController = PanelController();
  final double tabBarHeight = 200;

  /// Set the initial camera position to NTU
  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(1.339040, 103.857590),
    zoom: 14.4746,
  );

  /// animates the map to the current location
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: initialCameraPosition,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              markers: markers,
              circles: circles,
              polylines: polylineSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
                setState(() {
                  BicycleRackManager().setBicycleRacks(context, markers);
                  bottomPaddingOfMap = 100.0;
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
          ),
          Positioned(
            left: 10.0,
            right: 10.0,
            top: 80.0,
            child: GestureDetector(
              onTap: () async {
                var res = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));

                if (res == "obtainDirection") {
                  await getPlaceDirection();
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        )
                      ]),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                        height: 50.0,
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(
                        width: 10.0,
                        height: 50.0,
                      ),
                      Text(
                        "Select locations...",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      // Text("Enter a start point", textAlign: TextAlign.center,style: TextStyle(fontSize: 20),)
                    ],
                  )),
            ),
          ),
          Positioned(
            top: 155.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () async {
                var res = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ExploreScreen()));

                if (res == "obtainDirection") {
                  await getPlaceDirection();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 60.0,
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.location_pin,
                                        size: 30.0, color: Colors.blue),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Icon(Icons.stop_circle,
                                        size: 25.0, color: Colors.red),
                                    SizedBox(height: 10.0),
                                    Icon(Icons.access_time_sharp,
                                        size: 25.0, color: Colors.black),
                                  ]),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Provider.of<AppData>(context)
                                                .pickUpLocation !=
                                            null
                                        ? Provider.of<AppData>(context)
                                            .pickUpLocation
                                            .placeName
                                        : "Enter a start point",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "Brand-Bold"),
                                  ),
                                  SizedBox(height: 15.0),
                                  Text(
                                    Provider.of<AppData>(context)
                                                .dropOffLocation !=
                                            null
                                        ? Provider.of<AppData>(context)
                                            .dropOffLocation
                                            .placeName
                                        : "Enter an end point",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "Brand-Bold"),
                                  ),
                                  SizedBox(height: 15.0),
                                  Text(
                                    Provider.of<AppData>(context)
                                                .currentRoute !=
                                            null
                                        ? Provider.of<AppData>(context)
                                            .currentRoute
                                            .durationText
                                        : "",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "Brand-Bold"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              favourited
                                  ? IconButton(
                                      icon: Icon(Icons.favorite,
                                          size: 30.0, color: Colors.pink),
                                      tooltip: 'Add to favourites',
                                      onPressed: () {
                                        setState(() {
                                          profileManager.displayToastMessage(
                                              "Removed from Favourites!",
                                              context);
                                          favourited = false;
                                        });
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.favorite_border_outlined,
                                          size: 30.0, color: Colors.pink),
                                      tooltip: 'Add to favourites',
                                      onPressed: () {
                                        var start = Provider.of<AppData>(
                                                context,
                                                listen: false)
                                            .pickUpLocation
                                            .placeName;
                                        var startlat = Provider.of<AppData>(
                                                context,
                                                listen: false)
                                            .pickUpLocation
                                            .latitude;
                                        var startlong = Provider.of<AppData>(
                                                context,
                                                listen: false)
                                            .pickUpLocation
                                            .longitude;
                                        var end = Provider.of<AppData>(context,
                                                listen: false)
                                            .dropOffLocation
                                            .placeName;
                                        var endlat = Provider.of<AppData>(
                                                context,
                                                listen: false)
                                            .dropOffLocation
                                            .latitude;
                                        var endlong = Provider.of<AppData>(
                                                context,
                                                listen: false)
                                            .dropOffLocation
                                            .longitude;
                                        addToFavourites(start, startlat,
                                            startlong, end, endlat, endlong);
                                        setState(() {
                                          profileManager.displayToastMessage(
                                              "Saved to Favourites!", context);
                                          favourited = true;
                                        });
                                      },
                                    ),
                              ElevatedButton(
                                child: Text("Start"),
                                onPressed: () async {
                                  var dropOffLatLng = LatLng(
                                      Provider.of<AppData>(context,
                                              listen: false)
                                          .dropOffLocation
                                          .latitude,
                                      Provider.of<AppData>(context,
                                              listen: false)
                                          .dropOffLocation
                                          .longitude);
                                  var weatherDetails =
                                      await WeatherManager.obtainWeather(
                                          dropOffLatLng);
                                  print(weatherDetails);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Weather"),
                                          content: Text("Weather: " +
                                              weatherDetails.description +
                                              "\n" +
                                              "Temperature: " +
                                              weatherDetails.temp.toString() +
                                              "°C"),
                                          actions: [
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Continue"),
                                              onPressed: () async {
                                                await startJourney();

                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Center(
                                                          child: Text(
                                                              "Trip Completed!",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      25)),
                                                        ),
                                                        content: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Column(children: [
                                                              Text(
                                                                "Distance Cycled: " +
                                                                    Provider.of<AppData>(
                                                                            context)
                                                                        .currentRoute
                                                                        .distanceText,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      22.0,
                                                                  fontFamily:
                                                                      "Brand-Bold",
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ]),
                                                            SizedBox(
                                                                height: 30),
                                                            Icon(
                                                                Icons
                                                                    .check_circle_rounded,
                                                                color: Colors
                                                                    .green,
                                                                size: 150),
                                                            SizedBox(
                                                                height: 30),
                                                            Text(
                                                              "How would you rate journey?",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 25.0,
                                                                fontFamily:
                                                                    "Brand-Bold",
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 15),
                                                            RatingBar.builder(
                                                              initialRating: 0,
                                                              minRating: 1,
                                                              direction: Axis
                                                                  .horizontal,
                                                              allowHalfRating:
                                                                  true,
                                                              itemCount: 5,
                                                              itemPadding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4.0),
                                                              itemBuilder:
                                                                  (context,
                                                                          _) =>
                                                                      Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              onRatingUpdate:
                                                                  (rating) {
                                                                print(rating);
                                                                ratings =
                                                                    rating;
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            child: Text("Save"),
                                                            style: TextButton.styleFrom(
                                                                textStyle:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            24),
                                                                primary: Colors
                                                                    .green,
                                                                onSurface:
                                                                    Colors.green[
                                                                        900]),
                                                            onPressed: () {
                                                              var start = Provider.of<
                                                                          AppData>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .pickUpLocation
                                                                  .placeName;

                                                              var end = Provider.of<
                                                                          AppData>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .dropOffLocation
                                                                  .placeName;
                                                              addNewHistory(
                                                                  start,
                                                                  end,
                                                                  ratings);

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                            )
                                          ],
                                        );
                                      });
                                },
                              ),
                            ],
                          )
                        ],
                      )))),
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
            maxHeight: 450,
          ),
        ],
      ),
    );
  }

  /// Get directions for the user's chosen cycling journey
  Future<void> getPlaceDirection() async // creates a new map with a route drawn
  {
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    var details = await RouteManager.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);
    Provider.of<AppData>(context, listen: false).updateCurrentRoute(details);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();

    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: initialPos.placeName, snippet: "Start Location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalPos.placeName, snippet: "End Location"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markers.add(pickUpLocMarker);
      markers.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
        fillColor: Colors.red,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.redAccent,
        circleId: CircleId("pickUpId"));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.red,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.redAccent,
        circleId: CircleId("dropOffId"));

    setState(() {
      circles.add(pickUpLocCircle);
      circles.add(dropOffLocCircle);
    });
  }

  Future<void> startJourney() async {
    String origin = Provider.of<AppData>(context, listen: false)
            .pickUpLocation
            .latitude
            .toString() +
        "," +
        Provider.of<AppData>(context, listen: false)
            .pickUpLocation
            .longitude
            .toString();
    String destination = Provider.of<AppData>(context, listen: false)
            .dropOffLocation
            .latitude
            .toString() +
        "," +
        Provider.of<AppData>(context, listen: false)
            .dropOffLocation
            .longitude
            .toString();
    if (Platform.isAndroid) {
      final AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(
              "https://www.google.com/maps/dir/?api=1&origin=" +
                  origin +
                  "&destination=" +
                  destination +
                  "&travelmode=walking&dir_action=navigate"),
          package: 'com.google.android.apps.maps');
      intent.launch();
    } else {
      String url = "https://www.google.com/maps/dir/?api=1&origin=" +
          origin +
          "&destination=" +
          destination +
          "&travelmode=walking&dir_action=navigate";
      if (canLaunch(url) != null) {
        launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
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
