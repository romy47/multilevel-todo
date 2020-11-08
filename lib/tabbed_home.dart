import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:second_attempt/home.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/projects.dart';
import 'package:second_attempt/providers/home_tab_provider.dart';
import 'package:second_attempt/providers/todo_provider.dart';

import 'models/todo_model.dart';

class TabbedHomeScreen extends StatefulWidget {
  @override
  _TabbedHomeScreenState createState() => _TabbedHomeScreenState();
}

class _TabbedHomeScreenState extends State<TabbedHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Starting');
    List<String> data = ['Page 0', 'Page 1', 'Page 2'];
    int initPosition = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Awesome Todo'),
      ),
      body: Consumer<HomeTabProvider>(builder: (context, tabProvider, child) {
        List<Project> projects = [
          Project('All', 'all', Colors.black.value),
          ...tabProvider.projects
        ];
        return CustomTabView(
          initPosition: initPosition,
          itemCount: projects.length,
          tabBuilder: (context, index) => Tab(
              child: Text(projects[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: new Color(projects[index].color)))),
          pageBuilder: (context, index) => Center(
              // child: Text(projects[index].title)
              child: HomeScreen(projects[index].id)),
          onPositionChange: (index) {
            print('current position: $index');
            initPosition = index;
          },
          onScroll: (position) => print('$position'),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          // _openPopup(context)
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return NewTodoAlert();
              })
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('User Name'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Projects'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Projects()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    @required this.itemCount,
    @required this.tabBuilder,
    @required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  TabController controller;
  int _currentCount;
  int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            tabs: List.generate(
              widget.itemCount,
              (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation.value);
    }
  }
}

class NewTodoAlert extends StatefulWidget {
  @override
  _NewTodoAlertState createState() => _NewTodoAlertState();
}

class _NewTodoAlertState extends State<NewTodoAlert> {
  String selectedProjectId;
  String selectedDueDateOption;
  String selectedRepeat;
  DateTime selectedDueDate = new DateTime.now();
  final _todoTitleTextController = TextEditingController();
  List<String> repeatOptions = ['Daily', 'Weekly'];
  List<String> dueDateOptions = ['Today', 'Tomorrow', 'Next Week', 'Pick Date'];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Column(children: [
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
                  _todoTitleTextController.text,
                  this.selectedProjectId,
                  _todoTitleTextController.text,
                  TodoStatus.todo)),
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('"' +
                      _todoTitleTextController.text +
                      '" is added as a Todo')))
            },
            child: Text('Create Todo'),
          )
        ]),
      ),
    );
  }

  Widget projectDropDown(context) {
    return Consumer<HomeTabProvider>(builder: (context, tabProvider, child) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: DropdownButton<String>(
            value: selectedProjectId,
            isExpanded: true,
            items: tabProvider.projects.map((Project project) {
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
                    tabProvider.projects
                        .firstWhere(
                            (project) => project.id == selectedProjectId)
                        .title,
                    style: TextStyle(color: Colors.blue),
                  ),
            onChanged: (newVal) {
              setState(() {
                selectedProjectId = newVal;
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
