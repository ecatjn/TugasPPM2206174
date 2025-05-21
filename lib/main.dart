import 'package:flutter/material.dart';
import 'Routers/app_routers.dart';

void main() {
  runApp(const NewsHiveApp());
}

class NewsHiveApp extends StatelessWidget {
  const NewsHiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Hive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
