import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Timer untuk pindah ke Login Page
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      backgroundColor: Colors.green[800], // Latar belakang hijau gelap
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo atau Icon
            Icon(
              Icons.task_alt, // Ikon todo
              color: Colors.white,
              size: 100,
            ),
            SizedBox(height: 20),
            // Text Aplikasi
            Text(
              "Todo App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(
              color: Colors.white, // Indikator loading
            ),
          ],
        ),
      ),
    );
  }
}
