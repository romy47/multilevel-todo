import 'dart:async';

import 'package:flutter/material.dart';
import 'package:second_attempt/helpers/tutorial_helper.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/models/todo_model.dart';
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
    List<GlobalKey> keys = [one, two, three];
    List<Project> projects = TutorialHelper.getProjects();
//     Timer timer = new Timer(new Duration(seconds: 5), () {
//    debugPrint("Print after 5 seconds");
// });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => new Timer(new Duration(seconds: 3), () {
              ShowCaseWidget.of(context).startShowCase([one, two, three]);
            }));

    return KeysToBeInherited(
        one: one,
        two: two,
        three: three,
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
                child: TabInside()),
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
  @override
  _TabInsideState createState() => _TabInsideState();
}

class _TabInsideState extends State<TabInside> {
  bool onGoingHighlighted = false;
  bool todoHighlighted = false;
  bool finishedHighlighted = false;
  final String projectId = 'all';
  final List<Project> projects = TutorialHelper.getProjects();

  @override
  Widget build(BuildContext context) {
    var keyTwo = KeysToBeInherited.of(context).two;

    // return Showcase(
    //   child: RaisedButton(
    //     child: Icon(Icons.play_arrow),
    //     onPressed: () {
    //       WidgetsBinding.instance.addPostFrameCallback(
    //           (_) => ShowCaseWidget.of(context).startShowCase([keyTwo]));
    //     },
    //   ),
    //   description: 'asasas',
    //   key: KeysToBeInherited.of(context).two,
    // );
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 2,
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
                            offset: Offset(6, 1), // changes position of shadow
                          )
                        : BoxShadow(
                            color: Colors.green.withOpacity(0),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                  ],
                ),
                width: double.maxFinite,
                child: DragTarget(
                    onWillAccept: (data) {
                      setState(() {
                        onGoingHighlighted = true;
                      });
                      return true;
                    },
                    onLeave: (data) {
                      setState(() {
                        onGoingHighlighted = false;
                      });
                      return true;
                    },
                    onAccept: (data) {},
                    builder:
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
                              "Today's Goal",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                          Container()
                        ],
                      );
                    })),
          ),
          Expanded(
            // fit: FlexFit.tight,
            flex: 4,
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
                            offset: Offset(6, 1), // changes position of shadow
                          )
                        : BoxShadow(
                            color: Colors.green.withOpacity(0),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(0, 0), // changes position of shadow
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
                  });
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
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      Container(),
                    ],
                  );
                })),
          ),
          Expanded(
              // fit: FlexFit.tight,
              flex: 2,
              child: Showcase(
                  key: KeysToBeInherited.of(context).three,
                  title: 'Completed Todos',
                  description:
                      'Dragging a todo in here will mark it as completed.',
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
                      child: DragTarget(
                          onWillAccept: (data) {
                            setState(() {
                              finishedHighlighted = true;
                            });
                            return true;
                          },
                          onAccept: (data) {},
                          onLeave: (data) {
                            setState(() {
                              finishedHighlighted = false;
                            });
                            return true;
                          },
                          builder: (BuildContext context, List<Todo> incoming,
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
                                    "Finished Today",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),
                                Container(),
                              ],
                            );
                          })))),
        ],
      ),
    );
  }
}

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey one;
  final GlobalKey two;
  final GlobalKey three;
  KeysToBeInherited({
    this.one,
    this.two,
    this.three,
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
