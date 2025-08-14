// lib/list_model.dart

import 'package:flutter/material.dart';
import 'models/todo_item.dart';

class ListModel extends ChangeNotifier {
  final List<TodoItem> _listItems = [];

  List<TodoItem> get listItems => _listItems;

  void addItem({
    required String task,
    required DateTime startDate,
    required DateTime dueDate,
    required Assignee assignee,
    required Duration timeEstimate,
    Status status = Status.pending,
  }) {
    final newItem = TodoItem(
      task: task,
      startDate: startDate,
      dueDate: dueDate,
      assignee: assignee,
      timeEstimate: timeEstimate,
      status: status,
    );
    _listItems.add(newItem);
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _listItems.length) {
      _listItems.removeAt(index);
      notifyListeners();
    }
  }

  void toggleCompletion(int index) {
    if (index >= 0 && index < _listItems.length) {
      final itemToUpdate = _listItems[index];
      itemToUpdate.status = itemToUpdate.status == Status.pending ? Status.completed : Status.pending;
      notifyListeners();
    }
  }

  void editTaskName(int index, String newTaskName) {
    if (index >= 0 && index < _listItems.length && newTaskName.isNotEmpty) {
      _listItems[index].task = newTaskName;
      notifyListeners();
    }
  }
}
