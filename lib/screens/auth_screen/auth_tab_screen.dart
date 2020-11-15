import 'package:flutter/material.dart';
import 'package:second_attempt/screens/auth_screen/signup.dart';

import 'login.dart';

class AuthTab extends StatefulWidget {
  @override
  _AuthTabState createState() => _AuthTabState();
}

class _AuthTabState extends State<AuthTab> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Login'),
                Tab(text: 'Sign up'),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              Login(),
              Signup(),
            ],
          ),
        ),
      ),
    );
  }
}
