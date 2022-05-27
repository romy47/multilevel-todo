import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:second_attempt/services/authentication.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Login extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String error;
// @protected
// @mustCallSuper
// void initState() {
//   super.initState();
// String s = ModalRoute.of(_scaffoldKey).settings.arguments;

// }

  @override
  Widget build(BuildContext context) {
    String arg = ModalRoute.of(context).settings.arguments;
    if (arg != null && arg == 'reset_password') {
      setState(() {
        error = 'A link to reset your password has been sent to your email';
      });
    }

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
                      'Todo dodo',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                showAlert(),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
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
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/reset');
                  },
                  textColor: Colors.blue,
                  child: Text('Forgot Password'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(45, 5, 45, 5),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () {
                        submitLogin();
                      },
                    )),
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
                    Text('Does not have account?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/signUp');
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )));
  }

  void submitLogin() async {
    try {
      String uid =
          await emailSignin(nameController.text, passwordController.text);
    } catch (e) {
      setState(() {
        error = e.message;
      });
    }

    // String errText = null;
    // if (uid == 'user-not-found') {
    //   errText = 'User not found';
    // } else if (uid == 'wrong-password') {
    //   errText = 'Wrong Password';
    // }
    // if (errText != null) {
    //   _scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: RichText(
    //       text: TextSpan(
    //         style: TextStyle(fontSize: 18, color: Colors.red),
    //         children: <TextSpan>[
    //           TextSpan(
    //             text: errText,
    //           ),
    //         ],
    //       ),
    //     ),
    //     backgroundColor: Colors.blue[200],
    //   ));
    // }
  }

  Widget showAlert() {
    if (error != null) {
      return Container(
        color: Colors.amber,
        width: double.infinity,
        // height: 50.0,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.error_outline)),
            Expanded(
              // height: 17.0,
              child: AutoSizeText(
                error,
                style: TextStyle(fontSize: 16.0),
                maxLines: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
