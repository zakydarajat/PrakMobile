import 'package:get/get.dart';
import '../../../data/models/todo_app.dart'; // Sesuaikan path
import '../../../data/services/http_controller.dart'; // Sesuaikan path

class HomeController extends GetxController {
  final HttpController httpController = HttpController();

  // State untuk menyimpan daftar tugas dan loading indicator
  var todos = <TodoElement>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodos(); // Panggil fetchTodos saat controller diinisialisasi
  }

  // Fungsi untuk mengambil todos dari API
  Future<void> fetchTodos() async {
    try {
      isLoading.value = true;
      final response = await httpController.getTodos();
      if (response != null) {
        todos.value = response.todos;
      }
    } catch (e) {
      print('Error fetching todos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk menambahkan todo baru
  Future<void> addTodo(TodoElement newTodo) async {
    final success = await httpController.addTodo(newTodo);
    if (success) {
      fetchTodos(); // Refresh todos setelah menambah task
    }
  }

  // Fungsi untuk menghapus todo berdasarkan ID
  Future<void> deleteTodo(int id) async {
    final success = await httpController.deleteTodo(id);
    if (success) {
      fetchTodos(); // Refresh todos setelah menghapus task
    }
  }
}
