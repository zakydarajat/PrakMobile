import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  final storage = GetStorage();
  var tasksByDate = <String, List<Task>>{}.obs;
  var newTaskTitle = ''.obs;
  var newTaskDescription = ''.obs;
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;
  var isExpanded = <bool>[].obs; // Keeps track of expanded states
  var isTaskDone = <bool>[].obs; // Keeps track of task completion status
  var viewAllTasks = false.obs; // Flag to control whether to show all tasks or only today's

  @override
  void onInit() {
    super.onInit();
    _loadTasks();
  }

  // Load tasks from local storage
  void _loadTasks() {
    final storedTasks = storage.read<Map<String, dynamic>>('tasksByDate') ?? {};
    tasksByDate.assignAll(storedTasks.map((key, value) {
      final tasks = (value as List)
          .map((taskData) => Task.fromMap(taskData))
          .toList();
      return MapEntry(key, tasks);
    }));
    _initializeExpansionAndDoneStates();
  }

  // Initialize the expanded state and done state lists
  void _initializeExpansionAndDoneStates() {
    final taskCount = displayedTasks.length; // Adjust to match displayed tasks only
    isExpanded.value = List<bool>.filled(taskCount, false);
    isTaskDone.value = List<bool>.filled(taskCount, false);
    // Sync done status with stored tasks
    for (int i = 0; i < taskCount; i++) {
      isTaskDone[i] = displayedTasks[i].done;
    }
  }

  // Save tasks to local storage
  void _saveTasks() {
    final taskMap = tasksByDate.map((key, value) {
      return MapEntry(key, value.map((task) => task.toMap()).toList());
    });
    storage.write('tasksByDate', taskMap);
  }

  // Method to add a new task
  void addTask() {
    if (newTaskTitle.value.isNotEmpty) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      final taskDate = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        selectedTime.value.hour,
        selectedTime.value.minute,
      );

      final newTask = Task(
        title: newTaskTitle.value,
        description: newTaskDescription.value,
        time: DateFormat('yMMMd').add_jm().format(taskDate),
        date: taskDate,
        done: false,
      );

      tasksByDate.update(
        formattedDate,
        (existingTasks) => existingTasks..add(newTask),
        ifAbsent: () => [newTask],
      );

      _saveTasks();
      _initializeExpansionAndDoneStates();

      newTaskTitle.value = '';
      newTaskDescription.value = '';
      selectedDate.value = DateTime.now();
      selectedTime.value = TimeOfDay.now();
    }
  }

  // Toggle expanded state for a specific task card
  void toggleExpanded(int index) {
    if (index >= 0 && index < isExpanded.length) {
      isExpanded[index] = !isExpanded[index];
    }
  }

  // Toggle done state for a specific task
  void toggleTaskDone(int index) {
    final task = displayedTasks[index];
    task.done = !task.done;
    isTaskDone[index] = task.done;
    _saveTasks();
  }

  // Retrieve tasks for the selected date
  List<Task> get tasksForSelectedDate {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);
    return tasksByDate[formattedDate] ?? [];
  }

  // Retrieve all tasks
  List<Task> get allTasks {
    return tasksByDate.values.expand((tasks) => tasks).toList();
  }

  // Method to switch between viewing all tasks and tasks for the selected date
  void showAllTasks() {
    viewAllTasks.value = !viewAllTasks.value;
    _initializeExpansionAndDoneStates(); // Update the expanded and done state lists when toggling views.
  }

  // Get tasks based on the current view mode
  List<Task> get displayedTasks {
    return viewAllTasks.value ? allTasks : tasksForSelectedDate;
  }
}

// Model class for a Task
class Task {
  String title;
  String description;
  String time;
  DateTime date;
  bool done;

  Task({
    required this.title,
    required this.description,
    required this.time,
    required this.date,
    this.done = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'time': time,
      'date': date.toIso8601String(),
      'done': done,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      time: map['time'],
      date: DateTime.parse(map['date']),
      done: map['done'] ?? false,
    );
  }
}
