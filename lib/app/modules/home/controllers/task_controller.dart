import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';
import 'package:get_storage/get_storage.dart';

class TaskController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final box = GetStorage(); // GetStorage instance
  final connectivity = Connectivity(); // Connectivity instance

  var tasksByDate = <String, List<Task>>{}.obs;
  var newTaskTitle = ''.obs;
  var newTaskDescription = ''.obs;
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;

  var isExpanded = <bool>[].obs;
  var isTaskDone = <bool>[].obs;
  var viewAllTasks = false.obs;
  var expandedIndex = (-1).obs;

  // Speech-to-text control
  var isListening = false.obs;

  // Paths to sound files
  String addSoundPath = 'sounds/add_task.mp3';
  String editSoundPath = 'sounds/edit_task.mp3';
  String deleteSoundPath = 'sounds/delete_task.mp3';

  @override
  void onInit() {
    super.onInit();
    _listenToTaskUpdates();
    _monitorConnectivity(); // Monitor connectivity changes
    _uploadPendingTasks(); // Try uploading any pending tasks on startup
  }

  void _monitorConnectivity() {
    connectivity.onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        _uploadPendingTasks(); // Coba unggah data lokal saat terhubung ke internet
      }
    });
  }

  Future<void> _saveTaskLocally(Task task) async {
    final pendingTasks = box.read<List<dynamic>>('pending_tasks') ?? [];
    pendingTasks.add(task.toMap());
    await box.write('pending_tasks', pendingTasks);
    print('Task saved locally: ${task.title}');
  }

  // Coba unggah semua tugas yang tersimpan di penyimpanan lokal
  Future<void> _uploadPendingTasks() async {
    final pendingTasks = box.read<List<dynamic>>('pending_tasks') ?? [];

    for (final taskMap in pendingTasks) {
      final task = Task.fromMap(Map<String, dynamic>.from(taskMap));
      try {
        await _saveTaskToFirestore(task); // Coba unggah ke Firestore
      } catch (e) {
        print('Error uploading task from local storage: $e');
        return; // Jika gagal, hentikan dan coba lagi nanti
      }
    }

    // Jika semua berhasil diunggah, hapus data lokal
    if (pendingTasks.isNotEmpty) {
      await box.remove('pending_tasks');
      print('All pending tasks uploaded and local storage cleared.');
    }
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

  // Play sound based on action
  Future<void> _playSound(String soundPath) async {
    try {
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // Save a task to Firestore
  Future<void> _saveTaskToFirestore(Task task) async {
    try {
      final docRef = await firestore.collection('tasks').add(task.toMap());
      task.id = docRef.id;
      _playSound(addSoundPath); // Play add sound
      print('Task uploaded to Firestore: ${task.title}');
    } catch (e) {
      print('No internet connection. Saving task locally.');
      await _saveTaskLocally(task); // Simpan ke lokal jika gagal unggah
    }
  }

  // Update a task in Firestore
  Future<void> _updateTaskInFirestore(Task task) async {
    try {
      if (task.id != null) {
        await firestore.collection('tasks').doc(task.id).update(task.toMap());
        _playSound(editSoundPath); // Play edit sound when task is edited
      }
    } catch (e) {
      print('Error updating task in Firestore: $e');
    }
  }

  // Delete a task
  Future<void> deleteTask(Task task) async {
    try {
      if (task.id != null) {
        await firestore.collection('tasks').doc(task.id).delete();
        _playSound(deleteSoundPath); // Play delete sound
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  // Method to add a new task
  void addTask() {
    if (newTaskTitle.value.isNotEmpty) {
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

  // Toggle task done state
  void toggleTaskDone(int index) {
    final task = displayedTasks[index];
    task.done = !task.done;
    isTaskDone[index] = task.done;

    // Play sound only when task is marked as done
    if (task.done) {
      _playSound(editSoundPath);
    }

    _updateTaskInFirestore(task);
  }

  // Edit task
  void editTask(Task task, String newTitle, String newDescription) {
    task.title = newTitle;
    task.description = newDescription;

    _updateTaskInFirestore(task);
    _playSound(editSoundPath); // Play edit sound
  }

  // Speech-to-text feature for task description
  void toggleListening() async {
    if (isListening.value) {
      _speechToText.stop();
      isListening.value = false;
    } else {
      final available = await _speechToText.initialize(
        onStatus: (status) => print('Speech Status: $status'),
        onError: (error) => print('Speech Error: $error'),
      );

      if (available) {
        isListening.value = true;
        _speechToText.listen(onResult: (result) {
          newTaskDescription.value = result.recognizedWords;
        });
      }
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