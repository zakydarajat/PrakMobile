import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart'; // Untuk audio player

class TaskController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Menambahkan player audio

  var tasksByDate = <String, List<Task>>{}.obs;
  var newTaskTitle = ''.obs;
  var newTaskDescription = ''.obs;
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;

  var isExpanded = <bool>[].obs;
  var isTaskDone = <bool>[].obs;
  var viewAllTasks = false.obs;
  var expandedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    _listenToTaskUpdates();
  }

  // Real-time listener for Firestore changes
  void _listenToTaskUpdates() {
    firestore.collection('tasks').snapshots().listen((snapshot) {
      final tasks = snapshot.docs.map((doc) {
        final data = doc.data();
        return Task.fromMap(data)..id = doc.id;
      }).toList();

      final groupedTasks = <String, List<Task>>{};
      for (final task in tasks) {
        final formattedDate = DateFormat('yyyy-MM-dd').format(task.date);
        groupedTasks.putIfAbsent(formattedDate, () => []).add(task);
      }

      tasksByDate.assignAll(groupedTasks);
      _initializeExpansionAndDoneStates();
    });
  }

  // Save a task to Firestore
  Future<void> _saveTaskToFirestore(Task task) async {
    try {
      final docRef = await firestore.collection('tasks').add(task.toMap());
      task.id = docRef.id;
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

      _saveTaskToFirestore(newTask);

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

    // Play sound when task is marked done
    if (task.done) {
      _playSound();
    }

    _updateTaskInFirestore(task);
  }

  // Play sound when task is done
  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/done_sound.mp3'));
  }

  // Edit task
  void editTask(Task task, String newTitle, String newDescription) {
    task.title = newTitle;
    task.description = newDescription;

    _updateTaskInFirestore(task);
  }

  // Delete task
  Future<void> deleteTask(Task task) async {
    try {
      if (task.id != null) {
        await firestore.collection('tasks').doc(task.id).delete();
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
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

  // Get tasks based on the current view mode
  List<Task> get displayedTasks {
    return viewAllTasks.value ? allTasks : tasksForSelectedDate;
  }

  // Toggle between all tasks and today's tasks
  void showAllTasks() {
    viewAllTasks.value = !viewAllTasks.value;
    _initializeExpansionAndDoneStates();
  }

  // Initialize the expanded state and done state lists
  void _initializeExpansionAndDoneStates() {
    final taskCount = displayedTasks.length;
    isExpanded.value = List<bool>.filled(taskCount, false);
    isTaskDone.value = List<bool>.filled(taskCount, false);

    for (int i = 0; i < taskCount; i++) {
      isTaskDone[i] = displayedTasks[i].done;
    }
  }

  void toggleExpanded(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }
}

class Task {
  String? id;
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
