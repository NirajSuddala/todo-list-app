import 'package:hello_world/features/todos/domain/entities/todo.dart';
import 'package:hello_world/features/todos/domain/repositories/todo_repository.dart';

class UpdateTodoUsecase {
  final TodoRepository repository;
  UpdateTodoUsecase(this.repository);

  Future<void> call(Todo todo) async {
    await repository.updateTodo(todo);
  }
}