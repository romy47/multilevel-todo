import 'package:flutter/material.dart';
import 'package:second_attempt/screens/auth_screen/signup.dart';

import 'login.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      routes: <String, WidgetBuilder>{
        '/signUp': (BuildContext context) => Signup(),
        '/login': (BuildContext context) => Login(),
      },
    );
  }
}
