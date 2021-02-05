import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/helpers/todo_helper.dart';
import 'package:second_attempt/models/common.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/services/database_service.dart';

class EditTodoWrapper extends StatefulWidget {
  @override
  _EditTodoWrapperState createState() => _EditTodoWrapperState();
  final Todo todo;
  final int alertStatus;
  const EditTodoWrapper(this.todo, this.alertStatus);
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
          alertStatus: widget.alertStatus,
        ),
      ),
    );
  }
}

class EditTodoScreen extends StatefulWidget {
  final List<Project> projects;
  final Todo todo;
  final int alertStatus;
  const EditTodoScreen({
    @required this.projects,
    @required this.todo,
    @required this.alertStatus,
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
  int alertStatus;
  DateTime selectedDueDate = new DateTime.now();
  final _todoTitleTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> repeatOptions = ['Daily', 'Weekly'];
  List<String> dueDateOptions = ['Today', 'Tomorrow', 'Next Week', 'Custom'];
  List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  _EditTodoScreenState() {}
  @override
  void initState() {
    super.initState();
    setState(() {
      alertStatus = widget.alertStatus;
    });
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(Duration(days: 1));
    DateTime nextWeek = today.add(Duration(days: 7));
    if (TodoHelper.isItToday(widget.todo.due)) {
      this.selectedDueDateOption = dueDateOptions[0];
    } else if (TodoHelper.isSameDay(tomorrow, widget.todo.due)) {
      this.selectedDueDateOption = dueDateOptions[1];
    } else if (TodoHelper.isSameDay(nextWeek, widget.todo.due)) {
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
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.todo.title),
          ),
          body: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(children: [
              showAlert(),
              TextFormField(
                decoration: InputDecoration(
                  // icon: Icon(Icons.),
                  labelText: 'Task Name',
                ),
                readOnly: (widget.todo.status == TodoStatus.finished.value),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Please provide a name';
                  } else {
                    return null;
                  }
                },
                controller: _todoTitleTextController,
              ),
              projectDropDown(context),
              dueDateDropDown(context),
              buildWeeklyRepeatCheckBoxes(),
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
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Che ckbox
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
                            DatabaseServices(
                                    FirebaseAuth.instance.currentUser.uid)
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
                                  if (_formKey.currentState.validate()) {
                                    widget.todo.title =
                                        _todoTitleTextController.text;
                                    widget.todo.projectId =
                                        this.selectedProjectId;
                                    widget.todo.due = this.selectedDueDate;
                                    if (this.isFinished) {
                                      widget.todo.finishedAt = DateTime.now();
                                      widget.todo.status =
                                          TodoStatus.finished.value;
                                    }
                                    DatabaseServices(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .editTodo(widget.todo);
                                    Navigator.of(context).pop();
                                  }
                                }
                              : null,
                        )),
                  ),
                ],
              ),
            ]),
          ),
        ));
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
                      DateTime today = DateTime(now.year, now.month, now.day);
                      DateTime tomorrow = today.add(Duration(days: 1));
                      DateTime nextWeek = today.add(Duration(days: 7));
                      this.selectedDueDateOption = newVal;
                      if (newVal == 'Custom') {
                        _selectDate(context);
                      } else if (newVal == 'Today') {
                        this.selectedDueDate = now;
                      } else if (newVal == 'Tomorrow') {
                        this.selectedDueDate = tomorrow;
                      } else if (newVal == 'Next Week') {
                        this.selectedDueDate = nextWeek;
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

  Widget buildWeeklyRepeatCheckBoxes() {
    List<Widget> list = new List();
    Widget cb;
    // print("ohh !: " + widget.todo.weekDays.toString());
    print("ohh !: " + widget.todo.isRepeat.toString());

    for (int i = 0; i < widget.todo.weekDays.length; i++) {
      cb = Checkbox(
        value: widget.todo.weekDays[i],
        onChanged: (bool value) {
          setState(() {
            // need to update weekDaysValue[?]
            widget.todo.weekDays[i] = value;
          });
        },
      );
      Widget cbR = SizedBox(
          width: 80,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text(_weekDays[i]), cb]));
      list.add(cbR);
    }
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey, spreadRadius: 1),
          ],
        ),
        padding: EdgeInsets.only(left: 15.0),
        margin: EdgeInsets.only(top: 30.0),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                )),
              ),
              width: 120,
              child: ListTileTheme(
                  contentPadding: EdgeInsets.all(0),
                  child: CheckboxListTile(
                    title: Text("Repeat"),
                    value: widget.todo.isRepeat,
                    onChanged: (newValue) {
                      setState(() {
                        widget.todo.isRepeat = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .trailing, //  <-- leading Che ckbox
                  ))),
          Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 5,
            runSpacing: 5,
            children: list,
          )
        ]));
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

  Widget showAlert() {
    if (alertStatus != 0) {
      return Container(
        // color: Colors.amber,
        width: double.infinity,
        // height: 50.0,
        padding: EdgeInsets.all(5.0),
        // margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: TodoHelper.getAlertColor(alertStatus),
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: TodoHelper.getAlertIcon(alertStatus)),
            Expanded(
              // height: 17.0,
              child: AutoSizeText(
                TodoHelper.getAlertText(alertStatus, widget.todo),
                style: TextStyle(
                    fontSize: 16.0,
                    color: TodoHelper.getAlertColor(alertStatus),
                    fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: TodoHelper.getAlertColor(alertStatus),
                ),
                onPressed: () {
                  setState(() {
                    alertStatus = AlertStatus.noAlert.value;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
