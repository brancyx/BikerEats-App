import 'dart:async';
import 'package:bikereats/AllModels/address.dart';
import 'package:bikereats/AllModels/trending.dart';
import 'package:bikereats/DataHandler/appData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:bikereats/AllScreens/profileScreen.dart';
import 'package:provider/provider.dart';
import 'favouriteScreen.dart';

/// UI to display suggested cycling routes for user to explore
class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: Container(
                alignment: Alignment.centerLeft,
                width: 170.0,
                child: Column(children: [
                  Text(
                    "Trending Routes",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  )
                ])),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 7.0),
                  child: Row(children: <Widget>[
                    Column(children: <Widget>[
                      SizedBox(
                          height: 48,
                          width: 84,
                          child: Column(children: <Widget>[
                            FlatButton(
                                onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                favouriteScreen()),
                                      )
                                    },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(100.0)),
                                child: Column(children: <Widget>[
                                  Icon(Icons.favorite,
                                      size: 30.0, color: Colors.white),
                                  Text("Favourites",
                                      style: TextStyle(
                                          fontSize: 11.0, color: Colors.white))
                                ]))
                          ]))
                    ]),
                    Column(children: <Widget>[
                      SizedBox(
                          height: 48,
                          width: 66,
                          child: Column(children: <Widget>[
                            FlatButton(
                                onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileScreen()),
                                      )
                                    },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(100.0)),
                                child: Column(children: <Widget>[
                                  Icon(Icons.person,
                                      size: 30.0, color: Colors.white),
                                  Text("Profile",
                                      style: TextStyle(
                                          fontSize: 10.0, color: Colors.white))
                                ]))
                          ]))
                    ])
                  ]))
            ],
          ),
        ),
        body: showTrendingList());
  }

  List<Trending> _trendingList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StreamSubscription<Event> _onFavouritesAddedSubscription;
  StreamSubscription<Event> _onFavouritesChangedSubscription;

  Query _trendingQuery;

  @override
  void initState() {
    super.initState();
    _trendingList = new List();
    _trendingQuery = _database.reference().child("trending");
    _onFavouritesAddedSubscription =
        _trendingQuery.onChildAdded.listen(onEntryAdded);
  }

  @override
  onEntryAdded(Event event) {
    setState(() {
      _trendingList.add(Trending.fromSnapshot(event.snapshot));
    });
  }

  Widget showTrendingList() {
    if (_trendingList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _trendingList.length,
          itemBuilder: (BuildContext context, int index) {
            Address startLoc = Address();
            Address endLoc = Address();
            String trendingId = _trendingList[index].key;
            String endPoint = _trendingList[index].endPoint;
            List endPointLatLng = _trendingList[index].endPointLatLng;
            String gmapsImage = _trendingList[index].gmapsImage;
            String ratingNo = _trendingList[index].ratingNo;
            String ratings = _trendingList[index].ratings;
            String startPoint = _trendingList[index].startPoint;
            List startPointLatLng = _trendingList[index].startPointLatLng;

            startLoc.placeName = startPoint;
            startLoc.latitude = startPointLatLng[0];
            startLoc.longitude = startPointLatLng[1];
            endLoc.placeName = endPoint;
            endLoc.latitude = endPointLatLng[0];
            endLoc.longitude = endPointLatLng[1];

            return Container(
                height: 120,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(100), blurRadius: 10.0),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        gmapsImage,
                        height: 100.0,
                        width: 80.0,
                      ),
                      SizedBox(width: 20.0),
                      SizedBox(
                          width: 25.0,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.location_pin,
                                    size: 20.0, color: Colors.blue),
                                Icon(Icons.stop_circle,
                                    size: 20.0, color: Colors.red),
                                SizedBox(height: 8.0),
                                Icon(Icons.star_rate,
                                    size: 20.0, color: Colors.yellow[300])
                              ])),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              width: 150,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      startPoint,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    Text(
                                      endPoint,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 14.0,
                                    ),
                                    Row(children: <Widget>[
                                      SizedBox(
                                          width: 30,
                                          child: Text(
                                            ratings,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      SizedBox(
                                          width: 80,
                                          child: Text(ratingNo,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey)))
                                    ])
                                  ])),
                        ],
                      ),
                      SizedBox(
                          width: 35,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              content: new Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    height: 500,
                                                    width: 300,
                                                    child: new Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Center(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .star_rate,
                                                                          size:
                                                                              40.0,
                                                                          color:
                                                                              Colors.yellow[300]),
                                                                      SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(
                                                                        ratings,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                25,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            0.0),
                                                                    child: Image
                                                                        .asset(
                                                                      gmapsImage,
                                                                      width:
                                                                          250.0,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          50),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .location_pin,
                                                                          size:
                                                                              30.0,
                                                                          color:
                                                                              Colors.blue),
                                                                      SizedBox(
                                                                          width:
                                                                              15),
                                                                      Text(
                                                                        startPoint,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.black),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          20),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .stop_circle,
                                                                          size:
                                                                              30.0,
                                                                          color:
                                                                              Colors.red),
                                                                      SizedBox(
                                                                          width:
                                                                              15),
                                                                      Text(
                                                                        endPoint,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.black),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          15),
                                                                  Row(
                                                                    children: [
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            if (startLoc.latitude ==
                                                                                null) {
                                                                              print("Latitude and Longitude not updated yet!!!!");
                                                                              Navigator.pop(context);
                                                                            } else {
                                                                              Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(startLoc);
                                                                              Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(endLoc);

                                                                              print("Bring user to cycleScreen()");
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context, "obtainDirection");
                                                                            }
                                                                          },
                                                                          child:
                                                                              Text("Go"))
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        },
                                    child: Icon(Icons.expand_more,
                                        size: 35.0, color: Colors.black))
                              ]))
                    ],
                  ),
                ));
          });
    } else {
      return Center(
          child: Text(
        "Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }
}
