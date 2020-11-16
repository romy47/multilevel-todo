import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/providers/home_tab_provider.dart';
import 'package:second_attempt/providers/todo_provider.dart';
import 'package:second_attempt/services/database_service.dart';

class CreateTodoScreen extends StatefulWidget {
  @override
  _CreateTodoScreenState createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  String selectedProjectId;
  Project selectedProject;
  String selectedDueDateOption;
  String selectedRepeat;
  DateTime selectedDueDate = new DateTime.now();
  final _todoTitleTextController = TextEditingController();
  List<String> repeatOptions = ['Daily', 'Weekly'];
  List<String> dueDateOptions = ['Today', 'Tomorrow', 'Next Week', 'Pick Date'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo'),
      ),
      body: Column(children: [
        TextFormField(
          decoration: InputDecoration(
            // icon: Icon(Icons.),
            labelText: 'Task Name',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please name your todo';
            } else {
              return null;
            }
          },
          controller: _todoTitleTextController,
        ),
        projectDropDown(context),
        dueDateDropDown(context),
        RaisedButton(
          onPressed: () => {
            Provider.of<TodoProvider>(context, listen: false).addNewTodo(Todo(
                '',
                this.selectedProjectId,
                _todoTitleTextController.text,
                this.selectedProject.title,
                this.selectedProject.color,
                TodoStatus.todo.value,
                this.selectedDueDate,
                0,
                new DateTime(
                  this.selectedDueDate.year,
                  this.selectedDueDate.month,
                  this.selectedDueDate.day,
                )
                // this.selectedDueDate
                )),
            DatabaseServices(FirebaseAuth.instance.currentUser.uid)
                .addTodo(new Todo(
                    '',
                    this.selectedProjectId,
                    _todoTitleTextController.text,
                    this.selectedProject.title,
                    this.selectedProject.color,
                    TodoStatus.todo.value,
                    this.selectedDueDate,
                    0,
                    new DateTime(
                      this.selectedDueDate.year,
                      this.selectedDueDate.month,
                      this.selectedDueDate.day,
                    ))),
            Navigator.of(context).pop(),
            // Scaffold.of(context).showSnackBar(SnackBar(
            //     content: Text('"' +
            //         _todoTitleTextController.text +
            //         '" is added as a Todo'))
            //         )
          },
          child: Text('Create Todo'),
        )
      ]),
    );
  }

  Widget projectDropDown(context) {
    return Consumer<List<Project>>(builder: (context, projects, child) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: DropdownButton<String>(
            value: selectedProjectId,
            isExpanded: true,
            items: projects.map((Project project) {
              return new DropdownMenuItem<String>(
                value: project.id,
                child: (project.id == selectedProjectId)
                    ? new Text(
                        project.title,
                        style: TextStyle(color: Colors.blue[300]),
                      )
                    : new Text(
                        project.title,
                        style: TextStyle(color: Colors.black),
                      ),
              );
            }).toList(),
            hint: selectedProjectId == null
                ? Text('Select Project')
                : Text(
                    projects
                        .firstWhere(
                            (project) => project.id == selectedProjectId)
                        .title,
                    style: TextStyle(color: Colors.blue),
                  ),
            onChanged: (newVal) {
              setState(() {
                selectedProjectId = newVal;
                selectedProject = projects
                    .firstWhere((element) => element.id == selectedProjectId);
              });
            }),
      );
    });
  }

  Widget dueDateDropDown(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: DropdownButton<String>(
          value: selectedDueDateOption,
          isExpanded: true,
          items: this.dueDateOptions.map((String option) {
            return new DropdownMenuItem<String>(
              value: option,
              child: (option == selectedDueDateOption)
                  ? new Text(
                      option,
                      style: TextStyle(color: Colors.blue[300]),
                    )
                  : new Text(
                      option,
                      style: TextStyle(color: Colors.black),
                    ),
            );
          }).toList(),
          hint: selectedDueDateOption == null
              ? Text('Select Due Date')
              : Text(
                  // dueDateOptions
                  //     .firstWhere((option) => option == selectedDueDateOption),
                  DateFormat('yyyy-MM-dd – kk:mm').format(selectedDueDate),
                  style: TextStyle(color: Colors.blue),
                ),
          onChanged: (newVal) {
            this.setState(() {
              final now = DateTime.now();
              this.selectedDueDateOption = newVal;
              if (newVal == 'Pick Date') {
                _selectDate(context);
              } else if (newVal == 'Today') {
                selectedDueDate = now;
              } else if (newVal == 'Tomorrow') {
                selectedDueDate = DateTime(now.year, now.month, now.day + 1);
              } else if (newVal == 'Next Week') {
                selectedDueDate = DateTime(now.year, now.month, now.day + 7);
              }
              print('New State is  ' + this.selectedDueDateOption);
            });
          }),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: this.selectedDueDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDueDate)
      setState(() {
        selectedDueDate = picked;
      });
  }
}
