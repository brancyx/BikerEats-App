import 'package:bikereats/AllScreens/cycleScreen.dart';
import 'package:bikereats/AllScreens/registrationScreen.dart';
import 'package:bikereats/AllScreens/forgotpasswordScreen.dart';
import 'package:bikereats/AllWidgets/progressDialog.dart';
import 'package:bikereats/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:bikereats/AllControllers/profileManager.dart';

/// UI for login screen
class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
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
                      RaisedButton(
                        color: Colors.white,
                        textColor: Colors.green,
                        child: Container(
                            height: 50.0,
                            child: Center(
                                child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 18.0, fontFamily: "Brand Bold"),
                            ))),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0),
                        ),
                        onPressed: () {
                          if (!emailTextEditingController.text.contains("@")) {
                            profileManager.displayToastMessage(
                                "Email not valid", context);
                          } else if (passwordTextEditingController
                              .text.isEmpty) {
                            profileManager.displayToastMessage(
                                "Password is mandatory", context);
                          } else {
                            loginAndAuthenticateUser(context);
                          }
                        },
                      )
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationScreen.idScreen, (route) => false);
                  },
                  child: Text("Don't have an Account? Register Here."),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, ForgotPassword.id, (route) => false);
                  },
                  child: Text(
                    'Forgot Password? Click here',
                    /*style: TextStyle(color: Colors.grey, fontSize: 12),*/
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Authenticating, Please wait...");
        });

    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      profileManager.displayToastMessage(
          "Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, CycleScreen.idScreen, (route) => false);
          profileManager.displayToastMessage("You are logged in.", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          profileManager.displayToastMessage(
              "No records exists or this user. Please create new account",
              context);
        }
      });
    } else {
      Navigator.pop(context);
      profileManager.displayToastMessage("Error occurred", context);
    }
  }
}
