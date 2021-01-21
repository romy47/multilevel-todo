import 'package:second_attempt/helpers/todo_helper.dart';

class Todo {
  String id;
  String projectId;
  String title;
  String projectTitle;
  int projectColor;
  int status;
  DateTime due;
  int repeat;
  bool isRepeat;
  List<bool> weekDays;
  DateTime createdAt;
  DateTime finishedAt;
  Todo(
    this.id,
    this.projectId,
    this.title,
    this.projectTitle,
    this.projectColor,
    this.status,
    this.due,
    this.repeat,
    this.isRepeat,
    this.weekDays,
    this.createdAt,
    this.finishedAt,
  ) {
    this.createdAt = DateTime.now();
    // this.repeat = TodoHelper.getEmptRepeat();
  }
  Todo.fromJson(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        projectId = parsedJSON['projectId'],
        title = parsedJSON['title'],
        projectTitle = parsedJSON['projectTitle'] != null
            ? parsedJSON['projectTitle']
            : null,
        projectColor = parsedJSON['projectColor'] != null
            ? parsedJSON['projectColor']
            : null,
        status = parsedJSON['status'],
        due = parsedJSON['due'].toDate().toLocal(),
        repeat = parsedJSON['repeat'],
        isRepeat =
            parsedJSON['isRepeat'] == null ? false : parsedJSON['isRepeat'],
        weekDays = parsedJSON['weekDays'] == null
            ? TodoHelper.getEmptRepeat()
            : List.from(parsedJSON['weekDays']),
        createdAt = parsedJSON['createdAt'].toDate().toLocal(),
        finishedAt = parsedJSON['finishedAt'] == null
            ? null
            : parsedJSON['finishedAt'].toDate().toLocal();

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'title': title,
        'projectTitle': projectTitle != null ? projectTitle : null,
        'projectColor': projectColor != null ? projectColor : null,
        'status': status,
        'due': due.toUtc(),
        'repeat': repeat,
        'isRepeat': isRepeat,
        'weekDays': weekDays,
        'createdAt': createdAt.toUtc(),
        'finishedAt': finishedAt.toUtc(),
      };

  @override
  bool operator ==(task) => task.id == id;
}

enum TodoStatus { todo, onGoing, finished }

extension TodoSTatusExtension on TodoStatus {
  int get value {
    switch (this) {
      case TodoStatus.todo:
        return 0;
      case TodoStatus.onGoing:
        return 1;
      case TodoStatus.finished:
        return 2;
      default:
        return 0;
    }
  }
}
