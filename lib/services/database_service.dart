import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/screens/projects_list_screen/edit_project_screen.dart';

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

  Future<QuerySnapshot> getFinishedTodoList(
    int limit, {
    DocumentSnapshot startAfter,
  }) {
    final _finishedTodoRef = _fireStoreDataBase
        .collection('todos')
        .doc(this.uid)
        .collection('todo')
        .where('status', isEqualTo: TodoStatus.finished.value)
        .orderBy('finishedAt', descending: true)
        .limit(limit);
    if (startAfter == null) {
      return _finishedTodoRef.get();
    } else {
      return _finishedTodoRef.startAfterDocument(startAfter).get();
    }
  }

  Future<QuerySnapshot> getFinishedTodoListLast7(int limit) {
    DateTime to = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    DateTime from = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 7);
    final _finishedTodoRef = _fireStoreDataBase
        .collection('todos')
        .doc(this.uid)
        .collection('todo')
        .where('status', isEqualTo: TodoStatus.finished.value)
        .where('finishedAt', isGreaterThanOrEqualTo: from)
        .where('finishedAt', isLessThanOrEqualTo: to)
        .orderBy('finishedAt', descending: false)
        .limit(limit);
    // if (startAfter == null) {
    return _finishedTodoRef.get();
    // } else {
    // return _finishedTodoRef.startAfterDocument(startAfter).get();
    // }
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
    addTodoData['due'] = todo.due.toUtc();
    addTodoData['repeat'] = todo.repeat;
    addTodoData['createdAt'] = todo.createdAt.toUtc();
    addTodoData['finishedAt'] = todo.finishedAt.toUtc();
    return ref.set(addTodoData);
  }

  deleteProject(String projectId) {
    CollectionReference ref = _fireStoreDataBase
        .collection('projects')
        .doc(uid)
        .collection('project');
    ref.doc(projectId).delete();

    final _batch = _fireStoreDataBase.batch();

    _fireStoreDataBase
        .collection('todos')
        .doc(this.uid)
        .collection('todo')
        .where('status', isNotEqualTo: TodoStatus.finished.value)
        .where('projectId', isEqualTo: projectId)
        .get()
        .then((qs) => {
              qs.docs.forEach((doc) {
                _batch.delete(doc.reference);
              }),
              _batch.commit()
            });
  }

  editProject(Project project) {
    DocumentReference ref = _fireStoreDataBase
        .collection('projects')
        .doc(uid)
        .collection('project')
        .doc(project.id);
    ref.update(project.toJson()).then((value) => {});
  }

  editTodo(Todo todo) {
    todo.createdAt.toUtc();
    todo.finishedAt.toUtc();
    todo.due.toUtc();
    DocumentReference ref = _fireStoreDataBase
        .collection('todos')
        .doc(uid)
        .collection('todo')
        .doc(todo.id);
    ref.update(todo.toJson()).then((value) => {});
  }

  deleteTodo(String todoId) {
    CollectionReference ref =
        _fireStoreDataBase.collection('todos').doc(uid).collection('todo');
    ref.doc(todoId).delete();
  }

  changeTodoSTatus(Todo todo, TodoStatus status) {
    DocumentReference ref = _fireStoreDataBase
        .collection('todos')
        .doc(uid)
        .collection('todo')
        .doc(todo.id);

    // Finishing a Todo
    if (status == TodoStatus.finished) {
      todo.status = status.value;

      todo.finishedAt = DateTime.now();
      ref.update(todo.toJson()).then((value) => {});
    } else {
      if (todo.status == TodoStatus.finished.value) {
        // Rebirth of a Todo
        if (status == TodoStatus.todo) {
          // Rebirth tommorrow
          todo.createdAt = DateTime.now();
          todo.due = new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 1);
          todo.status = TodoStatus.todo.value;
          this.addTodo(todo);
        } else {
          // Rebirth today
          todo.createdAt = DateTime.now();
          todo.due = DateTime.now();
          todo.status = TodoStatus.onGoing.value;
          this.addTodo(todo);
        }
      } else {
        // State changing of a Todo
        if (status == TodoStatus.todo) {
          if (todo.status == TodoStatus.todo.value) {
            //accidental todo  to todo

          } else {
            // State change to tommorrow
            todo.due = new DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 1);
            todo.status = TodoStatus.todo.value;
            ref.update(todo.toJson()).then((value) => {});
          }
        } else {
          // State change to today
          todo.due = new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day);
          todo.status = TodoStatus.onGoing.value;
          ref.update(todo.toJson()).then((value) => {});
        }
      }
    }
  }
}
