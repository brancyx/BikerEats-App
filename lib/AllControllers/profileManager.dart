import 'package:bikereats/AllScreens/profileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';


class profileManager {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<bool> authenticatePW(String password) async {
    try {
      User firebaseUser = await FirebaseAuth.instance.currentUser;
      String email = firebaseUser.email;
      UserCredential result = await firebaseUser.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: password));
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  static Future<void> updateEmail(String email) async {
    User user = await FirebaseAuth.instance.currentUser;
    user.updateEmail(email).then((_) {});
    return null;
  }

  static Future<bool> changePassword(
      String oldPassword, String newPassword) async {
    try {
      User firebaseUser = await FirebaseAuth.instance.currentUser;
      String email = firebaseUser.email;
      UserCredential result = await firebaseUser.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: oldPassword));
      await result.user.updatePassword(newPassword);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  static Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  /// Checks if password fulfils the requirement of having at least 8 characters,
  /// has special character, has number,  has uppercase and has lowercase.
  static bool isValidPassword(String password, BuildContext context) {
    int minLength = 8; // minimum length of valid password
    if (password.length < minLength ||
        !password.contains(new RegExp(r'[A-Z]')) ||
        !password.contains(new RegExp(r'[a-z]')) ||
        !password.contains(new RegExp(r'[0-9]')) ||
        !password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      profileManager.displayToastMessage(
          "Password must have at least 8 characters, one uppercase letter, one lowercase letter, one number and one symbol",
          context);
      // return -1;
      return false;
    } else {
      return true;
    }
  }

  static void getCurrentUserName() {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(_firebaseAuth.currentUser.uid)
        .child("name")
        .once()
        .then((DataSnapshot snapshot) {
      // setState(() {
      MapScreenState.officialname = snapshot.value.toString();
      // });
    });
  }

  static String getCurrentUserEmail() {
    User firebaseUser = FirebaseAuth.instance.currentUser;
    String email = firebaseUser.email;
    return email;
  }

  static displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
