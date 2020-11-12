import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/authtab.dart';
import 'package:second_attempt/login.dart';
import 'package:second_attempt/navigation_bar.dart';
import 'package:second_attempt/providers/home_tab_provider.dart';
import 'package:second_attempt/providers/todo_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoProvider>(create: (_) => TodoProvider()),
        ChangeNotifierProvider<HomeTabProvider>(
            create: (_) => HomeTabProvider())
      ],
      child: MaterialApp(
        title: 'Awesome Todo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User user = snapshot.data;
                if (user == null) {
                  return AuthTab();
                }
                print("User is: " + user.uid);
                return
                    // MultiProvider(
                    // providers: [
                    //   ChangeNotifierProvider<TodoProvider>(
                    //       create: (_) => TodoProvider()),
                    //   ChangeNotifierProvider<HomeTabProvider>(
                    //       create: (_) => HomeTabProvider())
                    // ],
                    // child: MaterialApp(
                    //   title: 'Awesome Todo',
                    //   theme: ThemeData(
                    //     primarySwatch: Colors.blue,
                    //     visualDensity: VisualDensity.adaptivePlatformDensity,
                    //   ),
                    //   home: AppNavigationBar(),
                    // ),
                    // child:
                    AppNavigationBar();
                // );
              } else {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
      ),
    );

    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider<TodoProvider>(create: (_) => TodoProvider()),
    //     ChangeNotifierProvider<HomeTabProvider>(
    //         create: (_) => HomeTabProvider())
    //   ],
    //   child: MaterialApp(
    //     title: 'Awesome Todo',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //       visualDensity: VisualDensity.adaptivePlatformDensity,
    //     ),
    //     home: AppNavigationBar(),
    //   ),
    // );
  }
}
