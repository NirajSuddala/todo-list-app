import 'package:hello_world/features/todos/data/models/todo_model.dart';

abstract class TodoLocalDataSource {
Future<List<TodoModel>> getTodos();
Future<void> addTodo(TodoModel todo);
Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(int id);

}

class InMemoryTodoLoalDataSource implements TodoLocalDataSource{
  final List<TodoModel> _storage = [];
  int _currentId = 0;
  @override
  Future<void> addTodo(TodoModel todo) async {
    _currentId++;
    final todoWithId = TodoModel(id: _currentId, name: todo.name, completed: todo.completed);
    _storage.add(todoWithId);
  }

  @override
  Future<List<TodoModel>> getTodos() async => 
    List<TodoModel>.unmodifiable(_storage);

    @override
  Future<void> updateTodo(TodoModel todo) async {
    final index = _storage.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _storage[index] = todo;
    }
  }

  @override
  Future<void> deleteTodo(int id) async {
    _storage.removeWhere((t) => t.id == id);
  }
}
