import 'dart:async';
import 'dart:io';
import 'package:bikereats/AllModels/history.dart';
import 'package:bikereats/AllScreens/settingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import 'package:bikereats/AllControllers/profileManager.dart';
import 'package:image_picker/image_picker.dart';

/// UI allows user to view their profile
class ProfileScreen extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

bool showPassword = false;

@override
class MapScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  static PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  final FocusNode myFocusNode = FocusNode();
  var stars = 0;

  List<History> _historyList;
  Query _historyQuery;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  StreamSubscription<Event> _onHistoryAddedSubscription;
  StreamSubscription<Event> _onHistoryChangedSubscription;

  @override
  void initState() {
    super.initState();

    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    _historyList = new List();
    _historyQuery = _database
        .reference()
        .child("users")
        .child(_firebaseAuth.currentUser.uid)
        .child("history");

    _onHistoryAddedSubscription =
        _historyQuery.onChildAdded.listen(onEntryAdded);
    _onHistoryChangedSubscription =
        _historyQuery.onChildChanged.listen(onEntryChanged);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    _onHistoryAddedSubscription.cancel();
    _onHistoryChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _historyList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _historyList[_historyList.indexOf(oldEntry)] =
          History.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _historyList.add(History.fromSnapshot(event.snapshot));
    });
  }

  static String officialname;

  TextEditingController nameTextEditingController =
      TextEditingController(text: officialname);
  TextEditingController passwordTextEditingController = TextEditingController();

  Widget showHistoryList() {
    if (_historyList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _historyList.length,
          itemBuilder: (BuildContext context, int index) {
            String startpoint = _historyList[index].startpoint;
            String endpoint = _historyList[index].endpoint;
            double ratings = _historyList[index].ratings;

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
                      SizedBox(width: 10.0),
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
                                SizedBox(height: 30.0),
                              ])),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              width: 200,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      startpoint,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 14.5,
                                    ),
                                    Text(
                                      endpoint,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 11.0,
                                    ),
                                  ])),
                          SizedBox(
                            child: StarRating(
                                rating: ratings,
                                starConfig: StarConfig(
                                    size: 30.0,
                                    fillColor: Colors.yellowAccent[700])),
                          ),
                        ],
                      ),
                    ])));
          });
    } else {
      return Center(
          child: Text(
        "Welcome. Your history is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    profileManager.getCurrentUserName();
    return new Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 7.0),
              child: Row(children: <Widget>[
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
                                        builder: (context) => SettingScreen()),
                                  )
                                },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(100.0)),
                            child: Column(children: <Widget>[
                              Icon(Icons.settings,
                                  size: 30.0, color: Colors.white),
                            ]))
                      ]))
                ])
              ]))
        ],
      ),
      body: new Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  height: 50.0,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: new Stack(fit: StackFit.loose, children: <Widget>[
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        imageProfile(),
                        // new Container(
                        //     width: 140.0,
                        //     height: 140.0,
                        //     decoration: new BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       image: new DecorationImage(
                        //         image: new ExactAssetImage('images/bran.jpg'),
                        //         fit: BoxFit.cover,
                        //       ),
                        //     )),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 90.0, right: 100.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        )),
                  ]),
                )
              ],
            ),
            //),
            new Container(
              color: Color(0xffFFFFFF),
              child: Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            left: 165.0, right: 25.0, top: 15.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  officialname,
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'History',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: showHistoryList(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        //],
      ),

      //)
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null
              ? AssetImage("images/profilepic.png")
              : FileImage(File(_imageFile.path)),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.black,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () async {
                // String userId = await FirebaseAuth.instance.currentUser.uid;
                // usersRef
                //     .child(userId)
                //     .child("profilepic")
                //     .set(FileImage(File(_imageFile.path)));
                // setState(() {
                //   MapScreenState._imageFile = 'bran.jpg';
                // });
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }
}
