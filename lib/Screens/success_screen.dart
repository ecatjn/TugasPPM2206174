import 'package:flutter/material.dart';
import 'login_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AlertDialog(
          title: Icon(Icons.check_circle, color: Colors.green, size: 48),
          content: Text("Sign Up Successful!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              child: Text("Go to Login"),
            )
          ],
        ),
      ),
    );
  }
}
