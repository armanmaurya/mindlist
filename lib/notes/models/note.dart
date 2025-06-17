class Note {
  final String? id;
  final String title;
  final String? data;
  DateTime lastUpdated;
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    this.data,
    required this.lastUpdated,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'Note(id: $id, title: $title, data: $data, lastUpdated: $lastUpdated, createdAt: $createdAt)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'data': data,
      'lastUpdated': lastUpdated.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String?,
      title: map['title'] as String,
      data: map['data'] as String?,
      lastUpdated: DateTime.parse(map['lastUpdated'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}