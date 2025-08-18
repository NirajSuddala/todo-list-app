import 'package:flutter/material.dart';
import 'package:hello_world/features/todos/domain/entities/todo.dart';
import 'package:hello_world/features/todos/domain/usecases/add_todo_usecase.dart';
import 'package:hello_world/features/todos/domain/usecases/delete_todo_usecase.dart';
import 'package:hello_world/features/todos/domain/usecases/get_todos_usecase.dart';
import 'package:hello_world/features/todos/domain/usecases/update_todo_usecase.dart';

class TodoProvider extends ChangeNotifier{
  final GetTodosUsecase getTodosUsecase;
  final AddTodoUsecase addTodoUsecase;
  final UpdateTodoUsecase updateTodoUsecase;
  final DeleteTodoUsecase deleteTodoUsecase;

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;
  TodoProvider({
    required this.getTodosUsecase,
    required this.addTodoUsecase,
     required this.updateTodoUsecase,
    required this.deleteTodoUsecase,
  }){
    _loadTodos();
  }
  Future<void> _loadTodos() async{
    _todos = await getTodosUsecase.call();
    notifyListeners();
  }
  Future<void> addTodo(String name) async {
    final todo = Todo(id: 0, name: name, completed: false); 
  
    await addTodoUsecase.call(todo);
    await _loadTodos();
  }

  Future<void> toggleCompletion(Todo todo) async {
    final updatedTodo =
        todo.copyWith(completed: !todo.completed);
    await updateTodoUsecase.call(updatedTodo);
    await _loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await deleteTodoUsecase.call(id);
    await _loadTodos();
  }


  Future<void> updateTodo(Todo updatedTodo) async {
    await updateTodoUsecase.call(updatedTodo);
    final index = _todos.indexWhere((t) => t.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }

}