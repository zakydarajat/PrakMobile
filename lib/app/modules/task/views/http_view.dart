// lib\app\modules\task\views\http_view.dart

import 'package:flutter/material.dart';
import 'package:myapp/app/modules/home/views/custom_bottom_navbar.dart';
import '../../../data/services/http_controller.dart';
import '../../../data/models/todo_app.dart';

class HttpView extends StatefulWidget {
  @override
  _HttpViewState createState() => _HttpViewState();
}

class _HttpViewState extends State<HttpView> {
  final HttpController _controller = HttpController();
  late Future<Todo?> _futureTodos;

  @override
  void initState() {
    super.initState();
    // Fetch API data when the widget is initialized
    _futureTodos = _controller.getTodos();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xff34794e);
    final backgroundColor = Colors.white;
    final accentColor = Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos List'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // The main content
          Positioned.fill(
            child: FutureBuilder<Todo?>(
              future: _futureTodos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Loading status
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // If an error occurs
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.todos.isEmpty) {
                  // If data is empty or there are no todos
                  return Center(child: Text('No todos available'));
                } else {
                  // If data is successfully loaded
                  final todos = snapshot.data!.todos;
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                todo.completed ? accentColor : Colors.red,
                            child: Icon(
                              todo.completed ? Icons.check : Icons.close,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            todo.todo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            'User ID: ${todo.userId}',
                            style: TextStyle(color: Colors.black54),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor,
                            size: 16,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          // The floating navigation bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
    );
  }
}
