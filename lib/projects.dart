import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'providers/home_tab_provider.dart';

class Projects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Todo'),
        ),
        body: Center(
          child: Scaffold(
              body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Create New Project',
                      ),
                    ),
                  ),
                  onTap: () => {createProjectDialog(context)}),
              Container(
                child: Consumer<HomeTabProvider>(
                    builder: (context, tabProvider, child) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: tabProvider.projects.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                tabProvider.projects[index].title,
                              ),
                            ),
                          ),
                          onTap: () => {});
                    },
                  );
                }),
              )
            ],
          )),
        ),
      ),
    );
  }

  void createProjectDialog(context) {
    final _todoTitleTextController = TextEditingController();
    Alert(
        context: context,
        title: "Create Project",
        content: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                // icon: Icon(Icons.),
                labelText: 'Project Name',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please name your project';
                } else {
                  return null;
                }
              },
              controller: _todoTitleTextController,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => {
              Navigator.pop(context),
              // Provider.of<TodoProvider>(context, listen: false).addNewTodo(Todo(
              //     _todoTitleTextController.text,
              //     Provider.of<TodoProvider>(context, listen: false)
              //         .selectedProjectId,
              //     _todoTitleTextController.text,
              //     TodoStatus.todo)),
              // Scaffold.of(context).showSnackBar(SnackBar(
              //     content: Text('"' +
              //         _todoTitleTextController.text +
              //         '" is added as a Todo')))
            },
            child: Text(
              "Create",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
