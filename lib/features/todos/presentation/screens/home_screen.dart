import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/features/todos/presentation/provider/todo_provider.dart';
import 'package:provider/provider.dart';


class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  void _addTodo(TodoProvider provider) {
    if (_formKey.currentState!.validate()) {
      final name = _controller.text.trim();
      provider.addTodo(name);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('todo.title'.tr()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration:  InputDecoration(
                        hintText: 'todo.add_title'.tr(),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'todo.name_required'.tr();
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _addTodo(todoProvider),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _addTodo(todoProvider),
                    child: Text('todo.add'.tr()),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: todoProvider.todos.isEmpty
                ?  Center(child: Text('todo.empty'.tr()))
                : ListView.builder(
                    itemCount: todoProvider.todos.length,
                    itemBuilder: (context, index) {
                      final todo = todoProvider.todos[index];
                      return Dismissible(
                        key: Key(todo.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          todoProvider.deleteTodo(todo.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Todo "${todo.name}" deleted')),
                          );
                        },
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.completed,
                            onChanged: (_) {
                              todoProvider.toggleCompletion(todo);
                            },
                          ),
                          title: Text(
                            todo.name,
                            style: TextStyle(
                              decoration: todo.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                              color:
                                  todo.completed ? Colors.green : Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey),
                            onPressed: () =>
                                todoProvider.deleteTodo(todo.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}