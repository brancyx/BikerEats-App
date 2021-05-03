import 'package:bikereats/AllScreens/cycleScreen.dart';
import 'package:bikereats/AllScreens/loginScreen.dart';
import 'package:bikereats/AllScreens/registrationScreen.dart';
import 'package:bikereats/AllScreens/forgotpasswordScreen.dart';
import 'package:bikereats/DataHandler/appData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Start up the BikerEats App [MyApp]
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");

/// The app starts on [LoginScreen] by default.
///
/// Other screens the user can navigate to include
/// [RegistrationScreen] and [CycleScreen].
class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'BikerEats Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: LoginScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          CycleScreen.idScreen: (context) => CycleScreen(),
          ForgotPassword.id: (context) => ForgotPassword(),
        },
        home: RegistrationScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
