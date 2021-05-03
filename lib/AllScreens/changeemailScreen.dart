import 'package:bikereats/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bikereats/AllControllers/profileManager.dart';

/// UI for allowing a user to change email
class ChangeEmailScreen extends StatefulWidget {
  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  bool showPassword = false;

  TextEditingController emailTextEditingController =
      TextEditingController(text: profileManager.getCurrentUserEmail());
  TextEditingController pwTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Change Email Address")),
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
                                          'Email Address',
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
                                        controller: emailTextEditingController,
                                        decoration: const InputDecoration(
                                      ),
                                    ),
                                    )],
                                )),
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
                                          'Enter password to confirm new email',
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
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        obscureText: true,
                                        controller: pwTextEditingController,
                                        decoration: const InputDecoration(
                                      ),
                                    ),
                                    )],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 75.0, right: 50.0, top: 50.0),
                                child: Container(
                                    child: new RaisedButton(
                                        onPressed: () async {
                                          if (await profileManager
                                                  .authenticatePW(
                                                      pwTextEditingController
                                                          .text
                                                          .trim()) ==
                                              true) {
                                            profileManager.updateEmail(
                                                emailTextEditingController.text
                                                    .trim());
                                            String userId = await FirebaseAuth
                                                .instance.currentUser.uid;
                                            usersRef
                                                .child(userId)
                                                .child("email")
                                                .set(emailTextEditingController
                                                    .text
                                                    .trim()
                                                    .toString());
                                            profileManager.displayToastMessage(
                                                "Email successfully changed",
                                                context);
                                            Navigator.pop(context);
                                          } else {
                                            profileManager.displayToastMessage(
                                                "Password is incorrect. Please try again",
                                                context);
                                          }
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
