import 'package:bikereats/AllScreens/cycleScreen.dart';
import 'package:bikereats/AllScreens/loginScreen.dart';
import 'package:bikereats/AllWidgets/progressDialog.dart';
import 'package:bikereats/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bikereats/AllControllers/profileManager.dart';

/// UI for registering new account
class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "register";

  Map userDataMap;
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 55.0),
                Image(
                  image: AssetImage("images/logo.png"),
                  width: 390.0,
                  height: 250.0,
                  alignment: Alignment.center,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 1.0,
                      ),
                      // Name Field
                      TextField(
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                            ),
                            labelText: "Name",
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            )),
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),

                      SizedBox(
                        height: 15.0,
                      ),
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                            ),
                            labelText: "Email",
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            )),
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),

                      SizedBox(
                        height: 15.0,
                      ),
                      // Password Field
                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                            ),
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            )),
                        style: TextStyle(fontSize: 20.0),
                      ),

                      SizedBox(
                        height: 20.0,
                      ),
                      // Register Button before pressing
                      RaisedButton(
                        color: Colors.white,
                        textColor: Colors.green,
                        child: Container(
                            height: 50.0,
                            child: Center(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 18.0, fontFamily: "Brand Bold"),
                                ))),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0),
                        ),
                        onPressed: () {
                          if (profileManager.isValidPassword(
                              passwordTextEditingController.text,
                              context) ==
                              true) {
                            registerNewUser(context);
                          }
                        },
                      )
                    ],
                  ),
                ),

                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  },
                  child: Text("Already have an Account? Login Here."),
                )
              ],
            ),
          ),
        ));
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Registering, Please wait...");
        });

    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text)
        .catchError((errMsg) {
      Navigator.pop(context);
      profileManager.displayToastMessage(
          "Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      // save user info to database
      userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        //"password": passwordTextEditingController.text.trim(),
        "profilepic": null
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      profileManager.displayToastMessage(
          "Congrats, your account has been created!", context);

      Navigator.pushNamedAndRemoveUntil(
          context, CycleScreen.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      profileManager.displayToastMessage(
          "New user has not been created", context);
    }
  }
}