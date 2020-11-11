import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  // String _selectedProjectId;

  // String get selectedProjectId => _selectedProjectId;

  List<Todo> getTasksByLevel(TodoStatus status, String projectId) {
    List<Todo> tasks =
        _todos.where((element) => element.status == status).toList();
    if (projectId != 'all') {
      tasks = tasks.where((element) => element.projectId == projectId).toList();
    }
    return tasks;
  }

  // void selectProjectId(String id) {
  //   this._selectedProjectId = id;
  // }

  void changeTodoSTatus(Todo todo, TodoStatus status) {
    int index = _todos.indexWhere((element) => element.title == todo.title);
    _todos[index].status = status;
    if (status == TodoStatus.finished) {
      _todos[index].finishedAt = DateTime.now();
      print('Finished');
      print(_todos[index].finishedAt.toString());
    }
    notifyListeners();
  }

  void addNewTodo(Todo todo) {
    _todos.insert(0, todo);
    notifyListeners();
  }
}
