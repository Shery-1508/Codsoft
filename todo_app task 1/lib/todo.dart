import 'package:flutter/material.dart';

class Todo {
  String name;
  String description;
  DateTime date;
  bool isCompleted;
  Color taskColor;
  DateTime? completedTime;
  DateTime? createdTime;

  Todo({
    required this.name,
    required this.description,
    required this.date,
    this.isCompleted = false,
    required this.taskColor,
    this.completedTime,
    this.createdTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'taskColor': taskColor.value,
      'completedTime': completedTime?.toIso8601String(),
      'createdTime': createdTime?.toIso8601String(),
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      name: json['name'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'],
      taskColor: Color(json['taskColor']),
      completedTime: json['completedTime'] != null
          ? DateTime.parse(json['completedTime'])
          : null,
      createdTime: json['createdTime'] != null
          ? DateTime.parse(json['createdTime'])
          : null,
    );
  }
}
