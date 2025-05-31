class Todo {
  String title;
  bool isDone;
  String id;

  Todo({required this.title, required this.isDone, required this.id});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'] as String,
      isDone: json['isDone'] as bool,
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'isDone': isDone,
        'id': id,
      };
}
