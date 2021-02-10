import 'package:flutter/material.dart';
import 'package:second_attempt/models/project_model.dart';

class TutorialHelper {
  static List<Project> getProjects() {
    return [
      Project('All', 'all', Colors.black.value, '1'),
      Project('Exercise', '1', Colors.pink.value, '1'),
      Project('School', '2', Colors.green.value, '1'),
    ];
  }
}
