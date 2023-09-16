import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'todo.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;
  final VoidCallback onDelete;
  final VoidCallback onComplete;
  final bool showTime;
  final bool showCreatedTime;
  final bool showCompletedTime;
  final Function(Todo) onEdit;

  TodoItem({
    required this.todo,
    required this.onDelete,
    required this.onComplete,
    required this.showTime,
    required this.showCreatedTime,
    required this.showCompletedTime,
    required this.onEdit,
  });

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  TextEditingController _editTaskNameController = TextEditingController();
  TextEditingController _editTaskDescriptionController =
      TextEditingController();

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.todo.taskColor.withOpacity(0.5),
            widget.todo.taskColor.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Created time and Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Edit button
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _editTaskNameController.text = widget.todo.name;
                    _editTaskDescriptionController.text =
                        widget.todo.description;
                    _isEditing = true;
                  });
                },
              ),
              // If show created time the show created time
              if (widget.showCreatedTime &&
                  widget.showTime &&
                  widget.todo.createdTime != null)
                Text(
                  'Created at: ${DateFormat('hh:mm a, MMM dd yyyy').format(widget.todo.createdTime!)}',
                  style: TextStyle(fontSize: 12),
                ),
            ],
          ),
          // Edit form
          if (_isEditing)
            Column(
              children: [
                TextFormField(
                  controller: _editTaskNameController,
                  decoration: InputDecoration(labelText: 'Task Name'),
                ),
                TextFormField(
                  controller: _editTaskDescriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.todo.name = _editTaskNameController.text;
                    widget.todo.description =
                        _editTaskDescriptionController.text;
                    widget.todo.createdTime = DateTime.now();
                    widget.onEdit(widget.todo);
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  child: Text('Save'),
                ),
              ],
            )
          else
            // Task name and description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task name and checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Checkbox and title
                    Row(
                      children: [
                        Checkbox(
                          value: widget.todo.isCompleted,
                          onChanged: (value) {
                            widget.onComplete();
                            if (value! && widget.showTime) {
                              widget.todo.completedTime = DateTime.now();
                            } else {
                              // for now lets keep it as it is but we can change it to null
                              widget.todo.completedTime = DateTime.now();
                            }
                          },
                          activeColor: widget.todo.taskColor,
                        ),
                        // Task name
                        Text(
                          widget.todo.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            decoration: widget.todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                    // Delete button
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: widget.onDelete,
                    ),
                  ],
                ),
                // Task description
                Text(
                  widget.todo.description,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                // If show completed time then show completed time
                if (widget.showCompletedTime &&
                    widget.showTime &&
                    widget.todo.isCompleted &&
                    widget.todo.completedTime != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Completed at: ${DateFormat('hh:mm a, MMM dd yyyy').format(widget.todo.completedTime!)}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

//@sheharyar codsoft internship task 1
