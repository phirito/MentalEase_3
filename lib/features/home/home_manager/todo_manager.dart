import 'package:shared_preferences/shared_preferences.dart';

class ToDoManager {
  List<String> _toDoList = [];

  List<String> get toDoList => _toDoList;

  Future<void> loadToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _toDoList = prefs.getStringList('toDoList') ?? [];
  }

  Future<void> addToDoItem(String newToDo) async {
    _toDoList.add(newToDo);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('toDoList', _toDoList);
  }

  Future<void> removeToDoItem(String toDo) async {
    _toDoList.remove(toDo);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('toDoList', _toDoList);
  }
}
