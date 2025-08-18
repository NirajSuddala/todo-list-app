import 'package:hello_world/features/todos/domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required int id,
    required String name,
    required bool completed,
  }) : super(id: id, name: name, completed: completed);

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json['id'] as int,
        name: json['name'] as String,
        completed: json['completed'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'completed': completed,
      };

  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      name: todo.name,
      completed: todo.completed,
    );
  }

  Todo toEntity() {
    return Todo(
      id: id,
      name: name,
      completed: completed,
    );
  }
}