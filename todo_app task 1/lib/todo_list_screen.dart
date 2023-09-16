import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_notifier.dart';
import 'todo.dart';
import 'todo_item.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool showTime =
      true; // Variable to control whether to show created and completed times
  bool showCreatedTime =
      true; // Variable to control showCreatedTime switch state
  bool showCompletedTime =
      true; // Variable to control showCompletedTime switch state

  @override
  void initState() {
    super.initState();
    _loadTodos();
    _loadShowTimeSetting();
  }

  void _loadShowTimeSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showCreatedTime = prefs.getBool('showCreatedTime') ?? true;
      showCompletedTime = prefs.getBool('showCompletedTime') ?? true;
      showTime = showCreatedTime || showCompletedTime;
    });
  }

  void _saveShowTimeSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showCreatedTime', showCreatedTime);
    prefs.setBool('showCompletedTime', showCompletedTime);
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Color randomColor() {
          final random = Random();
          return Color.fromRGBO(
            random.nextInt(256),
            random.nextInt(256),
            random.nextInt(256),
            1.0,
          );
        }

        return AlertDialog(
          title: Text('Add a Task'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _taskNameController,
                  decoration: InputDecoration(labelText: 'Task Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _taskDescriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final taskName = _taskNameController.text;
                  final taskDescription = _taskDescriptionController.text;

                  setState(() {
                    todos.add(Todo(
                      name: taskName,
                      description: taskDescription,
                      date: DateTime.now(),
                      taskColor: randomColor(),
                      createdTime: DateTime.now(),
                    ));
                    _saveTodos();
                  });

                  _taskNameController.clear();
                  _taskDescriptionController.clear();

                  Navigator.of(context).pop();
                }
              },
              //@sheharyar codsoft internship task 1
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? todosJson = prefs.getStringList('todos');

    if (todosJson != null) {
      setState(() {
        todos = todosJson.map((todoJson) {
          final todoMap = jsonDecode(todoJson);
          return Todo(
            name: todoMap['name'],
            description: todoMap['description'],
            date: DateTime.parse(todoMap['date']),
            isCompleted: todoMap['isCompleted'],
            taskColor: Color(todoMap['taskColor']),
            completedTime: todoMap['completedTime'] != null
                ? DateTime.parse(todoMap['completedTime'])
                : null,
            createdTime: todoMap['createdTime'] != null
                ? DateTime.parse(todoMap['createdTime'])
                : null,
          );
        }).toList();
      });
    }
  }

  Future<void> _saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> todosJson =
        todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('todos', todosJson);
  }

  void _editTodo(Todo editedTodo) {
    // Find the index of the editedTodo in the todos list
    final index = todos.indexWhere((todo) => todo == editedTodo);

    if (index != -1) {
      setState(() {
        // Update the edited todo
        todos[index] = editedTodo;
        _saveTodos();
      });
    }
  }

  void _changeTheme() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    themeNotifier.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return TodoItem(
            showTime: showTime, // Pass the showTime variable to TodoItem
            showCreatedTime: showCreatedTime, // Pass showCreatedTime
            showCompletedTime: showCompletedTime, // Pass showCompletedTime
            todo: todos[index],
            onDelete: () {
              setState(() {
                todos.removeAt(index);
                _saveTodos();
              });
            },
            onEdit: _editTodo,
            onComplete: () {
              setState(() {
                todos[index].isCompleted = !todos[index].isCompleted;
                if (todos[index].isCompleted && showTime) {
                  todos[index].completedTime = DateTime.now();
                } else {
                  todos[index].completedTime = null;
                }
                _saveTodos();
              });
            },
          );
        },
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      Provider.of<ThemeNotifier>(context).isDark
                          ? 'Dark Mode'
                          : 'Light Mode',
                    ),
                    leading: Icon(
                      Provider.of<ThemeNotifier>(context).isDark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                    trailing: Switch(
                      value: Provider.of<ThemeNotifier>(context).isDark,
                      onChanged: (value) {
                        final themeNotifier =
                            Provider.of<ThemeNotifier>(context, listen: false);
                        themeNotifier.toggleTheme();
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      showCreatedTime
                          ? 'Show Created Time'
                          : 'Hide Created Time',
                    ),
                    leading: Icon(
                      showCreatedTime
                          ? Icons.remove_red_eye
                          : Icons.highlight_off_sharp,
                    ),
                    trailing: Switch(
                      value: showCreatedTime,
                      onChanged: (value) {
                        setState(() {
                          showCreatedTime = value;
                          showTime = showCreatedTime || showCompletedTime;
                          _saveShowTimeSetting(); // Save the setting
                        });
                      },
                    ),
                  ),
                  // Show Completed Time switch
                  ListTile(
                    title: Text(
                      showCompletedTime
                          ? 'Show Completed Time'
                          : 'Hide Completed Time',
                    ),
                    leading: Icon(
                      showCompletedTime
                          ? Icons.remove_red_eye
                          : Icons.highlight_off_sharp,
                    ),
                    trailing: Switch(
                      value: showCompletedTime,
                      onChanged: (value) {
                        setState(() {
                          showCompletedTime = value;
                          showTime = showCreatedTime || showCompletedTime;
                          _saveShowTimeSetting(); // Save the setting
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '@Sheharyar Codsoft internship',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
