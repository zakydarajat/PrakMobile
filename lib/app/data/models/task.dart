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
