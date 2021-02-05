import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/helpers/todo_helper.dart';
import 'package:second_attempt/models/common.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/screens/edit_todo_screen/edit_todo_screen.dart';
import 'package:second_attempt/services/database_service.dart';

class ProjectTabContent extends StatefulWidget {
  final String projectId;
  final List<Project> projects;
  ProjectTabContent(this.projectId, this.projects) {}

  @override
  _ProjectTabContentState createState() => _ProjectTabContentState();
}

class _ProjectTabContentState extends State<ProjectTabContent> {
  bool onGoingHighlighted = false;
  bool todoHighlighted = false;
  bool finishedHighlighted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            // fit: FlexFit.tight,
            flex: 2,
            child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey),

                    // bottom: BorderSide(
                    //     color: onGoingHighlighted ? Colors.green : Colors.grey),
                    // top: BorderSide(
                    //     color: onGoingHighlighted ? Colors.green : Colors.grey),
                    // left: BorderSide(
                    //     color: onGoingHighlighted ? Colors.green : Colors.grey),
                    // right: BorderSide(
                    //     color: onGoingHighlighted ? Colors.green : Colors.grey),
                  ),
                  boxShadow: [
                    onGoingHighlighted
                        ? BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            spreadRadius: 10,
                            blurRadius: 7,
                            offset: Offset(6, 1), // changes position of shadow
                          )
                        : BoxShadow(
                            color: Colors.green.withOpacity(0),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                  ],
                ),
                width: double.maxFinite,
                child: DragTarget(onWillAccept: (data) {
                  setState(() {
                    onGoingHighlighted = true;
                  });
                  return true;
                }, onLeave: (data) {
                  setState(() {
                    onGoingHighlighted = false;
                  });
                  return true;
                }, onAccept: (data) {
                  if (TodoHelper.isItToday(data.due) == false) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Task ',
                            ),
                            TextSpan(
                              text: "' " + data.title + " '",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  // color: Colors.red[300]
                                  fontWeight: FontWeight.w900),
                            ),
                            TextSpan(
                              text: '  is due ',
                            ),
                            TextSpan(text: "Today"),
                          ],
                        ),
                      ),
                      backgroundColor: Colors.blue[500],
                    ));
                    setState(() {
                      onGoingHighlighted = false;
                    });
                    DatabaseServices(FirebaseAuth.instance.currentUser.uid)
                        .changeTodoSTatus(data, TodoStatus.onGoing);
                  }
                }, builder:
                    (BuildContext context, List<Todo> incoming, rejected) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Today's Goal",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      onGoing(context),
                    ],
                  );
                })),
          ),
          Expanded(
            // fit: FlexFit.tight,
            flex: 4,
            child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                  boxShadow: [
                    todoHighlighted
                        ? BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            spreadRadius: 10,
                            blurRadius: 7,
                            offset: Offset(6, 1), // changes position of shadow
                          )
                        : BoxShadow(
                            color: Colors.green.withOpacity(0),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                  ],
                ),
                width: double.maxFinite,
                child: DragTarget(onWillAccept: (data) {
                  setState(() {
                    todoHighlighted = true;
                  });
                  return true;
                }, onLeave: (data) {
                  setState(() {
                    todoHighlighted = false;
                  });
                  return true;
                }, onAccept: (data) {
                  setState(() {
                    todoHighlighted = false;
                  });
                  print('katukatu: ' + data.status.toString());
                  if (TodoHelper.isItToday(data.due) == true) {
                    Todo changedTodo =
                        DatabaseServices(FirebaseAuth.instance.currentUser.uid)
                            .changeTodoSTatus(data, TodoStatus.todo);
                    int days = TodoHelper.getDifferenceInDaysFromToday(
                        changedTodo.due);
                    print('katu kutu');
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Task ',
                            ),
                            TextSpan(
                              text: "' " + data.title + " '",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  // color: Colors.red[300]
                                  fontWeight: FontWeight.w900),
                            ),
                            TextSpan(
                              text: '  is due ' +
                                  TodoHelper.dueInDaysHumanReadableEnglish(
                                      changedTodo),
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: Colors.blue[500],
                    ));
                  }
                }, builder:
                    (BuildContext context, List<Todo> incoming, rejected) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Upcoming Todos",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      todos(context),
                    ],
                  );
                })),
          ),
          Expanded(
              // fit: FlexFit.tight,
              flex: 2,
              child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey),
                    ),
                    boxShadow: [
                      finishedHighlighted
                          ? BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              spreadRadius: 10,
                              blurRadius: 7,
                              offset:
                                  Offset(6, 1), // changes position of shadow
                            )
                          : BoxShadow(
                              color: Colors.green.withOpacity(0),
                              spreadRadius: 0,
                              blurRadius: 0,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                    ],
                  ),
                  width: double.maxFinite,
                  // color: Colors.green[100],
                  // color: Colors.white,
                  child: DragTarget(onWillAccept: (data) {
                    setState(() {
                      finishedHighlighted = true;
                    });
                    return true;
                  }, onAccept: (data) {
                    setState(() {
                      finishedHighlighted = false;
                    });
                    // Provider.of<TodoProvider>(context, listen: false)
                    //     .changeTodoSTatus(data, TodoStatus.finished);
                    Todo finishedTodo =
                        DatabaseServices(FirebaseAuth.instance.currentUser.uid)
                            .changeTodoSTatus(data, TodoStatus.finished);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Task ',
                            ),
                            TextSpan(
                              text: "' " + data.title + " '",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  // color: Colors.red[300]
                                  fontWeight: FontWeight.w900),
                            ),
                            TextSpan(
                              text: '  is completed!',
                            ),
                            // TextSpan(text: "Today"),
                          ],
                        ),
                      ),
                      backgroundColor: Colors.green[500],
                    ));
                    if (finishedTodo.isRepeat) {
                      repeatTodo(finishedTodo);
                    }
                  }, onLeave: (data) {
                    setState(() {
                      finishedHighlighted = false;
                    });
                    return true;
                  }, builder:
                      (BuildContext context, List<Todo> incoming, rejected) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Finished Today",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        finished(context),
                      ],
                    );
                  }))),
        ],
      ),
    );
    // bottomSheet: Container(height: 100.0, child: ProjectSlider()),
  }

  Widget todos(BuildContext context) {
    return Expanded(
        // fit: FlexFit.tight,
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
          width: double.infinity,
          // child:
          // Consumer<List<Project>>(builder: (context, projects, child) {
          child: Consumer<List<Todo>>(builder: (context, todos, child) {
            todos = (todos == null) ? [] : todos;
            List<Todo> todoDueRepeat = todos
                .where(
                    (td) => td.isRepeat == true && TodoHelper.isOverDue(td.due))
                .toList();
            refreshDueRepeatTodos(todoDueRepeat);
            todos = todos
                .where((td) =>
                    (td.isRepeat == true && TodoHelper.isOverDue(td.due)) ==
                    false)
                .toList();
            todos = TodoHelper.getTasksWithProjectByLevel(
                widget.projects,
                (todos == null) ? [] : todos,
                TodoStatus.todo,
                widget.projectId);
            return (todos.length > 0)
                ? Wrap(
                    children: todos
                        .map((e) => Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 5.0),
                              child: Draggable(
                                data: e,
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: todoChip(e, new Color(e.projectColor),
                                      context, false),
                                ),
                                child: todoChip(e, new Color(e.projectColor),
                                    context, false),
                                childWhenDragging: todoChip(e,
                                    new Color(e.projectColor), context, true),
                              ),
                            ))
                        .toList()
                        .cast<Widget>(),
                  )
                : getPlaceholderText("No upcoming task available");
            // });
          })),
    ));
  }

  refreshDueRepeatTodos(List<Todo> todos) {
    List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    todos.forEach((td) {
      List<DateTime> days = [];
      DateTime from = new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      from = from.subtract(Duration(days: 1));
      days = List.generate(7, (i) => from = from.add(Duration(days: 1)));
      for (DateTime day in days) {
        int indx =
            _weekDays.indexWhere((wd) => wd == DateFormat('EEE').format(day));
        if (td.weekDays[indx] == true) {
          td.tempDue = day;
          td.due = day;
          break;
        }
      }
    });
    todos.forEach((td) {
      DatabaseServices(FirebaseAuth.instance.currentUser.uid).editTodo(td);
    });
  }

  // Widget todoChip(
  //     Todo todo, Color color, BuildContext context, bool isDragging) {
  //   DateTime today = DateTime.now();
  //   if (TodoHelper.isOverDue(todo.due)) {
  //     return todoChipOverdue(todo, context, isDragging);
  //   } else {
  //     return todoChipFuture(todo, context, isDragging);
  //   }
  // }

  Widget todoChip(
      Todo todo, Color color, BuildContext context, bool isDragging) {
    int days = TodoHelper.getDifferenceInDaysFromToday(todo.due);
    return Stack(
      children: <Widget>[
        InkWell(
            child: Chip(
              backgroundColor: Colors.white,
              avatar: TodoHelper.isOverDue(todo.due)
                  ? CircleAvatar(
                      backgroundColor:
                          isDragging ? Colors.grey[400] : Colors.red[300],
                      child: new IconTheme(
                        data: new IconThemeData(color: Colors.white),
                        child: Icon(Icons.priority_high),
                      ),
                    )
                  : null,
              shape: StadiumBorder(
                  side:
                      // BorderSide(color: new Color(todo.projectColor), width: 2.0)),
                      BorderSide(
                          color: isDragging
                              ? Colors.grey[300]
                              : new Color(todo.projectColor),
                          width: 2.0)),
              label: RichText(
                text: TextSpan(
                  text: todo.title,
                  style: TextStyle(color: Colors.black),
                  children: <TextSpan>[],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditTodoWrapper(
                          todo,
                          TodoHelper.isOverDue(todo.due)
                              ? AlertStatus.overdue.value
                              : AlertStatus.future.value)));
            }),
        new Positioned(
          right: 0,
          top: 0,
          child: new Container(
            padding: EdgeInsets.all(3),
            decoration: new BoxDecoration(
              color: ((days > 0) ? Colors.green : Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: new Text(
              days.toString(),
              style: new TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  Widget ongoingChip(Todo todo, BuildContext context, bool isDragging) {
    return InkWell(
        child: Chip(
            shape: StadiumBorder(
                side: BorderSide(
                    color: isDragging
                        ? Colors.grey[300]
                        : new Color(todo.projectColor),
                    width: 2.0)),
            backgroundColor: Colors.white,
            label: RichText(
              text: TextSpan(
                text: todo.title,
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(text: '', style: TextStyle(color: Colors.red)),
                ],
              ),
            )),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditTodoWrapper(todo, AlertStatus.today.value)));
        });
  }

  Widget finishedChip(Todo todo, BuildContext context, bool isDragging) {
    return InkWell(
        child: Chip(
            shape: StadiumBorder(
                side: BorderSide(
                    color: isDragging
                        ? Colors.grey[300]
                        : new Color(todo.projectColor),
                    width: 2.0)),
            backgroundColor: Colors.white,
            // avatar: TodoHelper.getCircularAvatarFromTodo(todo),
            // label: Text(todo.title),
            label: RichText(
              text: TextSpan(
                text: todo.title,
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.lineThrough,
                ),
                children: <TextSpan>[
                  TextSpan(text: '', style: TextStyle(color: Colors.red)),
                  // TextSpan(text: ' world!'),
                ],
              ),
            )),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditTodoWrapper(todo, AlertStatus.finished.value)));
        });
  }

  Widget onGoing(BuildContext context) {
    return Expanded(
        // fit: FlexFit.tight,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                width: double.infinity,
                // child: Consumer<List<Project>>(builder: (context, projects, child) {
                child: Consumer<List<Todo>>(
                  builder: (context, todos, child) {
                    todos = (todos == null) ? [] : todos;
                    todos = TodoHelper.getTasksWithProjectByLevel(
                        widget.projects,
                        todos,
                        TodoStatus.onGoing,
                        widget.projectId);
                    return (todos.length > 0)
                        ? Wrap(
                            children: todos
                                .map((e) => Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 5.0),
                                      child: Draggable(
                                        data: e,
                                        feedback: Material(
                                          color: Colors.transparent,
                                          child: ongoingChip(e, context, false),
                                        ),
                                        child: ongoingChip(e, context, false),
                                        childWhenDragging:
                                            ongoingChip(e, context, true),
                                      ),
                                    ))
                                .toList()
                                .cast<Widget>(),
                          )
                        : getPlaceholderText('No task is due today');
                  },
                )
                // }),
                )));
  }

  Widget finished(BuildContext context) {
    return Expanded(
        // fit: FlexFit.tight,
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
          width: double.infinity,
          // constraints: BoxConstraints.expand(height: 200.0),
          // child: Consumer<List<Project>>(builder: (context, projects, child) {
          child: Consumer<List<Todo>>(
            builder: (context, todos, child) {
              todos = (todos == null) ? [] : todos;
              todos = TodoHelper.getTasksWithProjectByLevel(widget.projects,
                  todos, TodoStatus.finished, widget.projectId);

              return (todos.length > 0)
                  ? Wrap(
                      children: todos
                          .map((e) => Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 5.0),
                                // child: Draggable(
                                //   data: e,
                                //   feedback: Material(
                                //     color: Colors.transparent,
                                //     child: finishedChip(e, context, false),
                                //   ),
                                //   child: finishedChip(e, context, false),
                                //   childWhenDragging: finishedChip(e, context, true),
                                // ),
                                child: finishedChip(e, context, false),
                              ))
                          .toList()
                          .cast<Widget>(),
                    )
                  : getPlaceholderText('No task is done today');
            },
          )
          // })
          ),
    ));
  }

  repeatTodo(Todo todo) {
    List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<DateTime> days = [];
    DateTime from = todo.due;
    // from = from.add(Duration(days: 1));
    days = List.generate(7, (i) => from = from.add(Duration(days: 1)));
    for (DateTime day in days) {
      int indx =
          _weekDays.indexWhere((wd) => wd == DateFormat('EEE').format(day));
      if (todo.weekDays[indx] == true) {
        todo.tempDue = day;
        todo.due = day;
        break;
      }
    }

    DatabaseServices(FirebaseAuth.instance.currentUser.uid).addTodo(new Todo(
        '',
        todo.projectId,
        todo.title,
        null,
        null,
        TodoStatus.todo.value,
        todo.due,
        0,
        todo.isRepeat,
        todo.weekDays,
        todo.createdAt,
        new DateTime(
          DateTime.now().year + 100,
          DateTime.now().month,
          DateTime.now().day,
        )));

    // todos.forEach((todo) {
    // DatabaseServices(FirebaseAuth.instance.currentUser.uid).editTodo(todo);
    // });
  }

  Widget getPlaceholderText(String message) {
    return Container(
        margin: EdgeInsets.only(top: 14.0),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ));
  }
}
