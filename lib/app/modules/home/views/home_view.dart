import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/home/controllers/task_controller.dart';
import 'package:myapp/app/modules/home/views/custom_bottom_navbar.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xff34794e);
    final accentColor = Color(0xff9ef2be);
    final backgroundColor = Colors.white;
    final textColor = Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24),
                      _buildHeader(primaryColor, accentColor, textColor),
                      SizedBox(height: 16),
                      _buildDatePicker(context, primaryColor, textColor),
                      SizedBox(height: 16),
                      _buildTaskCounts(textColor),
                      SizedBox(height: 16),
                      _buildAddTaskCard(context),
                      SizedBox(height: 24),
                      _buildTaskList(primaryColor, textColor),
                    ],
                  ),
                ),
              ),
            ),
            CustomBottomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryColor, Color accentColor, Color textColor) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [accentColor, primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.person,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Zaky!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, Color primaryColor, Color textColor) {
    return GestureDetector(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: taskController.selectedDate.value,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          taskController.selectedDate.value = selectedDate;
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, color: textColor),
            SizedBox(width: 8),
            Obx(
              () => Text(
                DateFormat('yMMMd').format(taskController.selectedDate.value),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCounts(Color textColor) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Today's Tasks: ${taskController.tasksForSelectedDate.length}",
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          Text(
            'All Tasks: ${taskController.allTasks.length}',
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddTaskModal(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            '+ Add your task',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(Color primaryColor, Color textColor) {
    return Obx(
      () => taskController.displayedTasks.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: taskController.displayedTasks.length,
              itemBuilder: (context, index) {
                Task task = taskController.displayedTasks[index];
                return _buildTaskCard(
                  title: task.title,
                  time: task.time,
                  description: task.description,
                  color: primaryColor,
                  textColor: Colors.white,
                  index: index,
                );
              },
            )
          : Center(
              child: Text(
                'No tasks for this date',
                style: TextStyle(color: textColor.withOpacity(0.6)),
              ),
            ),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String time,
    required String description,
    required Color color,
    required Color textColor,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => taskController.toggleExpanded(index),
      child: Obx(
        () => AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                taskController.isTaskDone[index] ? Colors.greenAccent.shade200 : color.withOpacity(0.9),
                taskController.isTaskDone[index] ? Colors.green : color.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 15,
                offset: Offset(5, 5),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(-5, -5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    taskController.isTaskDone[index]
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: Duration(milliseconds: 300),
                    turns: taskController.isExpanded[index] ? 0.5 : 0,
                    child: Icon(
                      Icons.expand_more,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              if (taskController.isExpanded[index]) ...[
                Divider(
                  color: Colors.white.withOpacity(0.3),
                  thickness: 1,
                  height: 20,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white70, size: 18),
                    SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      taskController.toggleTaskDone(index);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: taskController.isTaskDone[index]
                          ? Colors.redAccent
                          : Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      taskController.isTaskDone[index]
                          ? 'Mark as Undone'
                          : 'Mark as Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    final primaryColor = Color(0xff34794e);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Add New Task',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              _buildTextField(
                hintText: 'Task Title',
                icon: Icons.title,
                onChanged: (value) => taskController.newTaskTitle.value = value,
              ),
              SizedBox(height: 16),
              _buildTextField(
                hintText: 'Task Description',
                icon: Icons.description,
                onChanged: (value) => taskController.newTaskDescription.value = value,
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: _buildDateTimePicker(
                  label: 'Select Date',
                  icon: Icons.calendar_today,
                  value: DateFormat('yMMMd').format(taskController.selectedDate.value),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: _buildDateTimePicker(
                  label: 'Select Time',
                  icon: Icons.access_time,
                  value: taskController.selectedTime.value.format(context),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  taskController.addTask();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  elevation: 5,
                ),
                child: Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: Icon(
          icon,
          color: Colors.grey.shade600,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required IconData icon,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      taskController.selectedDate.value = selectedDate;
    }
  }

  void _selectTime(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      taskController.selectedTime.value = selectedTime;
    }
  }
}
