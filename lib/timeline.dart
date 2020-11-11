import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/providers/home_tab_provider.dart';
import 'package:second_attempt/providers/todo_provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ProjectTimeline extends StatefulWidget {
  ProjectTimeline() {}
  @override
  _ProjectTimelineState createState() => _ProjectTimelineState();
}

class _ProjectTimelineState extends State<ProjectTimeline> {
  ScrollController controller;
  List<Todo> finishedTodos = [];
  @override
  Widget build(BuildContext context) {
    finishedTodos = Provider.of<TodoProvider>(context, listen: false)
        .getTasksByLevel(TodoStatus.finished, 'all');
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Timeline')),
        ),
        body: Consumer<TodoProvider>(builder: (context, todoProvider, child) {
          finishedTodos =
              todoProvider.getTasksByLevel(TodoStatus.finished, 'all');
          return Scrollbar(
            child: new ListView.builder(
              controller: controller,
              itemBuilder: (context, index) {
                return projectTimelineTile(index);
              },
              itemCount: finishedTodos.length,
            ),
          );
        }));
  }

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    print(controller.position.extentAfter);
    if (controller.position.extentAfter < 500) {
      setState(() {
        //finishedTodos.addAll());
      });
    }
  }

  Widget projectTimelineTile(int index) {
    if (index == 0 ||
        (this.finishedTodos[index].finishedAt.day !=
            this.finishedTodos[index - 1].finishedAt.day)) {
      return TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0.3,
        isFirst: true,
        endChild: Container(
            constraints: const BoxConstraints(
              minHeight: 100,
            ),
            // color: Colors.lightGreenAccent,
            child: Column(children: [
              Text(this.finishedTodos[index].title),
              Text(Provider.of<HomeTabProvider>(context, listen: true)
                  .getProject(this.finishedTodos[index].projectId)
                  .title),
            ])),
        startChild: Container(
          child: Text(DateFormat('MM:dd kk:mm')
              .format(this.finishedTodos[index].finishedAt)),
          // color: Colors.amberAccent,
        ),
      );
    } else if (index == this.finishedTodos.length - 1 ||
        (this.finishedTodos[index].finishedAt.day !=
            this.finishedTodos[index + 1].finishedAt.day)) {
      return TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0.3,
        isLast: true,
        endChild: Container(
            constraints: const BoxConstraints(
              minHeight: 100,
            ),
            // color: Colors.lightGreenAccent,
            child: Column(children: [
              Text(this.finishedTodos[index].title),
              Text(Provider.of<HomeTabProvider>(context, listen: true)
                  .getProject(this.finishedTodos[index].projectId)
                  .title),
            ])),
        startChild: Container(
          child: Text(
              DateFormat('kk:mm').format(this.finishedTodos[index].finishedAt)),
          // color: Colors.amberAccent,
        ),
      );
    } else {
      return TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0.3,
        endChild: Container(
            constraints: const BoxConstraints(
              minHeight: 100,
            ),
            // color: Colors.lightGreenAccent,
            child: Column(children: [
              Text(this.finishedTodos[index].title),
              Text(Provider.of<HomeTabProvider>(context, listen: true)
                  .getProject(this.finishedTodos[index].projectId)
                  .title),
            ])),
        startChild: Container(
          child: Text(
              DateFormat('kk:mm').format(this.finishedTodos[index].finishedAt)),
          // color: Colors.amberAccent,
        ),
      );
    }
  }
}
