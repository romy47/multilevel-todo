class Project {
  String title;
  String id;
  Project(this.title, this.id);
  @override
  bool operator ==(project) => project.id == id;
}
