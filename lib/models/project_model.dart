class Project {
  String title;
  String id;
  int color;
  Project(this.title, this.id, this.color);
  @override
  bool operator ==(project) => project.id == id;
}
