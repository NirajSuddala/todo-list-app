import 'package:hello_world/features/todos/domain/entities/todo.dart';
import 'package:hello_world/features/todos/domain/repositories/todo_repository.dart';

class ToggleCompletion {
  final TodoRepository repository;
  ToggleCompletion(this.repository);

  Future<void> call(Todo todo) {
    final updated = todo.copyWith(completed: !todo.completed);
    return repository.updateTodo(updated);
  }
}