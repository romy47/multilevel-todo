class Todo {
  String id;
  String projectId;
  String title;
  String projectTitle;
  int projectColor;
  int status;
  DateTime due;
  int repeat;
  DateTime createdAt;
  DateTime finishedAt;
  Todo(
    this.id,
    this.projectId,
    this.title,
    // this.projectTitle,
    // this.projectColor,
    this.status,
    this.due,
    this.repeat,
    this.createdAt,
  ) {
    this.createdAt = DateTime.now();
  }
  Todo.fromJson(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        projectId = parsedJSON['projectId'],
        title = parsedJSON['title'],
        // projectTitle = parsedJSON['projectTitle'],
        // projectColor = parsedJSON['projectColor'],
        status = parsedJSON['status'],
        due = parsedJSON['due'].toDate(),
        repeat = parsedJSON['repeat'],
        createdAt = parsedJSON['createdAt'].toDate(),
        finishedAt = parsedJSON['finishedAt'] == null
            ? null
            : parsedJSON['finishedAt'].toDate();

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'title': title,
        // 'projectTitle': projectTitle,
        // 'projectColor': projectColor,
        'status': status,
        'due': due,
        'repeat': repeat,
        'createdAt': createdAt,
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
