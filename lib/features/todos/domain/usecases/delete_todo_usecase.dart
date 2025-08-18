import 'package:hello_world/features/todos/domain/repositories/todo_repository.dart';

class DeleteTodoUsecase {
  final TodoRepository repository;
  DeleteTodoUsecase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteTodo(id);
  }}