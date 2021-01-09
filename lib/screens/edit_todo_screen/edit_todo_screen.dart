import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/services/database_service.dart';

class EditTodoWrapper extends StatefulWidget {
  @override
  _EditTodoWrapperState createState() => _EditTodoWrapperState();
  final Todo todo;
  const EditTodoWrapper(this.todo);
}

class _EditTodoWrapperState extends State<EditTodoWrapper> {
  @override
  Widget build(BuildContext context) {
    // finishedTodos = Provider.of<TodoProvider>(context, listen: false)
    //     .getTasksByLevel(TodoStatus.finished, 'all');
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: const Text('Timeline')),
      // ),
      body: Consumer<List<Project>>(
        builder: (context, projects, child) => EditTodoScreen(
          projects: projects == null ? [] : projects,
          todo: widget.todo,
        ),
      ),
    );
  }
}

class EditTodoScreen extends StatefulWidget {
  final List<Project> projects;
  final Todo todo;
  const EditTodoScreen({
    @required this.projects,
    @required this.todo,
    Key key,
  }) : super(key: key);
  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  String selectedProjectId;
  // Project selectedProject;
  String selectedDueDateOption;
  String selectedRepeat;
  bool isFinished;

  DateTime selectedDueDate = new DateTime.now();
  final _todoTitleTextController = TextEditingController();
  List<String> repeatOptions = ['Daily', 'Weekly'];
  List<String> dueDateOptions = ['Today', 'Tomorrow', 'Next Week', 'Custom'];

  _EditTodoScreenState() {}
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    if (now.day == widget.todo.due.day) {
      this.selectedDueDateOption = dueDateOptions[0];
    } else if (now.day + 1 == widget.todo.due.day) {
      this.selectedDueDateOption = dueDateOptions[1];
    } else if (now.day + 7 == widget.todo.due.day) {
      this.selectedDueDateOption = dueDateOptions[2];
    } else {
      this.selectedDueDateOption = dueDateOptions[3];
    }
    this.isFinished = (widget.todo.status == TodoStatus.finished.value);
    this._todoTitleTextController.text = widget.todo.title;
    this.selectedDueDate = widget.todo.due;
    this.selectedProjectId =
        widget.projects.firstWhere((p) => p.id == widget.todo.projectId).id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo.title),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(children: [
          TextFormField(
            decoration: InputDecoration(
              // icon: Icon(Icons.),
              labelText: 'Task Name',
            ),
            readOnly: (widget.todo.status == TodoStatus.finished.value),
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
          Container(
              margin: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 0),
              child: CheckboxListTile(
                title: Text("Finished"),
                value: this.isFinished,
                onChanged: (widget.todo.status != TodoStatus.finished.value)
                    ? (newValue) {
                        setState(() {
                          this.isFinished = newValue;
                        });
                      }
                    : null,
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Che ckbox
              )),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                    height: 50,
                    width: double.maxFinite,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.red,
                      child: Text('Delete'),
                      onPressed: () {
                        DatabaseServices(FirebaseAuth.instance.currentUser.uid)
                            .deleteTodo(widget.todo.id);
                        Navigator.of(context).pop();
                      },
                    )),
              ),
              Flexible(
                flex: 1,
                child: Container(
                    height: 50,
                    width: double.maxFinite,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Save'),
                      onPressed: (widget.todo.status !=
                              TodoStatus.finished.value)
                          ? () {
                              widget.todo.title = _todoTitleTextController.text;
                              widget.todo.projectId = this.selectedProjectId;
                              widget.todo.due = this.selectedDueDate;
                              if (this.isFinished) {
                                widget.todo.finishedAt = DateTime.now();
                                widget.todo.status = TodoStatus.finished.value;
                              }
                              DatabaseServices(
                                      FirebaseAuth.instance.currentUser.uid)
                                  .editTodo(widget.todo);
                              Navigator.of(context).pop();
                            }
                          : null,
                    )),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget projectDropDown(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 0),
      child: IgnorePointer(
        ignoring: (widget.todo.status == TodoStatus.finished.value),
        child: DropdownButtonFormField<String>(
            value: selectedProjectId,
            isExpanded: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                labelStyle: TextStyle(),
                labelText: 'Project'),
            items: widget.projects.map((Project project) {
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
            onChanged: (newVal) {
              setState(() {
                this.selectedProjectId = newVal;
                print(selectedProjectId);
              });
            }),
      ),
    );
  }

  Widget dueDateDropDown(context) {
    // setState(() {

    // });
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: IgnorePointer(
              ignoring: (widget.todo.status == TodoStatus.finished.value),
              child: DropdownButtonFormField<String>(
                  value: selectedDueDateOption,
                  isExpanded: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      labelStyle: TextStyle(),
                      labelText: 'Due Date'),
                  items: this.dueDateOptions.map((String option) {
                    return new DropdownMenuItem<String>(
                      value: option,
                      child: new Text(
                        option,
                        style: TextStyle(
                            color: (option == selectedDueDateOption)
                                ? Colors.blue[300]
                                : Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: selectedDueDateOption == null
                      ? Text('Select Due Date')
                      : Text(
                          DateFormat('yyyy-MM-dd – kk:mm')
                              .format(selectedDueDate),
                          style: TextStyle(color: Colors.blue),
                        ),
                  onChanged: (newVal) {
                    setState(() {
                      final now = DateTime.now();
                      this.selectedDueDateOption = newVal;
                      if (newVal == 'Custom') {
                        _selectDate(context);
                      } else if (newVal == 'Today') {
                        this.selectedDueDate = now;
                      } else if (newVal == 'Tomorrow') {
                        this.selectedDueDate =
                            DateTime(now.year, now.month, now.day + 1);
                      } else if (newVal == 'Next Week') {
                        this.selectedDueDate =
                            DateTime(now.year, now.month, now.day + 7);
                      }
                    });
                  }),
            ),
          ),
          Flexible(
              flex: 1,
              child: Text(
                DateFormat.yMMMd('en_US').format(selectedDueDate),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ))
        ],
      ),
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
        this.selectedDueDate = picked;
      });
  }
}
