import 'package:flutter/material.dart';
import '../routers/app_routers.dart';
import 'dart:developer' as developer; // Used for logging

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  // Define primary colors for consistency
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color backgroundColor = Color(0xFFFAEBD7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Warna latar belakang sesuai desain (krem/peach muda)
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar ilustrasi sukses
              // Pastikan 'assets/success.png' ada dan dideklarasikan di pubspec.yaml
              Image.asset('assets/dialog.png', height: 180),
              const SizedBox(height: 32),

              // Judul sukses
              const Text(
                'Success!', // Mengubah teks judul
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32, // Ukuran font lebih besar
                  fontWeight: FontWeight.w900, // Ketebalan Poppins Black/ExtraBold
                  color: primaryPurple, // Warna ungu
                  fontFamily: 'Poppins', // Menggunakan font Poppins
                ),
              ),
              const SizedBox(height: 16),

              // Teks penjelasan
              const Text(
                'Your action was completed successfully.', // Mengubah teks penjelasan
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54, // Warna teks
                  fontFamily: 'Poppins', // Menggunakan font Poppins
                ),
              ),
              const SizedBox(height: 40), // Jarak sebelum tombol

              // Tombol untuk melanjutkan
              SizedBox(
                width: double.infinity, // Lebar penuh
                height: 50, // Tinggi tombol
                child: ElevatedButton(
                  onPressed: () {
                    developer.log('Go to Home/Login button pressed!');
                    // Anda bisa pilih mau ke Home atau Login, tergantung alur aplikasi
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple, // Warna ungu
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Sudut membulat
                    ),
                  ),
                  child: const Text(
                    'Login', // Mengubah teks tombol, sesuaikan ke Home jika perlu
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins', // Menggunakan font Poppins
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}