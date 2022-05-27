import 'package:flutter/material.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';

class TutorialHelper {
  static List<Project> getProjects() {
    return [
      // Project('All', 'all', Colors.black.value, 'all'),
      Project('Exercise', '1', Colors.pink.value, '2'),
      Project('School', '2', Colors.green.value, '3'),
    ];
  }

  static List<Todo> getTodos() {
    return [
      new Todo(
          '1',
          TutorialHelper.getProjects()[0].id,
          'Finish Homework',
          TutorialHelper.getProjects()[0].title,
          TutorialHelper.getProjects()[0].color,
          TodoStatus.todo.value,
          new DateTime.now(),
          0,
          false,
          [],
          new DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
          new DateTime(
            DateTime.now().year + 100,
            DateTime.now().month,
            DateTime.now().day,
          )),
      Todo(
          '2',
          TutorialHelper.getProjects()[0].id,
          'Cycle Ride',
          TutorialHelper.getProjects()[0].title,
          TutorialHelper.getProjects()[0].color,
          TodoStatus.todo.value,
          new DateTime.now(),
          0,
          false,
          [],
          new DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
          new DateTime(
            DateTime.now().year + 100,
            DateTime.now().month,
            DateTime.now().day,
          )),
    ];
  }
}
