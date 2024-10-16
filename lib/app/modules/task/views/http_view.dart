import 'package:flutter/material.dart';
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
    // Memanggil API untuk mendapatkan data saat widget diinisialisasi
    _futureTodos = _controller.getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos List'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<Todo?>(
        future: _futureTodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Status loading
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Jika terjadi error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.todos.isEmpty) {
            // Jika data kosong atau tidak ada todos
            return Center(child: Text('No todos available'));
          } else {
            // Jika data berhasil dimuat
            final todos = snapshot.data!.todos;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: todo.completed ? Colors.green : Colors.red,
                    child: Icon(
                      todo.completed ? Icons.check : Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(todo.todo),
                  subtitle: Text('User ID: ${todo.userId}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
