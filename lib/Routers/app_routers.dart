// lib/routers/app_routers.dart
import 'package:flutter/material.dart';
import 'package:p9/Screens/splash_screen.dart';
import 'package:p9/Screens/onboarding_screen.dart';
import 'package:p9/Screens/login_screen.dart';
import 'package:p9/Screens/register_screen.dart';
import 'package:p9/Screens/success_screen.dart';
import 'package:p9/Screens/profile_screen.dart';
import 'package:p9/Screens/home_screen.dart';
import 'package:p9/Screens/bookmark_screen.dart';
import 'package:p9/Screens/detail_screen.dart';
import 'package:p9/Screens/add_news_screen.dart'; // FIX: Tambahkan import ini


class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String success = '/success';
  static const String home = '/home';
  static const String bookmark = '/bookmark';
  static const String profile = '/profile';
  static const String detail = '/detail';
  static const String addNews = '/add_news'; // FIX: Tambahkan rute baru

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    success: (context) => const SuccessScreen(),
    home: (context) => const HomeScreen(),
    bookmark: (context) => const BookmarkScreen(),
    profile: (context) => const ProfileScreen(),
    detail: (context) => const DetailScreen(article: {}),
    addNews: (context) => const AddNewsScreen(), // FIX: Tambahkan AddNewsScreen
  };
}