import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/providers/home_tab_provider.dart';
import 'package:second_attempt/providers/todo_provider.dart';

class ProjectTabContent extends StatelessWidget {
  final String projectId;
  ProjectTabContent(this.projectId) {}
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
                width: double.maxFinite,
                color: Colors.blue[100],
                child: DragTarget(onWillAccept: (data) {
                  return true;
                }, onAccept: (data) {
                  Provider.of<TodoProvider>(context, listen: false)
                      .changeTodoSTatus(data, TodoStatus.todo);
                }, builder:
                    (BuildContext context, List<Todo> incoming, rejected) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Colors.blue[100],
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Todos",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      todos(),
                    ],
                  );
                })),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
                width: double.maxFinite,
                color: Colors.amber[100],
                child: DragTarget(onWillAccept: (data) {
                  return true;
                }, onAccept: (data) {
                  Provider.of<TodoProvider>(context, listen: false)
                      .changeTodoSTatus(data, TodoStatus.onGoing);
                }, builder:
                    (BuildContext context, List<Todo> incoming, rejected) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Colors.amber[100],
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Today's Goal",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      onGoing(),
                    ],
                  );
                })),
          ),
          Container(
              width: double.maxFinite,
              color: Colors.green[100],
              child: DragTarget(onWillAccept: (data) {
                return true;
              }, onAccept: (data) {
                Provider.of<TodoProvider>(context, listen: false)
                    .changeTodoSTatus(data, TodoStatus.finished);
              }, builder:
                  (BuildContext context, List<Todo> incoming, rejected) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.green[100],
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Finished",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    finished(),
                  ],
                );
              })),
        ],
      ),
    );
    // bottomSheet: Container(height: 100.0, child: ProjectSlider()),
  }

  Widget todos() {
    return Flexible(
      fit: FlexFit.tight,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            color: Colors.blue[100],
            width: double.infinity,
            child:
                Consumer<TodoProvider>(builder: (context, todoProvider, child) {
              return Wrap(
                children: todoProvider
                    .getTasksByLevel(TodoStatus.todo, projectId)
                    .map((e) => Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 5.0),
                          child: Draggable(
                            data: e,
                            feedback: Material(
                              color: Colors.transparent,
                              child: todoChip(
                                e,
                                new Color(Provider.of<HomeTabProvider>(context,
                                        listen: false)
                                    .getProject(e.projectId)
                                    .color),
                              ),
                            ),
                            child: todoChip(
                                e,
                                new Color(Provider.of<HomeTabProvider>(context,
                                        listen: false)
                                    .getProject(e.projectId)
                                    .color)),
                            childWhenDragging: todoChip(
                                e,
                                new Color(Provider.of<HomeTabProvider>(context,
                                        listen: false)
                                    .getProject(e.projectId)
                                    .color)),
                          ),
                        ))
                    .toList()
                    .cast<Widget>(),
              );
            })),
      ),
    );
  }

  Widget todoChip(Todo todo, Color color) {
    return Chip(
        backgroundColor: Colors.white,
        avatar: CircleAvatar(
          backgroundColor: color,
          child: Icon(Icons.navigate_next),
        ),
        // label: Text(todo.title),
        label: RichText(
          text: TextSpan(
            text: todo.title,
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: ' ' +
                      todo.due
                          .difference(DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ))
                          .inDays
                          .toString() +
                      ' days',
                  style: TextStyle(color: Colors.red)),
              // TextSpan(text: ' world!'),
            ],
          ),
        ));
  }

  Widget ongoingChip(Todo todo, Color color) {
    return Chip(
        backgroundColor: Colors.white,
        avatar: CircleAvatar(
          backgroundColor: color,
          child: Icon(Icons.navigate_next),
        ),
        // label: Text(todo.title),
        label: RichText(
          text: TextSpan(
            text: todo.title,
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(text: '', style: TextStyle(color: Colors.red)),
              // TextSpan(text: ' world!'),
            ],
          ),
        ));
  }

  Widget finishedChip(Todo todo, Color color) {
    return Chip(
        backgroundColor: Colors.white,
        avatar: CircleAvatar(
          backgroundColor: color,
          child: Icon(Icons.navigate_next),
        ),
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
        ));
  }

  Widget onGoing() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        width: double.infinity,
        color: Colors.amber[100],
        child: Consumer<TodoProvider>(
          builder: (context, todoProvider, child) {
            return Wrap(
              children: todoProvider
                  .getTasksByLevel(TodoStatus.onGoing, projectId)
                  .map((e) => Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Draggable(
                          data: e,
                          feedback: Material(
                            color: Colors.transparent,
                            child: ongoingChip(
                                e,
                                new Color(Provider.of<HomeTabProvider>(context,
                                        listen: false)
                                    .getProject(e.projectId)
                                    .color)),
                          ),
                          child: ongoingChip(
                              e,
                              new Color(Provider.of<HomeTabProvider>(context,
                                      listen: false)
                                  .getProject(e.projectId)
                                  .color)),
                          childWhenDragging: ongoingChip(
                              e,
                              new Color(Provider.of<HomeTabProvider>(context,
                                      listen: false)
                                  .getProject(e.projectId)
                                  .color)),
                        ),
                      ))
                  .toList()
                  .cast<Widget>(),
            );
          },
        ),
      ),
    );
  }

  Widget finished() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        width: double.infinity,
        color: Colors.green[100],
        // constraints: BoxConstraints.expand(height: 200.0),
        child: Consumer<TodoProvider>(
          builder: (context, todoProvider, child) {
            return Wrap(
              children: todoProvider
                  .getTasksByLevel(TodoStatus.finished, projectId)
                  .map((e) => Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Draggable(
                          data: e,
                          feedback: Material(
                            color: Colors.transparent,
                            child: finishedChip(
                                e,
                                new Color(Provider.of<HomeTabProvider>(context,
                                        listen: false)
                                    .getProject(e.projectId)
                                    .color)),
                          ),
                          child: finishedChip(
                              e,
                              new Color(Provider.of<HomeTabProvider>(context,
                                      listen: false)
                                  .getProject(e.projectId)
                                  .color)),
                          childWhenDragging: finishedChip(
                              e,
                              new Color(Provider.of<HomeTabProvider>(context,
                                      listen: false)
                                  .getProject(e.projectId)
                                  .color)),
                        ),
                      ))
                  .toList()
                  .cast<Widget>(),
            );
          },
        ),
      ),
    );
  }
}

// class ProjectSlider extends StatefulWidget {
//   @override
//   ProjectSsliderState createState() => ProjectSsliderState();
// }

// class ProjectSsliderState extends State<ProjectSlider> {
//   var _selectedProject = 0.0;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Consumer<TodoProvider>(builder: (context, todoProvider, child) {
//         return Slider(
//           value: todoProvider.projectIndex.toDouble(),
//           min: todoProvider.minProjectIndex,
//           max: todoProvider.maxProjectIndex,
//           divisions: todoProvider.maxProjectIndex.toInt(),
//           label: _selectedProject.toString(),
//           onChanged: (double value) {
//             // setState(() => _selectedProject = value);
//             todoProvider.setSelectedProjectIndex(value.toInt());
//             //   Provider.of<TodoProvider>(context, listen: false)
//             //       .setSelectedProjectIndex(value.toInt());
//           },
//         );
//       }),
//     );
//   }
// }
