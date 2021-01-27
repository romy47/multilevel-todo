import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/helpers/todo_helper.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/providers/todo_provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, _) => ProjectTimeline(
          todoProvider: todoProvider,
        ),
      ),
    );
  }
}

class ProjectTimeline extends StatefulWidget {
  final TodoProvider todoProvider;
  const ProjectTimeline({
    @required this.todoProvider,
    Key key,
  }) : super(key: key);

  @override
  _ProjectTimelineState createState() => _ProjectTimelineState();
}

class _ProjectTimelineState extends State<ProjectTimeline> {
  ScrollController controller;
  // List<Project> projects = [];
  @override
  Widget build(BuildContext context) {
    if (widget.todoProvider.finishedTodos.length > 0) {
      print('First Finished Data' +
          widget.todoProvider.finishedTodos.length.toString());
    }
    // return Consumer<List<Project>>(builder: (context, projects, child) {
    return ListView(
      controller: controller,
      children: [
        ...widget.todoProvider.finishedTodos
            .map((todo) => projectTimelineTile(
                widget.todoProvider.finishedTodos.indexOf(todo), todo))
            .toList(),
        if (widget.todoProvider.hasNext)
          Center(
            child: GestureDetector(
              onTap: widget.todoProvider.fetchNextTodos,
              child: Container(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
    // });
  }

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    widget.todoProvider.fetchNextTodos();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent / 2 &&
        !controller.position.outOfRange) {
      if (widget.todoProvider.hasNext) {
        widget.todoProvider.fetchNextTodos();
      }
    }
  }

  Widget projectTimelineTile(int index, Todo todo) {
    if (widget.todoProvider.finishedTodos.length == 1) {
      print('size one');
      return midsinTimeline(todo);
    } else {
      print('size more than one');
      if (index == 0) {
        print('index 0');
        if (TodoHelper.isSameDay(todo.finishedAt,
            this.widget.todoProvider.finishedTodos[index + 1].finishedAt)) {
          print('index 0: same next');
          return firstTimeline(todo);
        } else {
          print('index 0: different next');
          return midsinTimeline(todo);
        }
      } else if (index == this.widget.todoProvider.finishedTodos.length - 1) {
        print('index last');
        if (TodoHelper.isSameDay(todo.finishedAt,
            this.widget.todoProvider.finishedTodos[index - 1].finishedAt)) {
          print('index last: same prev');
          return lastTimeline(todo);
        } else {
          print('index last: different prev');
          return midsinTimeline(todo);
        }
      } else if (TodoHelper.isSameDay(todo.finishedAt,
          this.widget.todoProvider.finishedTodos[index - 1].finishedAt)) {
        print('index mid: same first');
        if (TodoHelper.isSameDay(todo.finishedAt,
            this.widget.todoProvider.finishedTodos[index + 1].finishedAt)) {
          print('index mid: same first: same last');

          return midConTimeline(todo);
        } else {
          print('index mid: same first: diff last');
          return lastTimeline(todo);
        }
      } else {
        print('index mid: diff first');
        if (TodoHelper.isSameDay(todo.finishedAt,
            this.widget.todoProvider.finishedTodos[index + 1].finishedAt)) {
          print('index mid: diff first: same last');
          return firstTimeline(todo);
        } else {
          print('index mid: diff first: diff last');
          return midsinTimeline(todo);
        }
      }
    }
  }

  Widget lastTimeline(Todo todo) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      // padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.blueGrey[200]),
          bottom: BorderSide(color: Colors.blueGrey[200]),
          right: BorderSide(color: Colors.blueGrey[200]),
        ),
      ),
      child: TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0.4,
        indicatorStyle: IndicatorStyle(
          width: 25,
          color: Colors.green[300],
          padding: const EdgeInsets.all(8),
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: Icons.check,
          ),
        ),
        isLast: true,
        beforeLineStyle: const LineStyle(
          color: Colors.green,
          thickness: 3,
        ),
        endChild: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.blueGrey[200]),
                // bottom: BorderSide(color: Colors.blueGrey[200]),
              ),
              // borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            constraints: const BoxConstraints(
              minHeight: 80,
            ),
            // color: Colors.lightGreenAccent,
            child: finishedTodo(todo)),
        startChild: Container(
          padding: EdgeInsets.all(8.0),

          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(DateFormat.yMMMd('en_US').format(todo.finishedAt)),
                Text(DateFormat.jm().format(todo.finishedAt),
                    style: TextStyle(fontSize: 16)),
              ]),
          // color: Colors.amberAccent,
        ),
      ),
    );
  }

  Widget midConTimeline(Todo todo) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      // padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.blueGrey[200]),
          right: BorderSide(color: Colors.blueGrey[200]),
        ),
      ),
      child: TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0.4,
        indicatorStyle: IndicatorStyle(
          width: 25,
          color: Colors.green[300],
          padding: const EdgeInsets.all(8),
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: Icons.check,
          ),
        ),
        afterLineStyle: const LineStyle(
          color: Colors.green,
          thickness: 3,
        ),
        beforeLineStyle: const LineStyle(
          color: Colors.green,
          thickness: 3,
        ),
        endChild: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.blueGrey[200]),
                // bottom: BorderSide(color: Colors.blueGrey[200]),
              ),
              // borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            constraints: const BoxConstraints(
              minHeight: 80,
            ),
            // color: Colors.lightGreenAccent,
            child: finishedTodo(todo)),
        startChild: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(DateFormat.yMMMd('en_US').format(todo.finishedAt)),
                Text(DateFormat.jm().format(todo.finishedAt),
                    style: TextStyle(fontSize: 16)),
              ]),
          // color: Colors.amberAccent,
        ),
      ),
    );
  }

  Widget midsinTimeline(Todo todo) {
    print('Chip Todo ' + todo.toString());
    return Container(
      margin: const EdgeInsets.all(8.0),
      // padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey[200]),
        // borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0.4,
        indicatorStyle: IndicatorStyle(
          width: 25,
          color: Colors.green[300],
          padding: const EdgeInsets.all(8),
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: Icons.check,
          ),
        ),
        beforeLineStyle: const LineStyle(
          color: Colors.white,
          thickness: 0,
        ),
        endChild: Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.all(8.0),
            constraints: const BoxConstraints(
              minHeight: 80,
            ),
            // color: Colors.lightGreenAccent,
            child: finishedTodo(todo)),
        startChild: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    DateFormat.yMMMd('en_US').format(todo.finishedAt),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  margin: EdgeInsets.only(bottom: 6.0),
                ),
                Text(DateFormat.jm().format(todo.finishedAt),
                    style: TextStyle(fontSize: 16)),
              ]),
          // color: Colors.amberAccent,
        ),
      ),
    );
  }

  Widget firstTimeline(Todo todo) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      // padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.blueGrey[200]),
          top: BorderSide(color: Colors.blueGrey[200]),
          right: BorderSide(color: Colors.blueGrey[200]),
        ),
      ),
      child: TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0.4,
        afterLineStyle: const LineStyle(
          color: Colors.green,
          thickness: 3,
        ),
        isFirst: true,
        indicatorStyle: IndicatorStyle(
          width: 25,
          color: Colors.green[300],
          padding: const EdgeInsets.all(8),
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: Icons.check,
          ),
        ),
        endChild: Container(
            padding: EdgeInsets.all(8.0),
            constraints: const BoxConstraints(
              minHeight: 80,
            ),
            // color: Colors.lightGreenAccent,
            child: finishedTodo(todo)),
        startChild: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      DateFormat.yMMMd('en_US').format(todo.finishedAt),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    margin: EdgeInsets.only(bottom: 6.0),
                  ),
                  Text(DateFormat.jm().format(todo.finishedAt),
                      style: TextStyle(fontSize: 16)),
                ])),
        // color: Colors.amberAccent,
        // ),
      ),
    );
  }

  Widget finishedTodo(Todo todo) {
    print('Chip Level' + todo.title);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          child: Text(
            todo.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          // margin: EdgeInsets.only(top: 1),
        ),
        Transform(
          transform: new Matrix4.identity()..scale(0.8),
          alignment: FractionalOffset.centerRight,
          child: Chip(
              backgroundColor: new Color(todo.projectColor),
              // label: Text(todo.title),
              label: RichText(
                text: TextSpan(
                  text: todo.projectTitle,
                  style: TextStyle(
                    color: Colors.white,
                    // decoration: TextDecoration.lineThrough,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '', style: TextStyle(color: Colors.red)),
                    // TextSpan(text: ' world!'),
                  ],
                ),
              )),
        )
      ],
    );
  }
}
