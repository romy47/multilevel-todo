import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:second_attempt/helpers/notification-helper.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/services/database_service.dart';

class TodoHelper {
  static List<Todo> getTasksByLevel(
      List<Todo> tasks, TodoStatus status, String projectId) {
    List<Todo> res =
        tasks.where((element) => element.status == status.value).toList();
    if (projectId != 'all') {
      res = res.where((element) => element.projectId == projectId).toList();
    }
    return res;
  }

  static List<Todo> getTasksWithProjectByLevel(List<Project> projects,
      List<Todo> tasks, TodoStatus status, String projectId) {
    print(status);
    List<Todo> res = [];
    if (status == TodoStatus.todo) {
      res = tasks
          .where((element) =>
              element.status != TodoStatus.finished.value &&
              TodoHelper.isItToday(element.due) == false)
          .toList();
    } else if (status == TodoStatus.onGoing) {
      res = tasks
          .where((element) =>
              element.status != TodoStatus.finished.value &&
              TodoHelper.isItToday(element.due))
          .toList();
    } else if (status == TodoStatus.finished) {
      res = tasks.where((element) => element.status == status.value).toList();
    }

    if (projectId != 'all') {
      res = res.where((element) => element.projectId == projectId).toList();
    }
    if (status != TodoStatus.finished) {
      print('Not finished');
      res.forEach((task) {
        Project proj = TodoHelper.getProjectfromTodo(projects, task);
        task.projectTitle = proj.title;
        task.projectColor = proj.color;
      });
    } else {
      print('finished');
    }

    return res;
  }

  static List<bool> getEmptRepeat() {
    return [false, false, false, false, false, false, false];
  }

  static Project getProjectfromTodo(List<Project> projects, Todo todo) {
    Project res =
        projects.firstWhere((element) => element.id == todo.projectId);
    if (res == null) {
      res = projects[0];
      res.title = 'Unknown';
      // res.color = Color,
    }
    return res;
  }

  static CircleAvatar getCircularAvatarFromTodo(Todo todo) {
    Color cl = new Color(todo.projectColor);
    Icon ic = Icon(Icons.navigate_next);
    DateTime today = DateTime.now();
    if (todo.status == TodoStatus.finished.value) {
      ic = Icon(Icons.done);
      cl = Colors.grey[600];
    } else {
      if (TodoHelper.isOverDue(todo.due)) {
        ic = Icon(Icons.priority_high);
        cl = Colors.red[300];
      } else if (TodoHelper.isItToday(todo.due)) {
        ic = Icon(Icons.play_arrow);
        cl = Colors.amber[300];
      } else {
        ic = Icon(Icons.radio_button_unchecked);
        cl = Colors.green[300];
      }
    }

    return CircleAvatar(
      backgroundColor: cl,
      child: new IconTheme(
        data: new IconThemeData(color: Colors.white),
        child: ic,
      ),
    );
  }

  static bool isSameDay(DateTime past, DateTime future) {
    return past.year == future.year &&
        past.month == future.month &&
        past.day == future.day;
  }

  static bool isItToday(DateTime day) {
    DateTime now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  static bool isOverDue(DateTime due) {
    bool res = true;
    DateTime now = DateTime.now();
    if (now.year > due.year) {
      res = true;
    } else if (now.year < due.year) {
      res = false;
    } else {
      if (now.month > due.month) {
        res = true;
      } else if (now.month < due.month) {
        res = false;
      } else {
        if (now.day > due.day) {
          res = true;
        } else if (now.day < due.day) {
          res = false;
        } else {
          res = false;
        }
      }
    }
    return res;
  }

  static int getDifferenceInDaysFromToday(DateTime date) {
    DateTime today = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return date.difference(today).inDays;
  }

  static int getBonusTaskCount(List<Todo> todos) {
    int count = 0;
    print('Test getBonusTaskCount-1: ' + todos.length.toString());
    todos.forEach((todo) {
      if (todo.status == TodoStatus.finished.value &&
          !TodoHelper.isSameDay(todo.due, todo.finishedAt)) {
        count++;
      }
    });
    return count;
  }

  static List<DateTime> getLastSevenDays() {
    DateTime to = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    to = to.add(Duration(days: 1));
    DateTime from = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    from = from.subtract(Duration(days: 6));
    final daysToGenerate = to.difference(from).inDays;
    from = from.subtract(Duration(days: 1));

    return List.generate(
        daysToGenerate, (i) => from = from.add(Duration(days: 1)));
  }

  static getNotific() async {
    print('ALARM');
    await Firebase.initializeApp();

    FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

    // final now = DateTime.now();
    // DateTime today = DateTime(now.year, now.month, now.day);
    // DateTime to = today.add(Duration(days: 1));
    // DateTime from = today.subtract(Duration(days: 7));
    // print('ALARM   2');
    // final _finishedTodoRef = _fireStoreDataBase
    //     .collection('todos')
    //     .doc(FirebaseAuth.instance.currentUser.uid)
    //     .collection('todo')
    //     .where('status', isEqualTo: TodoStatus.finished.value)
    //     .where('finishedAt', isGreaterThanOrEqualTo: from)
    //     .where('finishedAt', isLessThanOrEqualTo: to)
    //     .orderBy('finishedAt', descending: false)
    //     .limit(50);
    // _finishedTodoRef.get().then((re) {
    //   print('LALA LALA ------>');

    //   List<Todo> todos = re.docs.map((doc) {
    //     return Todo.fromJson(doc.data());
    //   }).toList();

    //   print('LALA LALA ------>' + todos.length.toString());
    // });

    // DatabaseServices(FirebaseAuth.instance.currentUser.uid)
    //     .getFinishedTodoListLast7(50)
    //     .then((re) {
    //   print('LALA LALA ------>');

    //   List<Todo> todos = re.docs.map((doc) {
    //     return Todo.fromJson(doc.data());
    //   }).toList();

    //   print('LALA LALA ------>' + todos.length.toString());
    // });
    DatabaseServices(FirebaseAuth.instance.currentUser.uid)
        .getUserTodoListSnapshot()
        .then((re) {
      // print('LALA LALA ------>');

      List<Todo> todos = re.docs.map((doc) {
        return Todo.fromJson(doc.data());
      }).toList();

      List<Todo> nonRepeatTodos = todos
          .where((td) =>
              (td.isRepeat == true && TodoHelper.isOverDue(td.due)) == false)
          .toList();
      List<Todo> repeatTodos = todos
          .where((td) => td.isRepeat == true && TodoHelper.isOverDue(td.due))
          .toList();

      List<String> _weekDays = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ];
      repeatTodos.forEach((td) {
        List<DateTime> days = [];
        DateTime from = new DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        from = from.subtract(Duration(days: 1));
        days = List.generate(7, (i) => from = from.add(Duration(days: 1)));
        for (DateTime day in days) {
          int indx =
              _weekDays.indexWhere((wd) => wd == DateFormat('EEE').format(day));
          if (td.weekDays[indx] == true) {
            td.due = day;
            break;
          }
        }
      });
      List<Todo> dueToday = [];
      nonRepeatTodos.forEach((td) {
        if (TodoHelper.isItToday(td.due)) {
          print('non rep ------>' + td.title);
          dueToday.add(td);
        }
      });
      repeatTodos.forEach((td) {
        if (TodoHelper.isItToday(td.due)) {
          print('rep ------>' + td.title);
          dueToday.add(td);
        }
      });
      print('Due Today ------>' + dueToday.length.toString());
      NotificationHelper().showNotificationBtweenInterval(
          'Tasks are waiting to be done!!',
          'Hey, you have ' +
              dueToday.length.toString() +
              ' tasks due today including ' +
              '"' +
              dueToday[0].title +
              '"');
    });
  }
}
