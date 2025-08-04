
import 'package:flutter/material.dart';

class ListModel extends ChangeNotifier{
  final List<Map<String, dynamic>> _listItems = [];

  
  List<Map<String, dynamic>> get listItems => _listItems;


  void addItem(String newItem){
    if(newItem.isNotEmpty){
      _listItems.add({
        'task':newItem,
        'completed':false,
      });
      notifyListeners();
      }
    }
     void removeItem(int index) {
    _listItems.removeAt(index);
    notifyListeners();
  }


  void toggleCompletion(int index) {
    _listItems[index]['completed'] = !_listItems[index]['completed'];
    notifyListeners();
  }


}

  