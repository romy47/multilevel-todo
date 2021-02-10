import 'package:flutter/material.dart';
import 'package:second_attempt/models/project_model.dart';
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
    List<Project> projects = [
      Project('All', 'all', Colors.black.value, 'all'),
      Project('Lol', 'Lol', Colors.black.value, 'Lol'),
      Project('Saoul', 'Saoul', Colors.black.value, 'Saoul'),
    ];
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase([one]));
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
                        color: new Color(projects[index].color)))),
            pageBuilder: (context, index) => Center(child: TabInside()),
            onPositionChange: (index) {
              initPosition = index;
            },
            onScroll: (position) => print('$position'),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () => {},
              tooltip: 'Add Todo',
              child: Showcase(
                key: one,
                description: 'sadasd',
                child: Icon(Icons.add),
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

class TabInside extends StatefulWidget {
  @override
  _TabInsideState createState() => _TabInsideState();
}

class _TabInsideState extends State<TabInside> {
  int initPosition = 0;

  @override
  Widget build(BuildContext context) {
    var keyTwo = KeysToBeInherited.of(context).two;

    return Showcase(
      child: RaisedButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ShowCaseWidget.of(context).startShowCase([keyTwo]));
        },
      ),
      description: 'asasas',
      key: KeysToBeInherited.of(context).two,
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
