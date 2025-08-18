
class Todo {
  final int id;
  final String name;
  final bool completed;

  Todo({
    required this.id,
    required this.name,
    this.completed = false,
  });

  Todo copyWith({
    int? id,
    String? name,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      name: name ?? this.name,
      completed: completed ?? this.completed,
    );
  }
}
