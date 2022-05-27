import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/helpers/todo_helper.dart';
import 'package:second_attempt/helpers/tutorial_helper.dart';
import 'package:second_attempt/models/common.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/providers/todo_provider.dart';
import 'package:second_attempt/screens/edit_todo_screen/edit_todo_screen.dart';
import 'package:second_attempt/screens/projects_tab_screen/projects_tab_screen.dart';
import 'package:second_attempt/services/database_service.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';

class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
  const Tutorial();
}

class _TutorialState extends State<Tutorial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        onStart: (index, key) {
          print('onStart: $index, $key');
        },
        onComplete: (index, key) {
          print('onComplete: $index, $key');
        },
        builder: Builder(builder: (context) => TutorialContent()),
        autoPlay: false,
        autoPlayDelay: Duration(seconds: 3),
        autoPlayLockEnable: false,
      ),
    );
  }
}

class TutorialContent extends StatefulWidget {
  const TutorialContent();
  @override
  _TutorialContentState createState() => _TutorialContentState();
}

class _TutorialContentState extends State<TutorialContent> {
  int initPosition = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey one = GlobalKey();
    GlobalKey two = GlobalKey();
    GlobalKey three = GlobalKey();
    GlobalKey four = GlobalKey();
    GlobalKey five = GlobalKey();
    GlobalKey six = GlobalKey();
    GlobalKey seven = GlobalKey();
    List<GlobalKey> keys = [one, two, three, four, five, six, seven];
    List<Project> projects = TutorialHelper.getProjects();
    List<Todo> todos = TutorialHelper.getTodos();
    todos.forEach((td) {
      Provider.of<TodoProvider>(context, listen: false).addNewTodo(td);
    });
    // List<Todo> todos = TutorialHelper.getTodos();
//     Timer timer = new Timer(new Duration(seconds: 5), () {
//    debugPrint("Print after 5 seconds");
// });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => new Timer(new Duration(seconds: 3), () {
              ShowCaseWidget.of(context)
                  .startShowCase([one, two, three, four, five, six]);
            }));

    return KeysToBeInherited(
        one: one,
        two: two,
        three: three,
        four: four,
        five: five,
        six: six,
        seven: seven,
        projects: projects,
        todos: todos,
        child: Scaffold(
          appBar: new AppBar(
            title: new Text(
              "Skip",
              style: new TextStyle(color: Colors.white),
            ),
          ),
          body: CustomTabView(
            initPosition: initPosition,
            itemCount: projects.length,
            tabBuilder: (context, index) => Tab(
              child: Text(projects[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: new Color(projects[index].color))),
            ),
            pageBuilder: (context, index) => Center(
                // child: Text(projects[index].title)),
                child: TabInside(projects[index].id)),
            onPositionChange: (index) {
              initPosition = index;
            },
            onScroll: (position) => print('$position'),
          ),
          floatingActionButton: Showcase(
              key: two,
              title: 'Create Todo',
              description: 'New todo can be created from this button.',
              shapeBorder: CircleBorder(),
              child: Container(
                  // margin: EdgeInsets.only(bottom: 50.0),
                  child: FloatingActionButton(
                onPressed: () => {},
                tooltip: 'Add Todo',

                // contentPadding: EdgeInsets.only(bottom: 70.0),
                child: Icon(Icons.add),
              )
                  // Icon(Icons.add),
                  )),
        ));
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
        Showcase(
            key: KeysToBeInherited.of(context).one,
            title: 'Projects',
            titleTextStyle:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // textColor: Colors.blue[700],
            description:
                "All of your todos are grouped by different projects. \n Click on a project to see only it's own todos.",
            child: Container(
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
            )),
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

class TabInside extends StatefulWidget {
  final String projectId;
  TabInside(this.projectId);
  @override
  _TabInsideState createState() => _TabInsideState();
}

class _TabInsideState extends State<TabInside> {
  bool onGoingHighlighted = false;
  bool todoHighlighted = false;
  bool finishedHighlighted = false;
  // final String projectId = '1';
  final List<Project> projects = TutorialHelper.getProjects();
  // List<Todo> statetodos = [];
  // List<Todo> statetodosTodo = [];
  // List<Todo> statetodosOnGoing = [];
  // List<Todo> statetodosFinished = [];
  @override
  Widget build(BuildContext context) {
    var keyTwo = (widget.projectId == '1')
        ? KeysToBeInherited.of(context).two
        : GlobalKey();

    // setState(() {
    //   statetodos = KeysToBeInherited.of(context).todos;
    //   statetodosTodo = TodoHelper.getTasksWithProjectByLevel(projects,
    //       (todos == null) ? [] : statetodos, TodoStatus.todo, widget.projectId);
    //   statetodosOnGoing = TodoHelper.getTasksWithProjectByLevel(
    //       projects,
    //       (todos == null) ? [] : statetodos,
    //       TodoStatus.onGoing,
    //       widget.projectId);
    //   statetodosFinished = TodoHelper.getTasksWithProjectByLevel(
    //       projects,
    //       (todos == null) ? [] : statetodos,
    //       TodoStatus.finished,
    //       widget.projectId);
    // });

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              flex: 2,
              child: Showcase(
                key: (widget.projectId == '1')
                    ? KeysToBeInherited.of(context).five
                    : GlobalKey(),
                title: "Today's Todos",
                description: 'Dragging a todo in here will make it due today.',
                child: Showcase(
                    key: KeysToBeInherited.of(context).six,
                    title: "Drag a To-do item",
                    // titleTextStyle:
                    //     TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // textColor: Colors.blue[700],
                    description:
                        "Drag a to-do form 'toda's goal' section to  \n 'upcoming todos' section.",
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                          boxShadow: [
                            onGoingHighlighted
                                ? BoxShadow(
                                    color: Colors.green.withOpacity(0.2),
                                    spreadRadius: 10,
                                    blurRadius: 7,
                                    offset: Offset(
                                        6, 1), // changes position of shadow
                                  )
                                : BoxShadow(
                                    color: Colors.green.withOpacity(0),
                                    spreadRadius: 0,
                                    blurRadius: 0,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                          ],
                        ),
                        width: double.maxFinite,
                        child: DragTarget(onWillAccept: (data) {
                          setState(() {
                            onGoingHighlighted = true;
                          });
                          return true;
                        }, onLeave: (data) {
                          setState(() {
                            onGoingHighlighted = false;
                          });
                          return true;
                        }, onAccept: (data) {
                          setState(() {
                            Todo todo = new DatabaseServices(
                                    FirebaseAuth.instance.currentUser.uid)
                                .changeTodoSTatus(
                                    data, TodoStatus.onGoing, false);
                            print('###########' + todo.toString());
                            Provider.of<TodoProvider>(context, listen: false)
                                .changeTodoSTatusTutorial(todo);
                          });
                        }, builder: (BuildContext context, List<Todo> incoming,
                            rejected) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.maxFinite,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Today's Goal",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ),
                              // Container()
                              onGoing(context)
                            ],
                          );
                        }))),
              )),
          Expanded(
            // fit: FlexFit.tight,
            flex: 4,
            child: Showcase(
                key: (widget.projectId == '1')
                    ? KeysToBeInherited.of(context).four
                    : GlobalKey(),
                title: 'Upcoming Todos',
                description:
                    'Dragging a todo in here will change the due \n date to be tommorrow.',
                child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                      boxShadow: [
                        todoHighlighted
                            ? BoxShadow(
                                color: Colors.green.withOpacity(0.2),
                                spreadRadius: 10,
                                blurRadius: 7,
                                offset:
                                    Offset(6, 1), // changes position of shadow
                              )
                            : BoxShadow(
                                color: Colors.green.withOpacity(0),
                                spreadRadius: 0,
                                blurRadius: 0,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                      ],
                    ),
                    width: double.maxFinite,
                    child: DragTarget(onWillAccept: (data) {
                      setState(() {
                        todoHighlighted = true;
                      });
                      return true;
                    }, onLeave: (data) {
                      setState(() {
                        todoHighlighted = false;
                      });
                      return true;
                    }, onAccept: (data) {
                      setState(() {
                        todoHighlighted = false;

                        Todo todo = new DatabaseServices(
                                FirebaseAuth.instance.currentUser.uid)
                            .changeTodoSTatus(data, TodoStatus.todo, false);
                        print('###########' + todo.toString());
                        Provider.of<TodoProvider>(context, listen: false)
                            .changeTodoSTatusTutorial(todo);
                      });
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => new Timer(new Duration(seconds: 1), () {
                                ShowCaseWidget.of(context).startShowCase(
                                    [KeysToBeInherited.of(context).seven]);
                              }));
                    }, builder:
                        (BuildContext context, List<Todo> incoming, rejected) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Upcoming Todos",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                          todos(context),
                        ],
                      );
                    }))),
          ),
          Expanded(
              // fit: FlexFit.tight,
              flex: 2,
              child: Showcase(
                  key: (widget.projectId == '1')
                      ? KeysToBeInherited.of(context).three
                      : GlobalKey(),
                  title: 'Completed Todos',
                  description:
                      'Dragging a todo in here will mark it as completed.',
                  child: Showcase(
                      key: KeysToBeInherited.of(context).seven,
                      title: "Finish a To-do",
                      // titleTextStyle:
                      //     TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      // textColor: Colors.blue[700],
                      description:
                          "Drag a to-do to this section when it is done.",
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                            boxShadow: [
                              finishedHighlighted
                                  ? BoxShadow(
                                      color: Colors.green.withOpacity(0.2),
                                      spreadRadius: 10,
                                      blurRadius: 7,
                                      offset: Offset(
                                          6, 1), // changes position of shadow
                                    )
                                  : BoxShadow(
                                      color: Colors.green.withOpacity(0),
                                      spreadRadius: 0,
                                      blurRadius: 0,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                            ],
                          ),
                          width: double.maxFinite,
                          child: DragTarget(onWillAccept: (data) {
                            setState(() {
                              finishedHighlighted = true;
                            });
                            return true;
                          }, onAccept: (data) {
                            setState(() {
                              todoHighlighted = false;

                              Todo todo = new DatabaseServices(
                                      FirebaseAuth.instance.currentUser.uid)
                                  .changeTodoSTatus(
                                      data, TodoStatus.finished, false);
                              print('###########' + todo.toString());
                              Provider.of<TodoProvider>(context, listen: false)
                                  .changeTodoSTatusTutorial(todo);
                            });
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          'You have completed the Tutoarial. Now lets create some To-do`s.',
                                    ),
                                  ],
                                ),
                              ),
                              backgroundColor: Colors.blue[500],
                            ));
                            WidgetsBinding.instance.addPostFrameCallback(
                                (_) => new Timer(new Duration(seconds: 2), () {
                                      Navigator.pop(context);
                                      // Navigator.push(
                                      //     context
                                      // MaterialPageRoute(
                                      //     builder: (context) => ProjectsTab()));
                                    }));
                          }, onLeave: (data) {
                            setState(() {
                              finishedHighlighted = false;
                            });
                            return true;
                          }, builder: (BuildContext context,
                              List<Todo> incoming, rejected) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.maxFinite,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    "Finished Today",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),
                                // Container(),
                                finished(context),
                              ],
                            );
                          }))))),
        ],
      ),
    );
  }

  Widget todos(BuildContext context) {
    List<Project> projects = KeysToBeInherited.of(context).projects;
    return Consumer<List<Project>>(builder: (context, todos, child) {
      List<Todo> statetodosTodo =
          Provider.of<TodoProvider>(context, listen: false)
              .getTasksByLevel(TodoStatus.todo, 'all', projects);
      return Expanded(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            width: double.infinity,
            child: (statetodosTodo.length > 0)
                ? Wrap(
                    children: statetodosTodo
                        .map((e) => Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 5.0),
                              child: Draggable(
                                data: e,
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: todoChip(e, new Color(e.projectColor),
                                      context, false),
                                ),
                                child: todoChip(e, new Color(e.projectColor),
                                    context, false),
                                childWhenDragging: todoChip(e,
                                    new Color(e.projectColor), context, true),
                              ),
                            ))
                        .toList()
                        .cast<Widget>(),
                  )
                : getPlaceholderText("No upcoming task available")
            // });
            ),
      ));
    });
  }

  Widget onGoing(BuildContext context) {
    return Consumer<List<Project>>(builder: (context, todos, child) {
      List<Todo> statetodosOnGoing =
          Provider.of<TodoProvider>(context, listen: false)
              .getTasksByLevel(TodoStatus.onGoing, 'all', projects);
      return Expanded(
          // fit: FlexFit.tight,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  width: double.infinity,
                  child: (statetodosOnGoing.length > 0)
                      ? Wrap(
                          children: statetodosOnGoing
                              .map((e) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 5.0),
                                    child: Draggable(
                                      data: e,
                                      feedback: Material(
                                        color: Colors.transparent,
                                        child: ongoingChip(e, context, false),
                                      ),
                                      child: ongoingChip(e, context, false),
                                      childWhenDragging:
                                          ongoingChip(e, context, true),
                                    ),
                                  ))
                              .toList()
                              .cast<Widget>(),
                        )
                      : getPlaceholderText('No task is due today'))
              // }),
              ));
    });
  }

  Widget finished(BuildContext context) {
    List<Project> projects = KeysToBeInherited.of(context).projects;
    return Consumer<List<Project>>(builder: (context, todos, child) {
      List<Todo> finishedTodo =
          Provider.of<TodoProvider>(context, listen: false)
              .getTasksByLevel(TodoStatus.finished, 'all', projects);
      return Expanded(
          // fit: FlexFit.tight,
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            width: double.infinity,
            child: (finishedTodo.length > 0)
                ? Wrap(
                    children: finishedTodo
                        .map((e) => Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 5.0),
                              child: finishedChip(e, context, false),
                            ))
                        .toList()
                        .cast<Widget>(),
                  )
                : getPlaceholderText('No task is done today')

            // })
            ),
      ));
    });
  }

  Widget ongoingChip(Todo todo, BuildContext context, bool isDragging) {
    return InkWell(
        child: Chip(
            shape: StadiumBorder(
                side: BorderSide(
                    color: isDragging
                        ? Colors.grey[300]
                        : new Color(todo.projectColor),
                    width: 2.0)),
            backgroundColor: Colors.white,
            label: RichText(
              text: TextSpan(
                text: todo.title,
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(text: '', style: TextStyle(color: Colors.red)),
                ],
              ),
            )),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditTodoWrapper(todo, AlertStatus.today.value)));
        });
  }

  Widget finishedChip(Todo todo, BuildContext context, bool isDragging) {
    return InkWell(
        child: Chip(
            shape: StadiumBorder(
                side: BorderSide(
                    color: isDragging
                        ? Colors.grey[300]
                        : new Color(todo.projectColor),
                    width: 2.0)),
            backgroundColor: Colors.white,
            label: RichText(
              text: TextSpan(
                text: todo.title,
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.lineThrough,
                ),
                children: <TextSpan>[
                  TextSpan(text: '', style: TextStyle(color: Colors.red)),
                ],
              ),
            )),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditTodoWrapper(todo, AlertStatus.finished.value)));
        });
  }

  Widget todoChip(
      Todo todo, Color color, BuildContext context, bool isDragging) {
    int days = TodoHelper.getDifferenceInDaysFromToday(todo.due);
    return Stack(
      children: <Widget>[
        InkWell(
            child: Chip(
              backgroundColor: Colors.white,
              avatar: TodoHelper.isOverDue(todo.due)
                  ? CircleAvatar(
                      backgroundColor:
                          isDragging ? Colors.grey[400] : Colors.red[300],
                      child: new IconTheme(
                        data: new IconThemeData(color: Colors.white),
                        child: Icon(Icons.priority_high),
                      ),
                    )
                  : null,
              shape: StadiumBorder(
                  side: BorderSide(
                      color: isDragging
                          ? Colors.grey[300]
                          : new Color(todo.projectColor),
                      width: 2.0)),
              label: RichText(
                text: TextSpan(
                  text: todo.title,
                  style: TextStyle(color: Colors.black),
                  children: <TextSpan>[],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditTodoWrapper(
                          todo,
                          TodoHelper.isOverDue(todo.due)
                              ? AlertStatus.overdue.value
                              : AlertStatus.future.value)));
            }),
        new Positioned(
          right: 0,
          top: 0,
          child: new Container(
            padding: EdgeInsets.all(3),
            decoration: new BoxDecoration(
              color: ((days > 0) ? Colors.green : Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: new Text(
              days.toString(),
              style: new TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  Widget getPlaceholderText(String message) {
    return Container(
        margin: EdgeInsets.only(top: 14.0),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ));
  }
}

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey one;
  final GlobalKey two;
  final GlobalKey three;
  final GlobalKey four;
  final GlobalKey five;
  final GlobalKey six;
  final GlobalKey seven;
  final List<Project> projects;
  final List<Todo> todos;
  KeysToBeInherited({
    this.one,
    this.two,
    this.three,
    this.four,
    this.five,
    this.six,
    this.seven,
    this.projects,
    this.todos,
    Widget child,
  }) : super(child: child);

  static KeysToBeInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KeysToBeInherited>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
}
