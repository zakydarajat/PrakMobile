import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var tasksByDate = <String, List<Task>>{}.obs;
  var newTaskTitle = ''.obs;
  var newTaskDescription = ''.obs;
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;
  var isExpanded = <bool>[].obs; // Keeps track of expanded states
  var isTaskDone = <bool>[].obs; // Keeps track of task completion status
  var viewAllTasks = false.obs; // Flag to control whether to show all tasks or only today's

  var expandedIndex = (-1).obs;

  void toggleExpanded(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1; // Collapse
    } else {
      expandedIndex.value = index; // Expand
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadTasksFromFirestore();
  }

  // Load tasks from Firestore
  Future<void> _loadTasksFromFirestore() async {
    try {
      final snapshot = await firestore.collection('tasks').get();
      final tasks = snapshot.docs.map((doc) {
        final data = doc.data();
        return Task.fromMap(data)..id = doc.id;
      }).toList();

      // Group tasks by date
      final groupedTasks = <String, List<Task>>{};
      for (final task in tasks) {
        final formattedDate = DateFormat('yyyy-MM-dd').format(task.date);
        groupedTasks.putIfAbsent(formattedDate, () => []).add(task);
      }

      tasksByDate.assignAll(groupedTasks);
      _initializeExpansionAndDoneStates();
    } catch (e) {
      print('Error loading tasks from Firestore: $e');
    }
  }

  // Save a task to Firestore
  Future<void> _saveTaskToFirestore(Task task) async {
    try {
      final docRef = await firestore.collection('tasks').add(task.toMap());
      task.id = docRef.id; // Update task with the generated Firestore ID
    } catch (e) {
      print('Error saving task to Firestore: $e');
    }
  }

  // Update a task in Firestore
  Future<void> _updateTaskInFirestore(Task task) async {
    try {
      if (task.id != null) {
        await firestore.collection('tasks').doc(task.id).update(task.toMap());
      }
    } catch (e) {
      print('Error updating task in Firestore: $e');
    }
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

      // Save to Firestore
      _saveTaskToFirestore(newTask);

      _initializeExpansionAndDoneStates();

      // Reset input fields
      newTaskTitle.value = '';
      newTaskDescription.value = '';
      selectedDate.value = DateTime.now();
      selectedTime.value = TimeOfDay.now();
    }
  }

  // Toggle done state for a specific task
  void toggleTaskDone(int index) {
    final task = displayedTasks[index];
    task.done = !task.done;
    isTaskDone[index] = task.done;

    // Update Firestore
    _updateTaskInFirestore(task);
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

  // Initialize the expanded state and done state lists
  void _initializeExpansionAndDoneStates() {
    final taskCount = displayedTasks.length; // Adjust to match displayed tasks only
    isExpanded.value = List<bool>.filled(taskCount, false);
    isTaskDone.value = List<bool>.filled(taskCount, false);
    for (int i = 0; i < taskCount; i++) {
      isTaskDone[i] = displayedTasks[i].done;
    }
  }
}

// Model class for a Task
class Task {
  String? id; // Firestore document ID
  String title;
  String description;
  String time;
  DateTime date;
  bool done;

  Task({
    this.id,
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
