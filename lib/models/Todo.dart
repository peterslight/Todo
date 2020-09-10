class Todo {
  final int id, isDone, taskId;
  final String title;

  Todo({this.id, this.taskId, this.title, this.isDone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'isDone': isDone,
    };
  }
}
