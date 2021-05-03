import 'package:bikereats/AllScreens/cycleScreen.dart';
import 'package:bikereats/AllScreens/exploreScreen.dart';
import 'package:bikereats/AllScreens/foodScreen.dart';
import 'package:flutter/material.dart';

/// For navigation on bottom navigation bar between [CycleScreen],
/// [ExploreScreen] and [FoodScreen]
class ScreenManager extends StatefulWidget {
  static const String idScreen = "mainScreen";
  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {

  // start with Cycle Screen upon login
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // set current index as 2
          fixedColor: Colors.white,
          backgroundColor: Colors.green,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank),
              label: 'Food',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bike),
              label: 'Cycle',
            ),
          ],
        onTap: (index) { // pass in the index/button that the user selects/taps
          setState(() {
            _selectedIndex = index; // when tapped, the index is updated
          });
        },
      ),
      body: Stack(
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
        ],
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) { // returns selected screen
    return {
      '/': (context) {
        return [
          FoodScreen(),
          ExploreScreen(),
          CycleScreen(),
        ].elementAt(index); // selects screen from a list of screens
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index); // store the selected screen

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}
