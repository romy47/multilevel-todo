class Todo {
  String title;
  TodoStatus status;
  Todo(this.title, this.status);
}

enum TodoStatus { todo, onGoing, finished }
