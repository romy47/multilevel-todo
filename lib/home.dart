import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/create_todo.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/providers/todo_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Starting');
    return Scaffold(
      appBar: AppBar(
        title: Text('Awesome Todo'),
      ),
      body: Column(
        children: [
          Container(
              width: double.maxFinite,
              child: DragTarget(onWillAccept: (data) {
                return true;
              }, onAccept: (data) {
                Provider.of<TodoProvider>(context, listen: false)
                    .changeTodoSTatus(data, TodoStatus.todo);
              }, builder:
                  (BuildContext context, List<Todo> incoming, rejected) {
                return Column(
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
          Container(
              width: double.maxFinite,
              child: DragTarget(onWillAccept: (data) {
                return true;
              }, onAccept: (data) {
                Provider.of<TodoProvider>(context, listen: false)
                    .changeTodoSTatus(data, TodoStatus.onGoing);
              }, builder:
                  (BuildContext context, List<Todo> incoming, rejected) {
                return Column(
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
              }, builder:
                  (BuildContext context, List<Todo> incoming, rejected) {
                return Column(
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
      bottomSheet: Container(height: 100.0, child: ProjectSlider()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateTodo()))
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('User Name'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Create Todo'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateTodo()));
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget todos() {
    return Container(
        color: Colors.blue[100],
        width: double.infinity,
        child: Consumer<TodoProvider>(builder: (context, todoProvider, child) {
          return Wrap(
            children: todoProvider.todos
                .map((e) => Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
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
        }));
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
    return Container(
      width: double.infinity,
      color: Colors.amber[100],
      child: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return Wrap(
            children: todoProvider.ongoingTodos
                .map((e) => Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
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
    );
  }

  Widget finished() {
    return Container(
      width: double.infinity,
      color: Colors.green[100],
      // constraints: BoxConstraints.expand(height: 200.0),
      child: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return Wrap(
            children: todoProvider.finishedTodos
                .map((e) => Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
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
    );
  }
}

class ProjectSlider extends StatefulWidget {
  @override
  ProjectSsliderState createState() => ProjectSsliderState();
}

class ProjectSsliderState extends State<ProjectSlider> {
  var _selectedProject = 0.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<TodoProvider>(builder: (context, todoProvider, child) {
        return Slider(
          value: todoProvider.projectIndex.toDouble(),
          min: todoProvider.minProjectIndex,
          max: todoProvider.maxProjectIndex,
          divisions: todoProvider.maxProjectIndex.toInt(),
          label: _selectedProject.toString(),
          onChanged: (double value) {
            // setState(() => _selectedProject = value);
            todoProvider.setSelectedProjectIndex(value.toInt());
            //   Provider.of<TodoProvider>(context, listen: false)
            //       .setSelectedProjectIndex(value.toInt());
          },
        );
      }),
    );
  }
}
