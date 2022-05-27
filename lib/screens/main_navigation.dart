import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/providers/todo_provider.dart';
import 'package:second_attempt/screens/projects_list_screen/projects_screen.dart';
import 'package:second_attempt/screens/projects_tab_screen/projects_tab_screen.dart';
import 'package:second_attempt/screens/timeline_screen/timeline_screen.dart';
import 'package:second_attempt/screens/tutorial/tutorial.dart';
import 'auth_screen/signup.dart';
import 'package:second_attempt/services/authentication.dart';
import 'dashboard_screen/dashboard_screen.dart';

import 'auth_screen/login.dart';

class AppNavigationBar extends StatefulWidget {
  @override
  AppNavigationStateBar createState() => AppNavigationStateBar();
}

class AppNavigationStateBar extends State<AppNavigationBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    ProjectsTab(),
    Projects(),
    // Dashboard(),
    // Consumer<TodoProvider>(
    //   builder: (context, todoProvider, _) => ProjectTimeline(
    //     todoProvider: todoProvider,
    //   ),
    // ),
    TimelineScreen(),
  ];
  final List<String> titleList = [
    "Todo dodo",
    "Projects",
    // "Dashboard",
    "Timeline"
  ];
  String currentTitle;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      currentTitle = titleList[_selectedIndex];
    });
  }

  @override
  void initState() {
    currentTitle = titleList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(currentTitle)),
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
              // BottomNavigationBarItem(
              //   icon: SizedBox(
              //       width: 10, height: 10, child: Icon(Icons.dashboard)),
              //   label: 'D',
              // ),
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
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              'assets/images/drawer_header_bg.jpg'))),
                  child: Stack(children: <Widget>[
                    Positioned(
                        bottom: 12.0,
                        left: 16.0,
                        child: Text(
                            FirebaseAuth.instance.currentUser.displayName !=
                                    null
                                ? FirebaseAuth.instance.currentUser.displayName
                                : 'Todo dodo',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500))),
                  ])),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.logout),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Logout',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  signoutUser();
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.help),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Tutorial',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Tutorial()));
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.bug_report),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Report an issue',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  signoutUser();
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.info),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'About',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  signoutUser();
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.rate_review),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Rate the app',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  signoutUser();
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.contact_mail),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Contact',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
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
