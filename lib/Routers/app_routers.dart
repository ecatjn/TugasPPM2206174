import 'package:flutter/material.dart';
import 'package:p9/Screens/splash_screen.dart';
import 'package:p9/Screens/onboarding_screen.dart';
import 'package:p9/Screens/login_screen.dart';
import 'package:p9/Screens/register_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
  };
}
