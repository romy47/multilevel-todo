import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:second_attempt/create_todo.dart';
import 'package:second_attempt/home.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/projects.dart';
import 'package:second_attempt/providers/home_tab_provider.dart';
import 'package:second_attempt/providers/todo_provider.dart';

import 'models/todo_model.dart';

class TabbedHomeScreen extends StatelessWidget {
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
        return CustomTabView(
          initPosition: initPosition,
          itemCount: tabProvider.projects.length,
          tabBuilder: (context, index) =>
              Tab(text: tabProvider.projects[index].title),
          pageBuilder: (context, index) => Center(
              // child: Text(tabProvider.projects[index].title)
              child: HomeScreen(tabProvider.projects[index].id)),
          onPositionChange: (index) {
            print('current position: $index');
            initPosition = index;
          },
          onScroll: (position) => print('$position'),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          // Provider.of<HomeTabProvider>(context, listen: false).addTab('huhu')
          _openPopup(context)
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

  _openPopup(context) {
    final _todoTitleTextController = TextEditingController();
    Alert(
        context: context,
        title: "Create Todo",
        content: Column(
          children: <Widget>[
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
            ProjectDropDown()
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => {
              Navigator.pop(context),
              Provider.of<TodoProvider>(context, listen: false).addNewTodo(Todo(
                  _todoTitleTextController.text,
                  Provider.of<TodoProvider>(context, listen: false)
                      .selectedProjectId,
                  _todoTitleTextController.text,
                  TodoStatus.todo)),
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('"' +
                      _todoTitleTextController.text +
                      '" is added as a Todo')))
            },
            child: Text(
              "Create",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
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

class ProjectDropDown extends StatefulWidget {
  @override
  _ProjectDropDownState createState() => _ProjectDropDownState();
}

class _ProjectDropDownState extends State<ProjectDropDown> {
  List<Project> projects;
  String selectedProjectId;
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabProvider>(builder: (context, tabProvider, child) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: DropdownButton<String>(
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
              this.setState(() {
                selectedProjectId = newVal;
                Provider.of<TodoProvider>(context, listen: false)
                    .selectProjectId(newVal);
              });
            }),
      );
    });
    ;
  }
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
