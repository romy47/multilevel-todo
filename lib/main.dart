import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/providers/home_tab_provider.dart';
import 'package:second_attempt/providers/todo_provider.dart';
import 'package:second_attempt/tabbed_home.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        home: TabbedHomeScreen(),
      ),
    );
  }
}
