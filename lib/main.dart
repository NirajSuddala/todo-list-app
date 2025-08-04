import 'package:flutter/material.dart';
import 'package:hello_world/list_items.dart';
import 'package:hello_world/todo_list_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context)=> ListModel(),
    child: const MainApp(),
    ),
    );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'ToDo List.',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const ListItems(),
    );
  }
}
