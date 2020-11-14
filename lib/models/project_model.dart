class Project {
  String title;
  String id;
  String uid;
  int color;
  Project(this.title, this.id, this.color, this.uid);
  Project.fromJson(Map<String, dynamic> parsedJSON)
      : title = parsedJSON['title'],
        id = parsedJSON['id'],
        color = int.parse(parsedJSON['color']),
        uid = parsedJSON['uid'];

  @override
  bool operator ==(project) => project.id == id;
}
