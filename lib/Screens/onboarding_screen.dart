import 'package:flutter/material.dart';
import '../routers/app_routers.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Insight. Explore. Evolve.',
      'subtitle': 'Dapatkan wawasan terkini, jelajahi dunia teknologi, dan berkembang bersama Digital Insight.',
      'image': 'assets/introsatu.png'
    },
    {
      'title': 'Update. Understand. Advance.',
      'subtitle': 'Selalu terupdate, pahami teknologi dengan mudah, dan melangkah lebih maju.',
      'image': 'assets/introdua.png'
    },
    {
      'title': 'Learn. Adapt. Lead.',
      'subtitle': 'Pelajari teknologi terbaru, beradaptasi, dan jadilah pemimpin di era digital.',
      'image': 'assets/introtiga.png'
    },
  ];

  void _nextPage() {
    if (_currentPage < 2) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _onboardingData.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(data['image']!, height: 250),
                      const SizedBox(height: 40),
                      Text(
                        data['title']!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data['subtitle']!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Indicator + Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(_onboardingData.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 12 : 8,
                      height: _currentPage == index ? 12 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.deepPurple : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: Text(
                    _currentPage == 2 ? 'Get Started' : 'Next',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
