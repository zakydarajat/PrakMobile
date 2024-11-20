import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/home/controllers/task_controller.dart';
import 'package:myapp/app/modules/home/views/custom_bottom_navbar.dart';

class HttpView extends StatelessWidget {
  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xff34794e);
    final backgroundColor = Colors.white;
    final accentColor = Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks List'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _taskController.viewAllTasks.value
                  ? Icons.calendar_today
                  : Icons.list,
              color: Colors.white,
            ),
            onPressed: () {
              _taskController.showAllTasks();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content - Observing tasks list from TaskController
          Positioned.fill(
            child: Obx(() {
              final tasks = _taskController.displayedTasks;

              if (tasks.isEmpty) {
                return Center(child: Text('No tasks available'));
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ExpansionTile(
                      onExpansionChanged: (expanded) {
                        _taskController.toggleExpanded(index);
                      },
                      initiallyExpanded:
                          _taskController.expandedIndex.value == index,
                      leading: GestureDetector(
                        onTap: () => _taskController.toggleTaskDone(index),
                        child: CircleAvatar(
                          backgroundColor: task.done ? accentColor : Colors.red,
                          child: Icon(
                            task.done ? Icons.check : Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          decoration: task.done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        'Time: ${task.time}',
                        style: TextStyle(color: Colors.black54),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit button
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              _showEditDialog(context, task);
                            },
                          ),
                          // Delete button
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _taskController.deleteTask(task);
                            },
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(task.description),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          // Floating navigation bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          _showAddTaskDialog(context);
        },
      ),
      backgroundColor: backgroundColor,
    );
  }

  // Function to show edit dialog
  void _showEditDialog(BuildContext context, Task task) {
    final TextEditingController titleController =
        TextEditingController(text: task.title);
    final TextEditingController descriptionController =
        TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  _taskController.editTask(
                    task,
                    titleController.text,
                    descriptionController.text,
                  );
                  Get.back();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to show add task dialog
  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Date: '),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) selectedDate = date;
                      },
                      child: Text(DateFormat('yMMMd').format(selectedDate)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Time: '),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) selectedTime = time;
                      },
                      child: Text(selectedTime.format(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  _taskController.newTaskTitle.value = titleController.text;
                  _taskController.newTaskDescription.value =
                      descriptionController.text;
                  _taskController.selectedDate.value = selectedDate;
                  _taskController.selectedTime.value = selectedTime;
                  _taskController.addTask();
                  Get.back();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
