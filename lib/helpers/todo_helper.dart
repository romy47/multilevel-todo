import 'package:second_attempt/models/todo_model.dart';

class TodoHelper {
  static List<Todo> getTasksByLevel(
      List<Todo> tasks, TodoStatus status, String projectId) {
    print(tasks.length);
    List<Todo> res =
        tasks.where((element) => element.status == status.value).toList();
    if (projectId != 'all') {
      res = tasks.where((element) => element.projectId == projectId).toList();
    }
    return res;
  }
}
