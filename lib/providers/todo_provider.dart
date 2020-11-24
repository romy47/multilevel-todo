import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:second_attempt/services/database_service.dart';
import '../models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  // Code for timeline begins ***********************

  final _finishedTodoSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 14;
  bool _hasNext = true;
  bool _isFetchingUsers = false;
  String get errorMessage => _errorMessage;
  bool get hasNext => _hasNext;

  List<Todo> get finishedTodos => _finishedTodoSnapshot.map((doc) {
        return Todo.fromJson(doc.data());
      }).toList();

  Future fetchNextTodos() async {
    if (_isFetchingUsers) return;

    _errorMessage = '';
    _isFetchingUsers = true;

    try {
      final snap =
          await new DatabaseServices(FirebaseAuth.instance.currentUser.uid)
              .getFinishedTodoList(
        documentLimit,
        startAfter: _finishedTodoSnapshot.isNotEmpty
            ? _finishedTodoSnapshot.last
            : null,
      );
      _finishedTodoSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingUsers = false;
  }

  // Code for timeline ends ***********************

  // Code for dashboard begins ***********************
  final _finishedTodoSnapshotLast7 = <DocumentSnapshot>[];
  String _errorMessageLast7 = '';
  bool _hasNextLast7 = true;
  bool _isFetchingLast7 = false;
  // int documentLimit = 14;

  String get errorMessageLast7 => _errorMessageLast7;
  bool get hasNextLast7 => _hasNextLast7;

  List<Todo> get finishedTodosLast7 => _finishedTodoSnapshotLast7.map((doc) {
        return Todo.fromJson(doc.data());
      }).toList();

  Future fetchNextTodosLast7() async {
    if (_isFetchingLast7) return;

    _errorMessageLast7 = '';
    _isFetchingLast7 = true;

    try {
      final snap =
          await new DatabaseServices(FirebaseAuth.instance.currentUser.uid)
              .getFinishedTodoListLast7(100
                  // ,
                  // startAfter: _finishedTodoSnapshot.isNotEmpty
                  //     ? _finishedTodoSnapshot.last
                  //     : null,
                  );
      _finishedTodoSnapshotLast7.addAll(snap.docs);

      if (snap.docs.length == 0) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessageLast7 = error.toString();
      notifyListeners();
    }

    _isFetchingLast7 = false;
  }
  // Code for dashboard ends ***********************

  List<Todo> _todos = [];
  List<Todo> getTasksByLevel(TodoStatus status, String projectId) {
    List<Todo> tasks =
        _todos.where((element) => element.status == status).toList();
    if (projectId != 'all') {
      tasks = tasks.where((element) => element.projectId == projectId).toList();
    }
    return tasks;
  }

  void changeTodoSTatus(Todo todo, TodoStatus status) {
    int index = _todos.indexWhere((element) => element.title == todo.title);
    _todos[index].status = status.value;
    if (status == TodoStatus.finished) {
      _todos[index].finishedAt = DateTime.now();
    }
    notifyListeners();
  }

  void addNewTodo(Todo todo) {
    _todos.insert(0, todo);
    notifyListeners();
  }
}
