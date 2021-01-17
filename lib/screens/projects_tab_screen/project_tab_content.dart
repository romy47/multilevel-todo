import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/helpers/todo_helper.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/screens/edit_todo_screen/edit_todo_screen.dart';
import 'package:second_attempt/services/database_service.dart';

class ProjectTabContent extends StatelessWidget {
  final String projectId;
  final List<Project> projects;
  ProjectTabContent(this.projectId, this.projects) {}
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            // fit: FlexFit.tight,
            flex: 4,
            child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                width: double.maxFinite,
                child: DragTarget(onWillAccept: (data) {
                  return true;
                }, onAccept: (data) {
                  DatabaseServices(FirebaseAuth.instance.currentUser.uid)
                      .changeTodoSTatus(data, TodoStatus.todo);
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
                          "Todos",
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
                ),
                width: double.maxFinite,
                child: DragTarget(onWillAccept: (data) {
                  return true;
                }, onAccept: (data) {
                  DatabaseServices(FirebaseAuth.instance.currentUser.uid)
                      .changeTodoSTatus(data, TodoStatus.onGoing);
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
              flex: 2,
              child: Container(
                  width: double.maxFinite,
                  // color: Colors.green[100],
                  color: Colors.white,
                  child: DragTarget(onWillAccept: (data) {
                    return true;
                  }, onAccept: (data) {
                    // Provider.of<TodoProvider>(context, listen: false)
                    //     .changeTodoSTatus(data, TodoStatus.finished);
                    DatabaseServices(FirebaseAuth.instance.currentUser.uid)
                        .changeTodoSTatus(data, TodoStatus.finished);
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
            return Wrap(
              children: TodoHelper.getTasksWithProjectByLevel(projects,
                      (todos == null) ? [] : todos, TodoStatus.todo, projectId)
                  .map((e) => Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Draggable(
                          data: e,
                          feedback: Material(
                            color: Colors.transparent,
                            child:
                                todoChip(e, new Color(e.projectColor), context),
                          ),
                          child:
                              todoChip(e, new Color(e.projectColor), context),
                          childWhenDragging:
                              todoChip(e, new Color(e.projectColor), context),
                        ),
                      ))
                  .toList()
                  .cast<Widget>(),
            );
            // });
          })),
    ));
  }

  Widget todoChip(Todo todo, Color color, BuildContext context) {
    DateTime today = DateTime.now();
    if (TodoHelper.isOverDue(todo.due)) {
      return todoChipOverdue(todo, context);
    } else {
      return todoChipFuture(todo, context);
    }
  }

  Widget todoChipOverdue(Todo todo, BuildContext context) {
    DateTime today = DateTime.now();
    return InkWell(
        child: Chip(
          backgroundColor: Colors.white,
          avatar: CircleAvatar(
            backgroundColor: Colors.red[300],
            child: new IconTheme(
              data: new IconThemeData(color: Colors.white),
              child: Icon(Icons.priority_high),
            ),
          ),
          shape: StadiumBorder(
              side:
                  BorderSide(color: new Color(todo.projectColor), width: 2.0)),
          label: RichText(
            text: TextSpan(
              text: todo.title,
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: ' ' +
                        ((todo.due.day - today.day) == 1
                            ? 'Tomorrow'
                            : (todo.due.day - today.day).toString() +
                                ' day' +
                                (((todo.due.day - today.day) == 1 ||
                                        (todo.due.day - today.day) == -1)
                                    ? ''
                                    : 's')),
                    style: TextStyle(
                        color: ((todo.due.day - today.day) > 0)
                            ? Colors.green
                            : Colors.red)),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditTodoWrapper(todo)));
        });
  }

  Widget todoChipFuture(Todo todo, BuildContext context) {
    DateTime today = DateTime.now();
    return InkWell(
        child: Chip(
            backgroundColor: Colors.white,
            shape: StadiumBorder(
                side: BorderSide(
                    color: new Color(todo.projectColor), width: 2.0)),
            label: RichText(
              text: TextSpan(
                text: todo.title,
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: ' ' +
                          ((todo.due.day - today.day) == 1
                              ? 'Tomorrow'
                              : (todo.due.day - today.day).toString() +
                                  ' day' +
                                  (((todo.due.day - today.day) == 1)
                                      ? ''
                                      : 's')),
                      style: TextStyle(
                          color: ((todo.due.day - today.day) > 0)
                              ? Colors.green
                              : Colors.red)),
                ],
              ),
            )),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditTodoWrapper(todo)));
        });
  }

  Widget ongoingChip(Todo todo, BuildContext context) {
    return InkWell(
        child: Chip(
            shape: StadiumBorder(
                side: BorderSide(
                    color: new Color(todo.projectColor), width: 2.0)),
            backgroundColor: Colors.white,
            // avatar: TodoHelper.getCircularAvatarFromTodo(todo),
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditTodoWrapper(todo)));
        });
  }

  Widget finishedChip(Todo todo, BuildContext context) {
    return InkWell(
        child: Chip(
            shape: StadiumBorder(
                side: BorderSide(
                    color: new Color(todo.projectColor), width: 2.0)),
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditTodoWrapper(todo)));
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
                    return Wrap(
                      children: TodoHelper.getTasksWithProjectByLevel(
                              projects, todos, TodoStatus.onGoing, projectId)
                          .map((e) => Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 5.0),
                                child: Draggable(
                                  data: e,
                                  feedback: Material(
                                    color: Colors.transparent,
                                    child: ongoingChip(e, context),
                                  ),
                                  child: ongoingChip(e, context),
                                  childWhenDragging: ongoingChip(e, context),
                                ),
                              ))
                          .toList()
                          .cast<Widget>(),
                    );
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
              return Wrap(
                children: TodoHelper.getTasksWithProjectByLevel(
                        projects, todos, TodoStatus.finished, projectId)
                    .map((e) => Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 5.0),
                          // child: Draggable(
                          //   data: e,
                          //   feedback: Material(
                          //     color: Colors.transparent,
                          //     child: finishedChip(e, context),
                          //   ),
                          //   child: finishedChip(e, context),
                          //   childWhenDragging: finishedChip(e, context),
                          // ),
                          child: finishedChip(e, context),
                        ))
                    .toList()
                    .cast<Widget>(),
              );
            },
          )
          // })
          ),
    ));
  }
}
