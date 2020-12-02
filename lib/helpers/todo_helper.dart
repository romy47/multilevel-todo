import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';

class TodoHelper {
  static List<Todo> getTasksByLevel(
      List<Todo> tasks, TodoStatus status, String projectId) {
    List<Todo> res =
        tasks.where((element) => element.status == status.value).toList();
    if (projectId != 'all') {
      res = res.where((element) => element.projectId == projectId).toList();
    }
    return res;
  }

  static List<Todo> getTasksWithProjectByLevel(List<Project> projects,
      List<Todo> tasks, TodoStatus status, String projectId) {
    print(status);
    List<Todo> res = [];
    if (status == TodoStatus.todo) {
      res = tasks
          .where((element) =>
              element.status != TodoStatus.finished.value &&
              element.due.day != DateTime.now().day)
          .toList();
    } else if (status == TodoStatus.onGoing) {
      res = tasks
          .where((element) =>
              element.status != TodoStatus.finished.value &&
              element.due.day == DateTime.now().day)
          .toList();
    } else if (status == TodoStatus.finished) {
      res = tasks.where((element) => element.status == status.value).toList();
    }

    if (projectId != 'all') {
      res = res.where((element) => element.projectId == projectId).toList();
    }
    if (status != TodoStatus.finished) {
      print('Not finished');
      res.forEach((task) {
        Project proj = TodoHelper.getProjectfromTodo(projects, task);
        task.projectTitle = proj.title;
        task.projectColor = proj.color;
      });
    } else {
      print('finished');
    }

    return res;
  }

  static Project getProjectfromTodo(List<Project> projects, Todo todo) {
    Project res =
        projects.firstWhere((element) => element.id == todo.projectId);
    if (res == null) {
      res = projects[0];
      res.title = 'Unknown';
      // res.color = Color,
    }
    return res;
  }

  static CircleAvatar getCircularAvatarFromTodo(Todo todo) {
    Color cl = new Color(todo.projectColor);
    Icon ic = Icon(Icons.navigate_next);
    DateTime today = DateTime.now();
    if (todo.status == TodoStatus.finished.value) {
      // if (todo.due.day == today.day) {
      ic = Icon(Icons.done);
      cl = Colors.grey[600];
      // }
    } else {
      if (todo.due.day < today.day) {
        ic = Icon(Icons.priority_high);
        cl = Colors.red[300];
      } else if (todo.due.day == today.day) {
        ic = Icon(Icons.play_arrow);
        cl = Colors.amber[300];
      } else {
        ic = Icon(Icons.radio_button_unchecked);
        cl = Colors.green[300];
      }
    }

    return CircleAvatar(
      backgroundColor: cl,
      child: new IconTheme(
        data: new IconThemeData(color: Colors.white),
        child: ic,
      ),
    );
  }
}
