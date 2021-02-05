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
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => AppNavigationBar())),
          // Navigator.pop(context)
        });
  }
}

Future<String> emailSignup(String email, String password, String name) async {
  // try {
  UserCredential currentUser = await fireBaseAuth
      .createUserWithEmailAndPassword(email: email, password: password);
  User firebaseUser = currentUser.user;
  await firebaseUser.updateProfile(displayName: name);
  await firebaseUser.reload();
  return firebaseUser.uid;
  // } on FirebaseAuthException catch (e) {
  //   if (e.code == 'weak-password') {
  //     print('The password provided is too weak.');
  //     return 'weak-password';
  //   } else if (e.code == 'email-already-in-use') {
  //     print('The account already exists for that email.');
  //     return 'email-already-in-use';
  //   }
  // } catch (e) {
  //   print(e);
  // }
}

Future<String> emailSignin(String email, String password) async {
  // try {
  return (await fireBaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
      .user
      .uid;
  // } on FirebaseAuthException catch (e) {
  //   if (e.code == 'user-not-found') {
  //     print('User Not Found.');
  //     return 'user-not-found';
  //   } else if (e.code == 'wrong-password') {
  //     print('wrong-password');
  //     return 'wrong-password';
  //   }
  // } catch (e) {
  //   print(e);
  // }
}

Future sendPasswordResetEmail(String email) async {
  // try {
  return await fireBaseAuth.sendPasswordResetEmail(email: email);
  // } on FirebaseAuthException catch (e) {
  //   if (e.code == 'user-not-found') {
  //     print('User Not Found.');
  //     return 'user-not-found';
  //   } else if (e.code == 'wrong-password') {
  //     print('wrong-password');
  //     return 'wrong-password';
  //   }
  // } catch (e) {
  //   print(e);
  // }
}

signoutUser() async {
  User user = fireBaseAuth.currentUser;
  if (user.providerData.length > 1 &&
      user.providerData[1].providerId == 'google.com') {
    await googleSignin.disconnect();
  } else {
    await fireBaseAuth.signOut();
  }
}
