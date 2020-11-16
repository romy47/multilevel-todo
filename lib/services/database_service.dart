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

  //retrieve todos
  Stream<List<Todo>> getUserTodoList() {
    return _fireStoreDataBase
        .collection('todos')
        .doc(this.uid)
        .collection('todo')
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
    if (status == TodoStatus.finished) {
      todo.finishedAt = DateTime.now();
    }
    todo.status = status.value;
    ref.update(todo.toJson()).then((value) => {});

    // int index = _todos.indexWhere((element) => element.title == todo.title);
    // _todos[index].status = status.value;
    // if (status == TodoStatus.finished) {
    //   _todos[index].finishedAt = DateTime.now();
    //   print('Finished');
    //   print(_todos[index].finishedAt.toString());
    // }
    // notifyListeners();
  }
}
