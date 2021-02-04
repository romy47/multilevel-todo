import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:second_attempt/services/authentication.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ForgotPasssword extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ForgotPasssword> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String error;

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
                      'Reset Password',
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
                // FlatButton(
                //   onPressed: () {
                //     resetPassword();
                //   },
                //   textColor: Colors.blue,
                //   child: Text('Forgot Password'),
                // ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(45, 5, 45, 5),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Reset Password'),
                      onPressed: () {
                        resetPassword();
                      },
                    )),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('Get back to'),
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

  void resetPassword() async {
    try {
      await sendPasswordResetEmail(nameController.text);
      Navigator.of(context)
          .pushReplacementNamed('/login', arguments: 'reset_password');
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
