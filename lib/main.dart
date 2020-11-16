import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/providers/home_tab_provider.dart';
import 'package:second_attempt/providers/todo_provider.dart';
import 'package:second_attempt/screens/auth_screen/auth_tab_screen.dart';
import 'package:second_attempt/screens/main_navigation.dart';
import 'package:second_attempt/services/database_service.dart';

import 'models/project_model.dart';
import 'models/todo_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        // MultiProvider(
        //   providers: [
        //     ChangeNotifierProvider<TodoProvider>(create: (_) => TodoProvider()),
        //     ChangeNotifierProvider<HomeTabProvider>(
        //         create: (_) => HomeTabProvider())
        //   ],
        //   child:
        MaterialApp(
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
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider<TodoProvider>(
                      create: (_) => TodoProvider()),
                  ChangeNotifierProvider<HomeTabProvider>(
                      create: (_) => HomeTabProvider()),
                  StreamProvider<List<Project>>.value(
                      value: new DatabaseServices(
                              FirebaseAuth.instance.currentUser.uid)
                          .getUserProjectList()),
                  StreamProvider<List<Todo>>.value(
                      value: new DatabaseServices(
                              FirebaseAuth.instance.currentUser.uid)
                          .getUserTodoList()),
                ],
                child: MaterialApp(
                  title: 'Awesome Todo',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  home: AppNavigationBar(),
                ),
                // child:
                // AppNavigationBar()
              );
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
    // );

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
