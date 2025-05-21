// lib/helpers/form_validator.dart
String? validateEmail(String? v) {
  if (v == null || v.isEmpty) {
    return 'Email can\'t be empty';
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
    return 'Enter a valid email';
  }
  return null;
}

String? validatePassword(String? v) {
  if (v == null || v.isEmpty) {
    return 'Password can\'t be empty';
  }
  if (v.length < 8) {
    return 'Min 8 characters';
  }
  if (!RegExp(r'^(?=.*[a-z])(?=.*[0-9]).{8,}$').hasMatch(v)) {
    return 'Must contain letters & numbers';
  }
  return null;
}
