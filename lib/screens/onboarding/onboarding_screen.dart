import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  final _pages = const [
    _OnboardPage(
      icon: Icons.shopping_bag_rounded,
      title: 'Authentic Banig\nProducts',
      subtitle: 'Browse and customize handwoven tikog products — bags, mats, slippers, and more — crafted by Basey\'s master weavers.',
      color: AppColors.primary,
    ),
    _OnboardPage(
      icon: Icons.explore_rounded,
      title: 'Immersive Cultural\nExperiences',
      subtitle: 'Book unique tours around Basey, Samar. Visit Saob Cave, the Natural Bridge, historic churches, and join weaving workshops.',
      color: Color(0xFF5D1030),
    ),
    _OnboardPage(
      icon: Icons.people_rounded,
      title: 'Connect with\nLocal Artisans',
      subtitle: 'Meet the weavers behind every product. Learn their stories, techniques, and how your purchase supports their communities.',
      color: Color(0xFF3D0A20),
    ),
  ];

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _pages[i],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Skip', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _page ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _page ? Colors.white : Colors.white38,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: _page == _pages.length - 1 ? 'Start Weaving' : 'Next',
                    onPressed: _next,
                    color: Colors.white,
                  ),
                  if (_page == _pages.length - 1) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? ', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardPage({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color, color.withRed((color.red + 30).clamp(0, 255))],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 60, 32, 160),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160, height: 160,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 80, color: Colors.white),
              ),
              const SizedBox(height: 48),
              Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30, fontWeight: FontWeight.w800,
                  color: Colors.white, height: 1.2, fontFamily: 'Poppins',
                )),
              const SizedBox(height: 20),
              Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15, color: Colors.white.withOpacity(0.85),
                  height: 1.6, fontFamily: 'Poppins',
                )),
            ],
          ),
        ),
      ),
    );
  }
}
