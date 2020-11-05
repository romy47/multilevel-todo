class Todo {
  String id;
  String projectId;
  String title;
  TodoStatus status;
  Todo(this.id, this.projectId, this.title, this.status);
}

enum TodoStatus { todo, onGoing, finished }
