import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/task/bindings/http_binding.dart';
import 'package:myapp/app/modules/webview/bindings/webview_binding.dart';
import 'package:myapp/app/modules/webview/views/webview_view.dart';
// import 'package:get/get.dart';
// import 'package:myapp/app/data/models/todo_app.dart';
// import '../../../data/services/http_controller.dart'; // Sesuaikan path
import '../../task/views/http_view.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Garis Hijau Atas
            Container(
              width: double.infinity,
              height: 58,
              color: Color(0xff9ef2be),
            ),
            // Expanded untuk memastikan ScrollView memiliki ruang fleksibel
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture and Hello Text
                      SizedBox(height: 24), // Sesuaikan jarak atas
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32, // Ukuran disesuaikan
                            backgroundColor: Color(0xff9ef2be),
                            child: Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello!',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'RobotoSlab-Regular',
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Zaky',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'RobotoSlab-Regular',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Task Information
                      Text(
                        'Today you have',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'RobotoSlab-Regular',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '2 Task',
                        style: TextStyle(
                          fontSize: 26,
                          fontFamily: 'RobotoSlab-Bold',
                          color: Color(0xff34794e),
                        ),
                      ),
                      SizedBox(height: 24), // Sesuaikan jarak antar elemen
                      // First Task Card
                      Container(
                        width: double.infinity,
                        height: 90, // Sesuaikan tinggi sesuai prototype
                        decoration: BoxDecoration(
                          color: Color(0xff34794e),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Praktikum Pemrograman Mobile',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'RobotoSlab-Bold',
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                  height: 8), // Sesuaikan jarak antara teks
                              Text(
                                '3 October 2024 | 04:55PM',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'RobotoSlab-Regular',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16), // Jarak antar tugas
                      // Second Task Card
                      Container(
                        width: double.infinity,
                        height: 90, // Sesuaikan tinggi sesuai prototype
                        decoration: BoxDecoration(
                          color: Color(0xff9ef2be),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Cukur Rambut',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'RobotoSlab-Bold',
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                  height: 8), // Sesuaikan jarak antara teks
                              Text(
                                '3 October 2024 | 07:30PM',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'RobotoSlab-Regular',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Tambah jarak di sini untuk memastikan tidak tumpang tindih
                      SizedBox(height: 24), // Jarak lebih besar
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Navigation Bar with 5 Icons
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 70, // Sesuaikan ukuran height Bottom Navigation Bar
              decoration: BoxDecoration(
                color: Color(0x99d9d9d9),
                borderRadius: BorderRadius.circular(27.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.black),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.task, color: Colors.black),
                    onPressed: () {
                      Get.to(() => HttpView(), binding: HttpBinding());
                    },
                  ),
                  // Custom "+" Icon with Green Color and Border
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xff34794e),
                        width: 3.0,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: Color(0xff34794e), size: 30),
                      onPressed: () {},
                    ),
                  ),
                  IconButton(
                    icon:
                        Icon(Icons.info_outline, color: Colors.black, size: 24),
                    onPressed: () {
                      Get.to(() => ToDoWebView(), binding: WebViewBinding());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Garis Hijau Bawah
            Container(
              width: double.infinity,
              height: 58,
              color: Color(0xff9ef2be),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String time;

  TaskCard({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff9ef2be),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'RobotoSlab-Bold',
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'RobotoSlab-Regular',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
