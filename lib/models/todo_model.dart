class Todo {
  String id;
  String projectId;
  String title;
  TodoStatus status;
  DateTime due;
  String repeat;
  DateTime createdAt;
  DateTime finishedAt;
  Todo(this.id, this.projectId, this.title, this.status, this.due) {
    this.createdAt = DateTime.now();
  }
}

enum TodoStatus { todo, onGoing, finished }
