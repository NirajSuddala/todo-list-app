
import 'package:flutter/material.dart';
import 'package:hello_world/todo_list_model.dart';
import 'package:provider/provider.dart';

class ListItems extends StatefulWidget {
  const ListItems({super.key});

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

 
   void _addItem(ListModel model) {
    if (_formKey.currentState!.validate()) {
      final String newItem = _itemController.text.trim();
      model.addItem(newItem);
      _itemController.clear();
      _focusNode.requestFocus();
    }
  }
   @override
  void dispose() {
    _itemController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ListModel>(context,listen: false);
return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo List.!"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
            child: Form(
              key: _formKey, 
            child: TextFormField(
                  controller: _itemController,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Add an Item..",
                  ),
                  validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'please enter something';
                  }
                  return null;
                },
                  onFieldSubmitted: (value){
                    _addItem(model);
                  },
                ),
          ),
          ),
          Expanded(
            child: Consumer<ListModel>(
              builder:(context,model,child){
                if (model.listItems.isEmpty) {
                  return const Center(
                    child: Text('No items yet. Add some!'),
                  );
                }
              return ListView.builder(
                itemCount: model.listItems.length,
                itemBuilder: (context,index){
                  final item = model.listItems[index];
                  return Dismissible(
                    key:Key(item['task']),
                    direction: DismissDirection.endToStart, 
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(Icons.delete,color: Colors.white),
                    ),
                    onDismissed: (direction){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content:Text('Item "${item['task']}" Dismissed')),
                      );
                      model.removeItem(index);
                    },
                        child: ListTile(
                          leading: Checkbox(
                            value: item['completed'],
                            onChanged: (bool? value) {
                              model.toggleCompletion(index);
                            },
                          ),
                          title: Text(
                            item['task'],
                            style: TextStyle(
                              decoration: item['completed'] ? TextDecoration.lineThrough : null,
                              color: item['completed'] ? Colors.green : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey),
                            onPressed: () => model.removeItem(index),
                          ),
                        ),
                      );
                    },
                  );
              },
          ),
        ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> _addItem(model),
        tooltip: "Add Item",
        child: const Icon(Icons.add),
        ),
    );
  }
    
}
