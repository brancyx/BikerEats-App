import 'dart:async';
import 'package:bikereats/AllControllers/profileManager.dart';
import 'package:bikereats/AllModels/address.dart';
import 'package:bikereats/AllModels/favourite.dart';
import 'package:bikereats/DataHandler/appData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class favouriteScreen extends StatefulWidget {
  @override
  favouriteScreenState createState() => favouriteScreenState();
}

@override
class favouriteScreenState extends State<favouriteScreen>
    with SingleTickerProviderStateMixin {
  List<Favourites> _favouritesList;

  static bool favourited = true;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  StreamSubscription<Event> _onFavouritesAddedSubscription;
  StreamSubscription<Event> _onFavouritesChangedSubscription;

  Query _favouritesQuery;

  @override
  void initState() {
    super.initState();

    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    _favouritesList = new List();
    _favouritesQuery = _database
        .reference()
        .child("users")
        .child(_firebaseAuth.currentUser.uid)
        .child("favourites");
    _onFavouritesAddedSubscription =
        _favouritesQuery.onChildAdded.listen(onEntryAdded);
    _onFavouritesChangedSubscription =
        _favouritesQuery.onChildChanged.listen(onEntryChanged);
  }

  @override
  void dispose() {
    _onFavouritesAddedSubscription.cancel();
    _onFavouritesChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _favouritesList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _favouritesList[_favouritesList.indexOf(oldEntry)] =
          Favourites.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _favouritesList.add(Favourites.fromSnapshot(event.snapshot));
    });
  }

  deleteFavorited(String favouritesId, int index) {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    _database.reference()
      ..child("users")
          .child(_firebaseAuth.currentUser.uid)
          .child("favourites")
          .child(favouritesId)
          .remove()
          .then((_) {
        setState(() {
          _favouritesList.removeAt(index);
        });
      });
  }

  Widget showFavouritesList() {
    if (_favouritesList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _favouritesList.length,
          itemBuilder: (BuildContext context, int index) {
            Address startLoc = Address();
            Address endLoc = Address();

            String favouritesId = _favouritesList[index].key;
            String startpoint = _favouritesList[index].startpoint;
            double startlat = _favouritesList[index].startlat;
            double startlong = _favouritesList[index].startlong;
            String endpoint = _favouritesList[index].endpoint;
            double endlat = _favouritesList[index].endlat;
            double endlong = _favouritesList[index].endlong;

            startLoc.placeName = startpoint;
            startLoc.latitude = startlat;
            startLoc.longitude = startlong;
            endLoc.placeName = endpoint;
            endLoc.latitude = endlat;
            endLoc.longitude = endlong;

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
                    child: Row(children: <Widget>[
                      SizedBox(width: 20.0),
                      SizedBox(
                          width: 40.0,
                          child: Column(
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
                                SizedBox(height: 5.0),
                              ])),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              width: 180,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      startpoint,
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 13.5,
                                    ),
                                    Text(
                                      endpoint,
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  ])),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite,
                                size: 30.0, color: Colors.pink),
                            onPressed: () {
                              deleteFavorited(favouritesId, index);
                              setState(() {
                                profileManager.displayToastMessage(
                                    "Removed from Favourites!", context);
                                favourited = false;
                              });
                            },
                          ),
                          SizedBox(
                              width: 50,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ElevatedButton(
                                        onPressed: () {
                                          Provider.of<AppData>(context,
                                                  listen: false)
                                              .updatePickUpLocationAddress(
                                                  startLoc);
                                          Provider.of<AppData>(context,
                                                  listen: false)
                                              .updateDropOffLocationAddress(
                                                  endLoc);

                                          Navigator.pop(context);
                                          Navigator.pop(
                                              context, "obtainDirection");
                                        },
                                        child: Text("Go"))
                                  ]))
                        ],
                      ),
                    ])));
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Favourites'),
      ),
      body: showFavouritesList(),
    );
  }
}
