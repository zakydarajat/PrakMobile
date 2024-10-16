import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo_app.dart'; // Sesuaikan path jika file Todo model berbeda

class HttpController {
  final String baseUrl = 'https://dummyjson.com/todos'; // Ganti sesuai endpoint API

  // GET: Mendapatkan semua todos
  Future<Todo?> getTodos({int skip = 0, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?skip=$skip&limit=$limit'),
      );
      if (response.statusCode == 200) {
        return todoFromJson(response.body);
      } else {
        print('Failed to load todos: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // POST: Menambahkan todo baru
  Future<bool> addTodo(TodoElement newTodo) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newTodo.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // PUT: Mengupdate todo berdasarkan ID
  Future<bool> updateTodo(int id, TodoElement updatedTodo) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedTodo.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // DELETE: Menghapus todo berdasarkan ID
  Future<bool> deleteTodo(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
