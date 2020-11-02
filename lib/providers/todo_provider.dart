import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [
    // Todo('Eat dinner', TodoStatus.todo),
    // Todo('Cook breakfast', TodoStatus.todo),
    // Todo('Halka jogging', TodoStatus.todo),
    // Todo('Goru kena', TodoStatus.todo),
  ];

  void changeTodoSTatus(Todo todo, TodoStatus status) {
    _todos.firstWhere((element) => element.title == todo.title).status = status;
    notifyListeners();
  }

  void addNewTodo(Todo todo) {
    _todos.insert(0, todo);
    notifyListeners();
  }

  List<Todo> get todos =>
      _todos.where((element) => element.status == TodoStatus.todo).toList();

  List<Todo> get ongoingTodos =>
      _todos.where((element) => element.status == TodoStatus.onGoing).toList();

  List<Todo> get finishedTodos =>
      _todos.where((element) => element.status == TodoStatus.finished).toList();
}
