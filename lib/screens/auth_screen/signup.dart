import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:second_attempt/services/authentication.dart';

class Signup extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Sample App'),
        // ),
        key: _scaffoldKey,
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Rapid Todo',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.fromLTRB(45, 5, 45, 5),
                    child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Sign up'),
                        onPressed: () {
                          submitSignUp();
                        })),
                Container(
                  padding: EdgeInsets.fromLTRB(46, 0, 46, 0),
                  child: SignInButton(
                    Buttons.Google,
                    onPressed: () {
                      googleSignIn();
                    },
                  ),
                ),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('Already have an account?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )));
  }

  void submitSignUp() async {
    print('Hu');
    String uid = await emailSignup(
        emailController.text, passwordController.text, nameController.text);
    print('Signed User Id' + uid);
    if (uid == 'email-already-in-use') {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 18, color: Colors.red),
            children: <TextSpan>[
              // TextSpan(
              //   text: 'Due date of ',
              // ),
              TextSpan(
                text: 'An account with this email already exists. Try Sign-in.',
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blue[200],
      ));
    }
  }
}
