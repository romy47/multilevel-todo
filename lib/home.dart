import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/create_todo.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/providers/todo_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Awesome Todo'),
      ),
      body: Column(
        children: [
          Column(
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
          ),
          Column(
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
          ),
          Column(
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
          )
        ],
      ),
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
      // constraints: BoxConstraints.expand(height: 200.0),
      child: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final item = todoProvider.todos[index];
              return ListTile(
                title: Text(item.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // new IconButton(
                    //   icon: new Icon(Icons.arrow_circle_up),
                    //   onPressed: () {},
                    // ),
                    new IconButton(
                      icon: new Icon(Icons.arrow_circle_down),
                      onPressed: () {
                        todoProvider.changeTodoSTatus(item, TodoStatus.onGoing);
                      },
                    ),
                  ],
                ),
                // subtitle: Text(item.status.toString())
              );
            },
          );
        },
      ),
    );
  }

  Widget onGoing() {
    return Container(
      color: Colors.amber[100],
      // constraints: BoxConstraints.expand(height: 200.0),
      child: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: todoProvider.ongoingTodos.length,
            itemBuilder: (context, index) {
              final item = todoProvider.ongoingTodos[index];
              return ListTile(
                title: Text(item.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new IconButton(
                      icon: new Icon(Icons.arrow_circle_up),
                      onPressed: () {
                        todoProvider.changeTodoSTatus(item, TodoStatus.todo);
                      },
                    ),
                    new IconButton(
                      icon: new Icon(Icons.arrow_circle_down),
                      onPressed: () {
                        todoProvider.changeTodoSTatus(
                            item, TodoStatus.finished);
                      },
                    ),
                  ],
                ),
                // subtitle: Text(item.status.toString())
              );
            },
          );
        },
      ),
    );
  }

  Widget finished() {
    return Container(
      color: Colors.green[100],
      // constraints: BoxConstraints.expand(height: 200.0),
      child: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: todoProvider.finishedTodos.length,
            itemBuilder: (context, index) {
              final item = todoProvider.finishedTodos[index];
              return ListTile(
                title: Text(item.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new IconButton(
                      icon: new Icon(Icons.arrow_circle_up),
                      onPressed: () {
                        todoProvider.changeTodoSTatus(item, TodoStatus.onGoing);
                      },
                    ),
                    // new IconButton(
                    //   icon: new Icon(Icons.arrow_circle_down),
                    //   onPressed: () {
                    //     todoProvider.changeTodoSTatus(item, TodoStatus.onGoing);
                    //   },
                    // ),
                  ],
                ),
                // subtitle: Text(item.status.toString())
              );
            },
          );
        },
      ),
    );
  }
}
