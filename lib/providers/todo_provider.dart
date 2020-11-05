import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [
    // Todo('Eat dinner', TodoStatus.todo),
    // Todo('Cook breakfast', TodoStatus.todo),
    // Todo('Halka jogging', TodoStatus.todo),
    // Todo('Goru kena', TodoStatus.todo),
  ];
  String _selectedProjectId;

  String get selectedProjectId => _selectedProjectId;

  List<Todo> getTasksByLevel(TodoStatus status, String projectId) {
    List<Todo> tasks =
        _todos.where((element) => element.status == status).toList();
    if (projectId != null) {
      tasks = tasks.where((element) => element.projectId == projectId).toList();
    }
    return tasks;
  }

  void selectProjectId(String id) {
    this._selectedProjectId = id;
  }

  void changeTodoSTatus(Todo todo, TodoStatus status) {
    _todos.firstWhere((element) => element.title == todo.title).status = status;
    notifyListeners();
  }

  void addNewTodo(Todo todo) {
    _todos.insert(0, todo);
    notifyListeners();
  }
}
