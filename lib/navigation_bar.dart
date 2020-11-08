import 'package:flutter/material.dart';
import 'package:second_attempt/projects.dart';
import 'package:second_attempt/tabbed_home.dart';

class AppNavigationBar extends StatefulWidget {
  @override
  AppNavigationStateBar createState() => AppNavigationStateBar();
}

class AppNavigationStateBar extends State<AppNavigationBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    TabbedHome(),
    Projects(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Rapid Todo')),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: 40,
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SizedBox(width: 10, height: 10, child: Icon(Icons.home)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:
                  SizedBox(width: 10, height: 10, child: Icon(Icons.business)),
              label: 'Projects',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
