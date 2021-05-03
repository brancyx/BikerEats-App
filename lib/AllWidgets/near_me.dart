import 'package:bikereats/AllControllers/routeManager.dart';
import 'package:bikereats/AllModels/address.dart';
import 'package:bikereats/DataHandler/appData.dart';
import 'package:bikereats/DataHandler/foodData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

/// shows food places near the user
class NearMeWidget extends StatefulWidget {
  @override
  _NearMeWidgetState createState() => _NearMeWidgetState();
}

class _NearMeWidgetState extends State<NearMeWidget> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  Address currentAddress = Address();


  List<Widget> storeData = [];
  // List<dynamic> foodData = [];

  /// Getting list of food data from database to be displayed
  void getFoodData() async {
    
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentAddress.latitude = position.latitude;
    currentAddress.longitude = position.longitude;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation ?? currentAddress;
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);
    
    List<dynamic> responseList = foodData; //await RouteManager.obtainFoodPlaces(dropOffLatLng);
    print(responseList.length.toString());
    List<Widget> listStores = [];
    responseList.forEach((post) async {
      listStores.add(Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: <Widget>[
                // Image.network(
                //   post["icon"],
                Image.asset(
                  post["image"],
                  height: 70.0,
                  width: 70.0,
                ),
                SizedBox(width: 15.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        width: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              post["name"],
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Ratings: " + post["rating"].toString(),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.grey),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Price Range: "+post["priceRange"], //.toString(),
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ))
                  ],
                ),
                SizedBox(width: 5.0),
              ],
            ),
          )));
    });
    setState(() {
      storeData = listStores;
      foodData = responseList;
    });
  }

  @override
  void initState() {
    super.initState();
    getFoodData();
    controller.addListener(() {
      getFoodData();
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Display content in expandable group
  Widget _buildItems(BuildContext context, int index) {
    return Card(
        child: ExpansionTile(title: storeData[index], children: <Widget>[
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Address: "+foodData[index]["location"],
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Opening Hours: "+foodData[index]["openingHours"],//["open_now"].toString(),
                    // "Open Now: "+foodData[index]["opening_hours"]["open_now"].toString() ?? "Nope",
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Service type: "+foodData[index]["serviceType"], //[0],
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 8),
                ],
              ),
            )
          ])
    ]));
  }

  int value = 1;

  /// Display content on slide up panel
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Container(
            child: Column(children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Text("   Sort By: Nearest to Furthest",
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ]),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: ListView.builder(
                controller: controller,
                itemCount: storeData.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildItems(context, index);
                },
              )),
            ]),
          ),
        ),
      ),
    );
  }
}
