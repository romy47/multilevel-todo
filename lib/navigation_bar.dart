import 'package:flutter/material.dart';
import 'package:second_attempt/dashboard.dart';
import 'package:second_attempt/projects.dart';
import 'package:second_attempt/services/authentication.dart';
import 'package:second_attempt/signup.dart';
import 'package:second_attempt/tabbed_home.dart';
import 'package:second_attempt/timeline.dart';

import 'login.dart';

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
    Dasjboard(),
    ProjectTimeline()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Rapid Todo')),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: SizedBox(
          height: 40,
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SizedBox(width: 10, height: 10, child: Icon(Icons.home)),
                label: 'H',
              ),
              BottomNavigationBarItem(
                icon: SizedBox(width: 10, height: 10, child: Icon(Icons.list)),
                label: 'P',
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                    width: 10, height: 10, child: Icon(Icons.dashboard)),
                label: 'D',
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                    width: 10, height: 10, child: Icon(Icons.timeline)),
                label: 'H',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('User Name'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Login'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              ),
              ListTile(
                title: Text('Sign up'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
              ),
              ListTile(
                title: Text('Log out'),
                onTap: () {
                  Navigator.pop(context);
                  signoutUser();
                },
              ),
            ],
          ),
        ));
  }
}
