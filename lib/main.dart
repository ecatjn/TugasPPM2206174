// lib/main.dart
import 'package:flutter/material.dart';
import 'package:p9/routers/app_routers.dart'; // Pastikan path ini benar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Insight App', // Anda bisa ganti judul ini
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins', // Menerapkan Poppins sebagai font default aplikasi
      ),
      initialRoute: AppRoutes.splash, // Aplikasi akan dimulai dari SplashScreen
      routes: AppRoutes.routes, // Menggunakan map rute yang didefinisikan di AppRoutes
      debugShowCheckedModeBanner: false, // Menghilangkan banner "DEBUG" di pojok kanan atas
    );
  }
}