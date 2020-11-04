import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class HomeTabProvider extends ChangeNotifier {
  List<Tab> _tabs = [
    Tab(icon: Icon(Icons.directions_car), text: 'car'),
    Tab(icon: Icon(Icons.directions_transit), text: 'transit'),
    // Tab(icon: Icon(Icons.directions_bike), text: 'bike'),
  ];

  // TabController _tc;

  List<Tab> get tabs => _tabs;
  // TabController get tabController => _tc;

  HomeTabProvider() {
    // makeNewTabController();
  }

  // void makeNewTabController() {
  //   _tc = TabController(
  //     length: _tabs.length,
  //     initialIndex: _tabs.length - 1,
  //   );
  // }

  void addTab(String name) {
    _tabs.add(Tab(icon: Icon(Icons.star_border_outlined), text: name));
    // makeNewTabController();
    notifyListeners();
  }

  void removeTab(String name) {
    _tabs.removeWhere((element) => element.text == name);
    // makeNewTabController();
    notifyListeners();
  }
}
