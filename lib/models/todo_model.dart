class Todo {
  String id;
  String projectId;
  String title;
  TodoStatus status;
  DateTime due;
  String repeat;
  Todo(this.id, this.projectId, this.title, this.status, this.due);
}

enum TodoStatus { todo, onGoing, finished }
