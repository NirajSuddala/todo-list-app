


import 'package:hello_world/features/todos/domain/entities/todo.dart';
import 'package:hello_world/features/todos/domain/repositories/todo_repository.dart';

class GetTodosUsecase {
  final TodoRepository repository;
  GetTodosUsecase(this.repository);
  Future<List<Todo>> call() => repository.getTodos();
}