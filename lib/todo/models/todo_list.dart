import 'todo.dart';

class TodoList {
  String id;
  String title;
  List<Todo> items;

  TodoList({required this.id, required this.title, required this.items});

  factory TodoList.fromJson(Map<String, dynamic> json) {
    return TodoList(
      id: json['id'] as String? ?? '',
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => Todo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'items': items.map((e) => e.toJson()).toList(),
      };
}
