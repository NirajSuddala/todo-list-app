
// lib/list_items.dart
// import 'package:flutter/material.dart';
// import 'package:hello_world/models/todo_item.dart';
// import 'package:hello_world/todo_list_model.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart'; // Import your ListModel and enums

// class ListItems extends StatefulWidget {
//   const ListItems({super.key});

//   @override
//   State<ListItems> createState() => _ListItemsState();
// }

// class _ListItemsState extends State<ListItems> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _itemController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   final TextEditingController _timeEstimateController = TextEditingController(text: '1');
  
//   Assignee _selectedAssignee = Assignee.utsav;
//   DateTime _selectedStartDate = DateTime.now();
//   DateTime _selectedDueDate = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     // No need to explicitly call fetchInitialTodos here, as ListModel's constructor does it.
//   }

//   Future<void> _selectDate(BuildContext context, {required bool isStart}) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isStart ? _selectedStartDate : _selectedDueDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != (isStart ? _selectedStartDate : _selectedDueDate)) {
//       setState(() {
//         if (isStart) {
//           _selectedStartDate = picked;
//         } else {
//           _selectedDueDate = picked;
//         }
//       });
//     }
//   }

//   void _addItem(ListModel model) {
//     if (_formKey.currentState!.validate()) {
//       final String newItem = _itemController.text.trim();
//       final int timeInHours = int.tryParse(_timeEstimateController.text) ?? 1;

//       model.addItem(
//         task: newItem,
//         startDate: _selectedStartDate,
//         dueDate: _selectedDueDate,
//         assignee: _selectedAssignee,
//         timeEstimate: Duration(hours: timeInHours),
//       );

//       _itemController.clear();
//       _timeEstimateController.text = '1';
//       _focusNode.requestFocus();
//       setState(() {
//         _selectedStartDate = DateTime.now();
//         _selectedDueDate = DateTime.now();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _itemController.dispose();
//     _focusNode.dispose();
//     _timeEstimateController.dispose();
//     super.dispose();
//   }
  
//   void _showEditDialog(ListModel model, int index, String currentTask) {
//     final TextEditingController editController = TextEditingController(text: currentTask);
    
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Edit Task'),
//           content: TextField(
//             controller: editController,
//             decoration: const InputDecoration(
//               hintText: 'Enter new task name',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Save'),
//               onPressed: () {
//                 final newName = editController.text.trim();
//                 if (newName.isNotEmpty) {
//                   model.editTaskName(index, newName);
//                 }
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ToDo List.!"),
//       ),
//       body: Consumer<ListModel>(
//         builder: (context, model, child) {
//           if (model.isInitialLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (model.errorMessage != null) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Error: ${model.errorMessage}',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(color: Colors.red, fontSize: 16),
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: () => model.loadTodos(), // Call the private load method
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: _itemController,
//                         focusNode: _focusNode,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: "Add an Item..",
//                         ),
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Please enter something';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () => _selectDate(context, isStart: true),
//                               child: Text('Start Date: ${DateFormat('MMM d, y').format(_selectedStartDate)}'),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () => _selectDate(context, isStart: false),
//                               child: Text('Due Date: ${DateFormat('MMM d, y').format(_selectedDueDate)}'),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: DropdownButtonFormField<Assignee>(
//                               value: _selectedAssignee,
//                               decoration: const InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 labelText: 'Assignee',
//                               ),
//                               items: Assignee.values.map((Assignee assignee) {
//                                 return DropdownMenuItem<Assignee>(
//                                   value: assignee,
//                                   child: Text(assignee.name),
//                                 );
//                               }).toList(),
//                               onChanged: (Assignee? newAssignee) {
//                                 setState(() {
//                                   _selectedAssignee = newAssignee!;
//                                 });
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _timeEstimateController,
//                               keyboardType: TextInputType.number,
//                               decoration: const InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 labelText: 'Time Est. (hours)',
//                               ),
//                               validator: (value) {
//                                 if (value == null || int.tryParse(value) == null) {
//                                   return 'Enter a number';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: model.listItems.isEmpty
//                     ? const Center(child: Text('No items yet. Add some!'))
//                     : ListView.builder(
//                         itemCount: model.listItems.length,
//                         itemBuilder: (context, index) {
//                           final item = model.listItems[index]; // item is now a TodoItem object
//                           final isCompleted = item.status == Status.completed;
                          
//                           return Dismissible(
//                             // Use a unique key for Dismissible, e.g., the item's task name + index
//                             key: ValueKey(item.task + index.toString()), 
//                             direction: DismissDirection.endToStart,
//                             background: Container(
//                               color: Colors.red,
//                               alignment: Alignment.centerRight,
//                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                               child: const Icon(Icons.delete, color: Colors.white),
//                             ),
//                             onDismissed: (direction) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('Deleting "${item.task}"...')),
//                               );
//                               model.removeItem(index);
//                             },
//                             child: ListTile(
//                               leading: Checkbox(
//                                 value: isCompleted,
//                                 onChanged: (bool? value) {
//                                   model.toggleCompletion(index);
//                                 },
//                               ),
//                               title: Text(
//                                 item.task,
//                                 style: TextStyle(
//                                   decoration: isCompleted ? TextDecoration.lineThrough : null,
//                                   color: isCompleted ? Colors.grey : null,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Assignee: ${item.assignee.name}'),
//                                   Text('Due: ${DateFormat('MMM d, y').format(item.dueDate)}'),
//                                   Text('Time Estimate: ${item.timeEstimate.inHours} hours'),
//                                   Text('Status: ${item.status.name}'), 
//                                 ],
//                               ),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.edit, color: Colors.blue),
//                                     onPressed: () => _showEditDialog(model, index, item.task),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.delete, color: Colors.grey),
//                                     onPressed: () {
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         SnackBar(content: Text('Deleting "${item.task}"...')),
//                                       );
//                                       model.removeItem(index);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _addItem(Provider.of<ListModel>(context, listen: false)),
//         tooltip: "Add Item",
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
//======================

// void _addItem(ListModel model, {String? taskName}) {
//     _itemController.text = taskName ?? _itemController.text;

//     if (_formKey.currentState!.validate()) {
//       final String newItem = _itemController.text.trim();
//       final int timeInHours = int.tryParse(_timeEstimateController.text) ?? 1;

//       model.addItem(
//         task: newItem,
//         startDate: _selectedStartDate,
//         dueDate: _selectedDueDate,
//         assignee: _selectedAssignee,
//         timeEstimate: Duration(hours: timeInHours),
//       );

//       _itemController.clear();
//       _timeEstimateController.text = '1';
//       _focusNode.requestFocus();
//       setState(() {
//         _selectedStartDate = DateTime.now();
//         _selectedDueDate = DateTime.now();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _itemController.dispose();
//     _focusNode.dispose();
//     _timeEstimateController.dispose();
//     super.dispose();
//   }
  
//   void _showEditDialog(ListModel model, int index, String currentTask) {
//     final TextEditingController editController = TextEditingController(text: currentTask);
    
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Edit Task'),
//           content: TextField(
//             controller: editController,
//             decoration: const InputDecoration(
//               hintText: 'Enter new task name',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Save'),
//               onPressed: () {
//                 final newName = editController.text.trim();
//                 if (newName.isNotEmpty) {
//                   model.editTaskName(index, newName);
//                 }
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ToDo List.!"),
//       ),
//       body: Consumer<ListModel>(
//         builder: (context, model, child) {
//           if (model.isInitialLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (model.errorMessage != null) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Error: ${model.errorMessage}',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(color: Colors.red, fontSize: 16),
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: () => model.loadTodos(),
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: _itemController,
//                         focusNode: _focusNode,
//                         onFieldSubmitted: (String value) {
//                           _addItem(model, taskName: value);
//                         },
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: "Add an Item..",
//                         ),
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Please enter something';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () => _selectDate(context, isStart: true),
//                               child: Text('Start Date: ${DateFormat('MMM d, y').format(_selectedStartDate)}'),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () => _selectDate(context, isStart: false),
//                               child: Text('Due Date: ${DateFormat('MMM d, y').format(_selectedDueDate)}'),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: DropdownButtonFormField<Assignee>(
//                               value: _selectedAssignee,
//                               decoration: const InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 labelText: 'Assignee',
//                               ),
//                               items: Assignee.values.map((Assignee assignee) {
//                                 return DropdownMenuItem<Assignee>(
//                                   value: assignee,
//                                   child: Text(assignee.name),
//                                 );
//                               }).toList(),
//                               onChanged: (Assignee? newAssignee) {
//                                 setState(() {
//                                   _selectedAssignee = newAssignee!;
//                                 });
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _timeEstimateController,
//                               keyboardType: TextInputType.number,
//                               decoration: const InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 labelText: 'Time Est. (hours)',
//                               ),
//                               validator: (value) {
//                                 if (value == null || int.tryParse(value) == null) {
//                                   return 'Enter a number';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: model.listItems.isEmpty
//                     ? const Center(child: Text('No items yet. Add some!'))
//                     : ListView.builder(
//                         itemCount: model.listItems.length,
//                         itemBuilder: (context, index) {
//                           final item = model.listItems[index];
//                           final isCompleted = item.status == Status.completed;
                          
//                           return Dismissible(
//                             key: ValueKey(item.id),
//                             direction: DismissDirection.endToStart,
//                             background: Container(
//                               color: Colors.red,
//                               alignment: Alignment.centerRight,
//                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                               child: const Icon(Icons.delete, color: Colors.white),
//                             ),
//                             onDismissed: (direction) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('Deleting "${item.task}"...')),
//                               );
//                               model.removeItem(index);
//                             },
//                             child: ListTile(
//                               leading: Checkbox(
//                                 value: isCompleted,
//                                 onChanged: (bool? value) {
//                                   model.toggleCompletion(index);
//                                 },
//                               ),
//                               title: Text(
//                                 item.task,
//                                 style: TextStyle(
//                                   decoration: isCompleted ? TextDecoration.lineThrough : null,
//                                   color: isCompleted ? Colors.grey : null,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Assignee: ${item.assignee.name}'),
//                                   Text('Due: ${DateFormat('MMM d, y').format(item.dueDate)}'),
//                                   Text('Time Estimate: ${item.timeEstimate.inHours} hours'),
//                                   Text('Status: ${item.status.name}'), 
//                                 ],
//                               ),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.edit, color: Colors.blue),
//                                     onPressed: () => _showEditDialog(model, index, item.task),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.delete, color: Colors.grey),
//                                     onPressed: () {
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         SnackBar(content: Text('Deleting "${item.task}"...')),
//                                       );
//                                       model.removeItem(index);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _addItem(Provider.of<ListModel>(context, listen: false)),
//         tooltip: "Add Item",
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// lib/list_items.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'todo_list_model.dart';
import 'models/todo_item.dart';

class ListItems extends StatefulWidget {
  const ListItems({super.key});

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _timeEstimateController = TextEditingController(text: '1');
  
  Assignee _selectedAssignee = Assignee.john;
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedDueDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, {required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _selectedStartDate : _selectedDueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStart ? _selectedStartDate : _selectedDueDate)) {
      setState(() {
        if (isStart) {
          _selectedStartDate = picked;
        } else {
          _selectedDueDate = picked;
        }
      });
    }
  }

  void _addItem(ListModel model, {String? taskName}) {
    _itemController.text = taskName ?? _itemController.text;

    if (_formKey.currentState!.validate()) {
      final String newItem = _itemController.text.trim();
      final int timeInHours = int.tryParse(_timeEstimateController.text) ?? 1;

      model.addItem(
        task: newItem,
        startDate: _selectedStartDate,
        dueDate: _selectedDueDate,
        assignee: _selectedAssignee,
        timeEstimate: Duration(hours: timeInHours),
      );

      _itemController.clear();
      _timeEstimateController.text = '1';
      _focusNode.requestFocus();
      setState(() {
        _selectedStartDate = DateTime.now();
        _selectedDueDate = DateTime.now();
      });
    }
  }

  @override
  void dispose() {
    _itemController.dispose();
    _focusNode.dispose();
    _timeEstimateController.dispose();
    super.dispose();
  }

  void _showEditDialog(ListModel model, int index, String currentTask) {
    final TextEditingController editController = TextEditingController(text: currentTask);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              hintText: 'Enter new task name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final newName = editController.text.trim();
                if (newName.isNotEmpty) {
                  model.editTaskName(index, newName);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo List.!"),
      ),
      body: Consumer<ListModel>(
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _itemController,
                        focusNode: _focusNode,
                        onFieldSubmitted: (String value) {
                          _addItem(model, taskName: value);
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Add an Item..",
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter something';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _selectDate(context, isStart: true),
                              child: Text('Start Date: ${DateFormat('MMM d, y').format(_selectedStartDate)}'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _selectDate(context, isStart: false),
                              child: Text('Due Date: ${DateFormat('MMM d, y').format(_selectedDueDate)}'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<Assignee>(
                              value: _selectedAssignee,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Assignee',
                              ),
                              items: Assignee.values.map((Assignee assignee) {
                                return DropdownMenuItem<Assignee>(
                                  value: assignee,
                                  child: Text(assignee.name),
                                );
                              }).toList(),
                              onChanged: (Assignee? newAssignee) {
                                setState(() {
                                  _selectedAssignee = newAssignee!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _timeEstimateController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Time Est. (hours)',
                              ),
                              validator: (value) {
                                if (value == null || int.tryParse(value) == null) {
                                  return 'Enter a number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: model.listItems.isEmpty
                    ? const Center(child: Text('No items yet. Add some!'))
                    : ListView.builder(
                        itemCount: model.listItems.length,
                        itemBuilder: (context, index) {
                          final item = model.listItems[index];
                          final isCompleted = item.status == Status.completed;
                          
                          return Dismissible(
                            key: ValueKey(item),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Deleting "${item.task}"...')),
                              );
                              model.removeItem(index);
                            },
                            child: ListTile(
                              leading: Checkbox(
                                value: isCompleted,
                                onChanged: (bool? value) {
                                  model.toggleCompletion(index);
                                },
                              ),
                              title: Text(
                                item.task,
                                style: TextStyle(
                                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                                  color: isCompleted ? Colors.grey : null,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Assignee: ${item.assignee.name}'),
                                  Text('Due: ${DateFormat('MMM d, y').format(item.dueDate)}'),
                                  Text('Time Estimate: ${item.timeEstimate.inHours} hours'),
                                  Text('Status: ${item.status.name}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _showEditDialog(model, index, item.task),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.grey),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Deleting "${item.task}"...')),
                                      );
                                      model.removeItem(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(Provider.of<ListModel>(context, listen: false)),
        tooltip: "Add Item",
        child: const Icon(Icons.add),
      ),
    );
  }
}
