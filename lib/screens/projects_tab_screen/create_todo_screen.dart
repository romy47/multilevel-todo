import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/helpers/todo_helper.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/services/database_service.dart';

class CreateTodoWrapper extends StatefulWidget {
  @override
  _CreateTodoWrapperState createState() => _CreateTodoWrapperState();
}

class _CreateTodoWrapperState extends State<CreateTodoWrapper> {
  @override
  Widget build(BuildContext context) {
    // finishedTodos = Provider.of<TodoProvider>(context, listen: false)
    //     .getTasksByLevel(TodoStatus.finished, 'all');
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: const Text('Timeline')),
      // ),
      body: Consumer<List<Project>>(
        builder: (context, projects, child) => CreateTodoScreen(
          projects: projects == null ? [] : projects,
        ),
      ),
    );
  }
}

class CreateTodoScreen extends StatefulWidget {
  final List<Project> projects;
  const CreateTodoScreen({
    @required this.projects,
    Key key,
  }) : super(key: key);
  @override
  _CreateTodoScreenState createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  String selectedProjectId;
  // Project selectedProject;
  String selectedDueDateOption;
  String selectedRepeat;

  DateTime selectedDueDate = new DateTime.now();
  final _todoTitleTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // List<String> repeatOptions = ['Daily', 'Weekly'];
  List<String> dueDateOptions = ['Today', 'Tomorrow', 'Next Week', 'Custom'];
  List<bool> weekDaysValue = [false, false, false, false, false, false, false];
  List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  bool isRepeat = false;

  _CreateTodoScreenState() {}
  @override
  void initState() {
    super.initState();
    this.selectedDueDateOption = dueDateOptions[1];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(Duration(days: 1));
    this.selectedDueDate = tomorrow;
    this.selectedProjectId =
        widget.projects != null ? widget.projects[0].id : null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create Todo'),
          ),
          body: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(children: [
              TextFormField(
                decoration: InputDecoration(
                  // icon: Icon(Icons.),
                  labelText: 'Task Name',
                ),
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
              // Container(
              //     margin: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 0),
              //     child: CheckboxListTile(
              //       title: Text("Finished"),
              //       value: false,
              //       onChanged: (newValue) {
              //         setState(() {
              //           //  checkedValue = newValue;
              //         });
              //       },
              //       controlAffinity: ListTileControlAffinity
              //           .leading, //  <-- leading Che ckbox
              //     )),
              Container(
                  height: 50,
                  width: double.maxFinite,
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Save Todo'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        print(weekDaysValue.toString());
                        print(isRepeat);

                        DatabaseServices(FirebaseAuth.instance.currentUser.uid)
                            .addTodo(new Todo(
                                '',
                                this.selectedProjectId,
                                _todoTitleTextController.text,
                                null,
                                null,
                                TodoStatus.todo.value,
                                this.selectedDueDate,
                                0,
                                isRepeat,
                                weekDaysValue,
                                new DateTime(
                                  this.selectedDueDate.year,
                                  this.selectedDueDate.month,
                                  this.selectedDueDate.day,
                                ),
                                new DateTime(
                                  DateTime.now().year + 100,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                )));
                        Navigator.of(context).pop();
                      }
                    },
                  )),
            ]),
          ),
        ));
  }

  Widget projectDropDown(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 0),
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

    for (int i = 0; i < weekDaysValue.length; i++) {
      cb = Checkbox(
        value: weekDaysValue[i],
        onChanged: (bool value) {
          setState(() {
            // need to update weekDaysValue[?]
            weekDaysValue[i] = value;
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
                    value: isRepeat,
                    onChanged: (newValue) {
                      toggleRepeat(newValue);
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

  toggleRepeat(bool val) {
    DateTime due = new DateTime(
      this.selectedDueDate.year,
      this.selectedDueDate.month,
      this.selectedDueDate.day,
    );
    String dueWeekDay = DateFormat('EEE').format(due);
    setState(() {
      isRepeat = val;
      if (val) {
        _weekDays.asMap().forEach((index, day) {
          if (day == dueWeekDay) {
            weekDaysValue[index] = true;
          }
        });
      } else {
        for (var i = 0; i < weekDaysValue.length; i++) {
          weekDaysValue[i] = false;
        }
      }
    });
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

// class WeeklyRepeatCheckboxes extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return WeeklyRepeatCheckboxesState();
//   }
// }

// class WeeklyRepeatCheckboxesState extends State<WeeklyRepeatCheckboxes> {
//   List<bool> _data = [false, false, false, false, false, false, false];
//   List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//   @override
//   Widget build(BuildContext context) {
//     return _buildCheckBoxes();
//   }

//   Widget _buildCheckBoxes() {
//     List<Widget> list = new List();
//     Widget cb;

//     for (int i = 0; i < _data.length; i++) {
//       cb = Checkbox(
//         value: _data[i],
//         onChanged: (bool value) {
//           setState(() {
//             // need to update _data[?]
//             _data[i] = value;
//           });
//         },
//       );
//       Widget cbR = SizedBox(
//           width: 80,
//           child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [Text(_days[i]), cb]));
//       list.add(cbR);
//     }
//     return Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(color: Colors.grey, spreadRadius: 1),
//           ],
//         ),
//         padding: EdgeInsets.only(left: 15.0),
//         margin: EdgeInsets.only(top: 30.0),
//         width: double.infinity,
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           // Container(
//           //   margin: EdgeInsets.only(top: 20),
//           // ),
//           // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           //   Text('Repeat', style: TextStyle(fontSize: 19, color: Colors.grey[600]))
//           // ]),
//           Container(
//               decoration: BoxDecoration(
//                 border: Border(
//                     bottom: BorderSide(
//                   color: Colors.grey,
//                   width: 1.0,
//                 )),
//               ),
//               width: 120,
//               child: ListTileTheme(
//                   contentPadding: EdgeInsets.all(0),
//                   child: CheckboxListTile(
//                     title: Text("Repeat"),
//                     value: true,
//                     onChanged: (newValue) {
//                       setState(() {
//                         //  checkedValue = newValue;
//                       });
//                     },
//                     controlAffinity: ListTileControlAffinity
//                         .trailing, //  <-- leading Che ckbox
//                   ))),
//           Wrap(
//             direction: Axis.horizontal,
//             crossAxisAlignment: WrapCrossAlignment.start,
//             spacing: 5,
//             runSpacing: 5,
//             children: list,
//           )
//         ]));

//     // return Row(
//     //     mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: list);
//   }
// }
