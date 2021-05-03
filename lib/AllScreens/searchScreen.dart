import 'package:bikereats/AllWidgets/Divider.dart';
import 'package:bikereats/AllControllers/requestManager.dart';
import 'package:bikereats/DataHandler/appData.dart';
import 'package:bikereats/AllModels/address.dart';
import 'package:bikereats/AllModels/placePredictions.dart';
import 'package:bikereats/configMaps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// UI that allows user to input start and end locations of a cycling journey
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<TextEditingController> textControllerList = [];
  List<PlacePredictions> placePredictionList = [];
  String currControl;

  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    String dropAddress =
        Provider.of<AppData>(context).dropOffLocation?.placeName ?? "";
    textControllerList.add(pickUpTextEditingController);
    textControllerList.add(dropOffTextEditingController);

    return Scaffold(
        body: Column(children: [
      // return a column
      Container(
          // return a container at the top of the column
          height: 255.0,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 6.0,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            )
          ]),
          child: Padding(
              padding: EdgeInsets.only(
                  left: 25.0, top: 50.0, right: 25.0, bottom: 1.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Stack(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(
                            context); // pops the previous call from the top of stack and return back to cyclescreen
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    Center(
                      child: Text(
                        "Select Journey",
                        style:
                            TextStyle(fontSize: 18.0, fontFamily: "Brand-Bold"),
                      ),
                    )
                  ]),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Image.asset("images/starticon.png",
                          height: 26.0, width: 26.0),
                      SizedBox(width: 18.0),
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: TextField(
                                  onTap: () {
                                    setState(() {
                                      currControl = "pickup";
                                      pickUpTextEditingController.text = "";
                                    });
                                  },
                                  onChanged: (val) {
                                    findPlace(val);
                                    // return dropdown list of suggested places
                                  },
                                  controller: pickUpTextEditingController,
                                  decoration: InputDecoration(
                                    hintText: Provider.of<AppData>(context)
                                            .pickUpLocation
                                            ?.placeName ??
                                        "Start Location",
                                    fillColor: Colors.grey[400],
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                        left: 11.0, top: 8.0, bottom: 8.0),
                                  ),
                                ))),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Image.asset("images/endicon.png",
                          height: 26.0, width: 26.0),
                      SizedBox(width: 18.0),
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: TextField(
                                  onTap: () {
                                    setState(() {
                                      currControl = "dropoff";
                                      dropOffTextEditingController.text = "";
                                    });
                                  },
                                  onChanged: (val) async {
                                    findPlace(val);
                                  },
                                  controller: dropOffTextEditingController,
                                  decoration: InputDecoration(
                                    hintText: Provider.of<AppData>(context)
                                            .dropOffLocation
                                            ?.placeName ??
                                        "End Location",
                                    fillColor: Colors.grey[400],
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                        left: 11.0, top: 8.0, bottom: 8.0),
                                  ),
                                ))),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  ButtonTheme(
                    minWidth: 100,
                    height: 30,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (placeAddress != "" && dropAddress != null) {
                          Navigator.pop(context, "obtainDirection");
                        } else {
                          return;
                        }
                      },
                      label: Text('Search', style: TextStyle(fontSize: 15.0)),
                      icon: Icon(Icons.open_with),
                    ),
                  ),
                ],
              ))),

      //title for predictions
      (placePredictionList.length > 0) // if list of predicted locations > 0
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Container(
                child: ListView.separated(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index) {
                    return PredictionTile(
                      placePredictions: placePredictionList[index],
                      control: currControl,
                      textControllerList: textControllerList,
                    ); // return the stateless widget
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      DividerWidget(),
                  itemCount: placePredictionList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              ),
            )
          : Container(), // else just return a container
    ]));
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:sg";

      var res = await RequestManager.getRequest(autoCompleteUrl);

      if (res == "failed") {
        return;
      }

      if (res["status"] == 'OK') {
        var predictions = res["predictions"];

        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;
  final String control;
  final List<TextEditingController> textControllerList;

  PredictionTile(
      {Key key, this.placePredictions, this.control, this.textControllerList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        print(placePredictions.placeId);
        getPlaceAddressDetails(placePredictions.placeId, context);
      },
      child: Container(
          child: Column(
        children: [
          SizedBox(width: 10.0),
          Row(
            children: [
              Icon(Icons.add_location),
              SizedBox(
                width: 14.0,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placePredictions.mainText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        placePredictions.secondaryText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      )
                    ]),
              )
            ],
          ),
          SizedBox(width: 10.0),
        ],
      )),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var res = await RequestManager.getRequest(placeDetailsUrl);

    if (res == "failed") {
      return;
    }

    if (res["status"] == "OK") {
      Address address =
          Address(); // can add set and get methods so that this part can be more object oriented
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      print("This is Drop off location");
      print(address.placeName);
      if (control == "pickup") {
        Provider.of<AppData>(context, listen: false)
            .updatePickUpLocationAddress(address);
        textControllerList[0].text = address.placeName;
      } else if (control == "dropoff") {
        Provider.of<AppData>(context, listen: false)
            .updateDropOffLocationAddress(address);
        textControllerList[1].text = address.placeName;
      }
    }
  }
}
