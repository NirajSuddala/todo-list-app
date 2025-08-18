

import 'package:hello_world/features/todos/domain/entities/todo.dart';
import 'package:hello_world/features/todos/domain/repositories/todo_repository.dart';

class AddTodoUsecase {
  final TodoRepository repository;
  AddTodoUsecase(this.repository);
  Future<void> call(Todo todo) => repository.addTodo(todo);
}