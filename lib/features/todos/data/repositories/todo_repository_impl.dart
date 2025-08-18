import 'package:hello_world/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:hello_world/features/todos/data/models/todo_model.dart';
import 'package:hello_world/features/todos/domain/entities/todo.dart';
import 'package:hello_world/features/todos/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {

  final TodoLocalDataSource localDataSource;
  TodoRepositoryImpl({required this.localDataSource});


  @override
  Future<List<Todo>> getTodos() async {
    final models = await localDataSource.getTodos();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await localDataSource.addTodo(TodoModel.fromEntity(todo));
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await localDataSource.updateTodo(TodoModel.fromEntity(todo));
  }

  @override
  Future<void> deleteTodo(int id) async {
    await localDataSource.deleteTodo(id);
  }
}