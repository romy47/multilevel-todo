import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';

class DatabaseServices {
  final String uid;
  final FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  DatabaseServices(this.uid);

  //recieve Projects
  Stream<List<Project>> getUserProjectList() {
    return _fireStoreDataBase
        .collection('projects')
        .doc(this.uid)
        .collection('project')
        .snapshots()
        .map(((snapShot) =>
            snapShot.docs.map((doc) => Project.fromJson(doc.data())).toList()));
  }

  //save new project
  addProject(Project project) {
    DocumentReference ref = _fireStoreDataBase
        .collection('projects')
        .doc(uid)
        .collection('project')
        .doc();
    var addProjectData = Map<String, dynamic>();
    addProjectData['title'] = project.title;
    addProjectData['id'] = ref.id;
    addProjectData['color'] = project.color;
    addProjectData['uid'] = project.uid;
    return ref.set(addProjectData);
  }

  Stream<List<Todo>> getUserTodoList() {
    DateTime now = DateTime.now();
    return _fireStoreDataBase
        .collection('todos')
        .doc(this.uid)
        .collection('todo')
        .where('finishedAt',
            isGreaterThan: new DateTime(now.year, now.month, now.day))
        .snapshots()
        .map(((snapShot) =>
            snapShot.docs.map((doc) => Todo.fromJson(doc.data())).toList()));
  }

  //save new task
  addTodo(Todo todo) {
    DocumentReference ref = _fireStoreDataBase
        .collection('todos')
        .doc(uid)
        .collection('todo')
        .doc();
    var addTodoData = Map<String, dynamic>();
    addTodoData['id'] = ref.id;
    addTodoData['projectId'] = todo.projectId;
    addTodoData['title'] = todo.title;
    addTodoData['projectTitle'] = todo.projectTitle;
    addTodoData['projectColor'] = todo.projectColor;
    addTodoData['status'] = todo.status;
    addTodoData['due'] = todo.due;
    addTodoData['repeat'] = todo.repeat;
    addTodoData['createdAt'] = todo.createdAt;
    addTodoData['finishedAt'] = todo.finishedAt;
    return ref.set(addTodoData);
  }

  changeTodoSTatus(Todo todo, TodoStatus status) {
    DocumentReference ref = _fireStoreDataBase
        .collection('todos')
        .doc(uid)
        .collection('todo')
        .doc(todo.id);

    // Finishing a Todo
    if (status == TodoStatus.finished) {
      print('Finishing a Todo');
      todo.status = status.value;
      todo.finishedAt = DateTime.now();
      ref.update(todo.toJson()).then((value) => {});
    } else {
      if (todo.status == TodoStatus.finished.value) {
        // Rebirth of a Todo
        print('Rebirth of a Todo');
        if (status == TodoStatus.todo) {
          // Rebirth tommorrow
          print('Rebirth tommorrow');
          todo.createdAt = DateTime.now();
          todo.due = new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 1);
          todo.status = TodoStatus.todo.value;
          this.addTodo(todo);
        } else {
          // Rebirth today
          print('Rebirth today');
          todo.createdAt = DateTime.now();
          todo.due = DateTime.now();
          todo.status = TodoStatus.onGoing.value;
          this.addTodo(todo);
        }
      } else {
        // State changing of a Todo
        print('State changing of a Todo');
        if (status == TodoStatus.todo) {
          // State change to tommorrow
          print('State change to tommorrow');
          todo.due = new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 1);
          todo.status = TodoStatus.todo.value;
          ref.update(todo.toJson()).then((value) => {});
        } else {
          // State change to today
          print('State change to today');
          todo.due = new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day);
          todo.status = TodoStatus.onGoing.value;
          ref.update(todo.toJson()).then((value) => {});
        }
      }
    }
  }
}
