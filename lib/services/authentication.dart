import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth fireBaseAuth = FirebaseAuth.instance;
final googleSignin = GoogleSignIn();

googleSignIn() async {
  GoogleSignInAccount googleSignInAccount = await googleSignin.signIn();
  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    await fireBaseAuth.signInWithCredential(credential).then((user) => {
          print(fireBaseAuth.currentUser.uid),
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => AppNavigationBar())),
          // Navigator.pop(context)
        });
  }
}

emailSignup(String email, String password) async {
  try {
    await fireBaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) => {
              print(fireBaseAuth.currentUser.uid),
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) => AppNavigationBar())),
            });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

emailSignin(String email, String password) async {
  try {
    await fireBaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) => {print(fireBaseAuth.currentUser.uid)});
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

signoutUser() async {
  // try {} catch (e) {
  //   print(e.toString());
  // }
  User user = fireBaseAuth.currentUser;
  if (user.providerData.length > 1 &&
      user.providerData[1].providerId == 'google.com') {
    await googleSignin.disconnect();
  } else {
    await fireBaseAuth.signOut();
  }
}
