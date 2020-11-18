import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';

class TodoHelper {
  static List<Todo> getTasksByLevel(
      List<Todo> tasks, TodoStatus status, String projectId) {
    print(tasks.length);
    List<Todo> res =
        tasks.where((element) => element.status == status.value).toList();
    if (projectId != 'all') {
      res = res.where((element) => element.projectId == projectId).toList();
    }
    return res;
  }

  static List<Todo> getTasksWithProjectByLevel(List<Project> projects,
      List<Todo> tasks, TodoStatus status, String projectId) {
    print(tasks.length);
    List<Todo> res = [];
    if (status == TodoStatus.todo) {
      res = tasks
          .where((element) =>
              element.status != TodoStatus.finished.value &&
              element.due.day != DateTime.now().day)
          .toList();
    } else if (status == TodoStatus.onGoing) {
      // res = [
      //   ...tasks
      //       .where((element) =>
      //           element.due.day == DateTime.now().day &&
      //           element.status != TodoStatus.finished.value)
      //       .toList(),
      //   ...res
      // ];
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
    res.forEach((task) {
      Project proj = TodoHelper.getProjectfromTodo(projects, task);
      task.projectTitle = proj.title;
      task.projectColor = proj.color;
    });
    return res;
  }

  // static List<Todo> getTasksWithProjectByLevel(List<Project> projects,
  //     List<Todo> tasks, TodoStatus status, String projectId) {
  //   print(tasks.length);
  //   List<Todo> res =
  //       tasks.where((element) => element.status == status.value).toList();
  //   if (status == TodoStatus.todo) {
  //     res = res
  //         .where((element) => element.due.day != DateTime.now().day)
  //         .toList();
  //   } else if (status == TodoStatus.onGoing) {
  //     res = [
  //       ...tasks
  //           .where((element) =>
  //               element.due.day == DateTime.now().day &&
  //               element.status != TodoStatus.finished.value)
  //           .toList(),
  //       ...res
  //     ];
  //   } else if (status == TodoStatus.finished) {}

  //   if (projectId != 'all') {
  //     res = res.where((element) => element.projectId == projectId).toList();
  //   }
  //   res.forEach((task) {
  //     Project proj = TodoHelper.getProjectfromTodo(projects, task);
  //     task.projectTitle = proj.title;
  //     task.projectColor = proj.color;
  //   });
  //   return res;
  // }

  static Project getProjectfromTodo(List<Project> projects, Todo todo) {
    Project res =
        projects.firstWhere((element) => element.id == todo.projectId);
    if (res == null) {
      res = projects[0];
    }
    return res;
  }
}
