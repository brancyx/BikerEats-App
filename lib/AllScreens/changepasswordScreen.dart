import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bikereats/AllControllers/profileManager.dart';

/// UI for allowing user to change password
class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool showPassword = false;
  bool _status = true;
  TextEditingController oldpwTextEditingController = TextEditingController();
  TextEditingController newpw1TextEditingController = TextEditingController();
  TextEditingController newpw2TextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Change Password")),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Old Password',
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
                                  controller: oldpwTextEditingController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      /* hintText: "Enter Your Name", */
                                      ),
                                  enabled: _status,
                                  autofocus: _status,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'New password',
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
                                  controller: newpw1TextEditingController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      ),
                                  enabled: _status,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Re-enter new password',
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
                                  controller: newpw2TextEditingController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      ),
                                  enabled: _status,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 75.0, right: 50.0, top: 50.0),
                          child: Container(
                              child: new RaisedButton(
                            onPressed: () async {
                              if (newpw1TextEditingController.text.trim() !=
                                  newpw2TextEditingController.text.trim()) {
                                profileManager.displayToastMessage(
                                    "New password does not match", context);
                              } else {
                                if (profileManager.isValidPassword(
                                        newpw1TextEditingController.text.trim(),
                                        context) ==
                                    true) {
                                  bool validator =
                                      await profileManager.changePassword(
                                          oldpwTextEditingController.text
                                              .trim(),
                                          newpw1TextEditingController.text
                                              .trim());
                                  if (validator == true) {
                                    profileManager.displayToastMessage(
                                        "Password successfully changed",
                                        context);
                                    Navigator.pop(context);
                                  } else {
                                    profileManager.displayToastMessage(
                                        "Old password is incorrect. Please re-enter old password",
                                        context);
                                  }
                                }
                              }
                            },
                            color: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          )))
                    ],
                  ),
                ),
              ),
            ])));
  }
}
