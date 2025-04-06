class Todo {
  final String title;
  final bool isDone;

  Todo({required this.title, required this.isDone});

  Map<String, dynamic> toJson() => {'title': title, 'isDone': isDone};

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(title: json['title'], isDone: json['isDone']);
  }
}
