import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:second_attempt/models/project_model.dart';

class HomeTabProvider extends ChangeNotifier {
  List<Project> _projects = [
    Project('Assignment', '01', Colors.red.value, 'sd'),
    Project('Cooking', '02', Colors.green.value, 'sd'),
  ];
  List<Project> get projects => _projects;

  Project getProject(String projectId) {
    return _projects.firstWhere((element) => element.id == projectId);
  }

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void removeProjects(Project project) {
    _projects.removeWhere((element) => element == project);
    notifyListeners();
  }

  List<Tab> _tabs = [
    Tab(icon: Icon(Icons.directions_car), text: 'car'),
    Tab(icon: Icon(Icons.directions_transit), text: 'transit'),
  ];
  List<Tab> get tabs => _tabs;
  void addTab(String name) {
    _tabs.add(Tab(icon: Icon(Icons.star_border_outlined), text: name));
    notifyListeners();
  }

  void removeTab(String name) {
    _tabs.removeWhere((element) => element.text == name);
    notifyListeners();
  }
}
