import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [
    // Todo('Eat dinner', TodoStatus.todo),
    // Todo('Cook breakfast', TodoStatus.todo),
    // Todo('Halka jogging', TodoStatus.todo),
    // Todo('Goru kena', TodoStatus.todo),
  ];

  int _selectedProjectIndex = 0;
  double _minProject = 0.0;
  double _maxProject = 5.0;

  String getSelectedProjectIndexLabel() {
    if (_selectedProjectIndex == 0) {
      return 'zero';
    } else {
      return 'non-zero';
    }
  }

  double get minProjectIndex => _minProject;

  double get maxProjectIndex => _maxProject;

  void changeTodoSTatus(Todo todo, TodoStatus status) {
    _todos.firstWhere((element) => element.title == todo.title).status = status;
    notifyListeners();
  }

  void addNewTodo(Todo todo) {
    _todos.insert(0, todo);
    notifyListeners();
  }

  void setSelectedProjectIndex(int index) {
    _selectedProjectIndex = index;
    notifyListeners();
  }

  int get projectIndex => _selectedProjectIndex;

  List<Todo> get todos =>
      _todos.where((element) => element.status == TodoStatus.todo).toList();

  List<Todo> get ongoingTodos =>
      _todos.where((element) => element.status == TodoStatus.onGoing).toList();

  List<Todo> get finishedTodos =>
      _todos.where((element) => element.status == TodoStatus.finished).toList();
}
