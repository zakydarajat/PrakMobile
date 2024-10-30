// lib\app\modules\task\views\http_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/home/views/custom_bottom_navbar.dart';
import 'package:myapp/app/modules/home/controllers/task_controller.dart';

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
                      initiallyExpanded: _taskController.isExpanded[index],
                      leading: CircleAvatar(
                        backgroundColor:
                            task.done ? accentColor : Colors.red,
                        child: Icon(
                          task.done ? Icons.check : Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'Time: ${task.time}',
                        style: TextStyle(color: Colors.black54),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          task.done
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: primaryColor,
                        ),
                        onPressed: () => _taskController.toggleTaskDone(index),
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
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          // Implement navigation to the task creation screen
        },
      ),
    );
  }
}
