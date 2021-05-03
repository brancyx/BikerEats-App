import 'package:bikereats/AllScreens/profileScreen.dart';
import 'package:bikereats/AllControllers/profileManager.dart';
import 'package:bikereats/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Ui for allowing user to change name
class ChangeNameScreen extends StatefulWidget {
  @override
  _ChangeNameScreenState createState() => _ChangeNameScreenState();
}

class _ChangeNameScreenState extends State<ChangeNameScreen> {
  bool showPassword = false;
  TextEditingController nameTextEditingController =
      TextEditingController(text: MapScreenState.officialname);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Change Name")),
        body: new Container(
            color: Colors.white,
            child: new ListView(children: <Widget>[
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
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Name',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                          controller: nameTextEditingController,
                                          decoration: const InputDecoration()),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 75.0, right: 50.0, top: 50.0),
                                child: Container(
                                    child: new RaisedButton(
                                        onPressed: () async {
                                          String userId = await FirebaseAuth
                                              .instance.currentUser.uid;
                                          usersRef
                                              .child(userId)
                                              .child("name")
                                              .set(nameTextEditingController
                                                  .text
                                                  .trim()
                                                  .toString());
                                          setState(() {
                                            MapScreenState.officialname =
                                                nameTextEditingController.text
                                                    .trim()
                                                    .toString();
                                          });
                                          profileManager.displayToastMessage(
                                              "Name successfully changed",
                                              context);
                                          Navigator.pop(context);
                                        },
                                        color: Colors.green,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 100),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              fontSize: 15,
                                              letterSpacing: 2.2,
                                              color: Colors.white),
                                        ))))
                          ])))
            ])));
  }
}
