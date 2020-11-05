import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/create_todo.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/providers/todo_provider.dart';
import 'package:second_attempt/tabbed_home.dart';

class HomeScreen extends StatelessWidget {
  final String projectId;
  HomeScreen(this.projectId) {}
  @override
  Widget build(BuildContext context) {
    print('Starting');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Container(
              width: double.maxFinite,
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
        Container(
            width: double.maxFinite,
            child: DragTarget(onWillAccept: (data) {
              return true;
            }, onAccept: (data) {
              Provider.of<TodoProvider>(context, listen: false)
                  .changeTodoSTatus(data, TodoStatus.onGoing);
            }, builder: (BuildContext context, List<Todo> incoming, rejected) {
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
                      "Ongoing",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  onGoing(),
                ],
              );
            })),
        Container(
            width: double.maxFinite,
            child: DragTarget(onWillAccept: (data) {
              return true;
            }, onAccept: (data) {
              Provider.of<TodoProvider>(context, listen: false)
                  .changeTodoSTatus(data, TodoStatus.finished);
            }, builder: (BuildContext context, List<Todo> incoming, rejected) {
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
                              child: todoChip(e, Colors.blue[200]),
                            ),
                            child: todoChip(e, Colors.blue[200]),
                            childWhenDragging: todoChip(e, Colors.grey[200]),
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
        child: Icon(Icons.radio_button_unchecked),
      ),
      label: Text(todo.title),
    );
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
                            child: todoChip(e, Colors.blue[200]),
                          ),
                          child: todoChip(e, Colors.blue[200]),
                          childWhenDragging: todoChip(e, Colors.grey[200]),
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
                            child: todoChip(e, Colors.blue[200]),
                          ),
                          child: todoChip(e, Colors.blue[200]),
                          childWhenDragging: todoChip(e, Colors.grey[200]),
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
