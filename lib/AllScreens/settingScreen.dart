import 'package:bikereats/AllScreens/loginScreen.dart';
import 'package:bikereats/AllScreens/changepasswordScreen.dart';
import 'package:bikereats/AllScreens/changeemailScreen.dart';
import 'package:bikereats/AllScreens/changenameScreen.dart';
import 'package:bikereats/DataHandler/appData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:bikereats/AllControllers/profileManager.dart';

/// UI allows user to change name, email, password or logout
class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  static String email;

  void getCurrentUserEmail() {
    setState(() {
      email = _firebaseAuth.currentUser.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Settings")),
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10.0),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.person_outline,
                          color: Colors.green,
                        ),
                        title: Text("Change Name"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNameScreen()),
                          );
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(
                          Icons.mail_outline,
                          color: Colors.green,
                        ),
                        title: Text("Change Email Address"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeEmailScreen()),
                          );
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(
                          Icons.lock_outline,
                          color: Colors.green,
                        ),
                        title: Text("Change Password"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen()),
                          );
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.green,
                        ),
                        title: Text("Logout"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Provider.of<AppData>(context, listen: false)
                              .pickUpLocation = null;
                          Provider.of<AppData>(context, listen: false)
                              .dropOffLocation = null;
                          Provider.of<AppData>(context, listen: false)
                              .currentRoute = null;
                          profileManager.signOut().then((res) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginScreen()),
                                (route) => false);
                            /* ModalRoute.withName('/')); */
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.white,
    );
  }
}
