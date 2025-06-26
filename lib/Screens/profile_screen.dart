// my_diginst_app/lib/Screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:hellapps/routers/app_routers.dart'; // Sesuaikan import
import 'dart:developer' as developer;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color primaryYellow = Color(0xFFFFB62F);
  static const Color lightYellow = Color(0xFFFFD89C);

  int _currentIndex = 2; // Default selected index for Profile tab

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.bookmark);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, AppRoutes.profile);
    }
    developer.log('Bottom Navigation Tapped from Profile: Index $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: primaryYellow,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Image.asset('assets/diginst.png', width: 40, height: 40),
                  const SizedBox(width: 8),
                  const Text(
                    'DIGITAL INSIGHT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Profile',
                  style: TextStyle(
                    color: primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            Card(
              color: lightYellow,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: const AssetImage('assets/profile.png'),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Nama', 'Yasa Tiyas Ilyasin'),
                    _buildInfoRow('Phone', '085*******0'),
                    _buildInfoRow('Email', 'yasailyas**@gmail.com'),
                    _buildInfoRow('Address', 'Jl. Contoh No. 123, Kota ABC'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildMenuItem(Icons.edit, 'Edit Profile'),
            _buildMenuItem(Icons.lock, 'Edit Password'),
            _buildMenuItem(Icons.logout, 'Logout'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label: ',
              style: const TextStyle(
                color: primaryPurple,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: primaryPurple),
      title: Text(label, style: const TextStyle(color: primaryPurple, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: primaryPurple),
      onTap: () {
        developer.log('Menu item tapped: $label');
      },
    );
  }
}