import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/tour_provider.dart';
import '../../providers/notification_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _ctrl.forward();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    await context.read<AuthProvider>().checkAuthStatus();
    if (!mounted) return;
    context.read<NotificationProvider>().load();
    await context.read<ProductProvider>().loadProducts();
    if (!mounted) return;
    await context.read<TourProvider>().loadData();
    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // Check if first time
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _WovenLogo(size: 80),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('iWeave',
                  style: TextStyle(
                    fontSize: 36, fontWeight: FontWeight.w800,
                    color: Colors.white, letterSpacing: -0.5,
                    fontFamily: 'Poppins',
                  )),
                const SizedBox(height: 8),
                Text(
                  'Crafting Unforgettable Experiences,\nOne Tikog at A Time!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13, color: Colors.white.withOpacity(0.8),
                    height: 1.5, fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: 32, height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WovenLogo extends StatelessWidget {
  final double size;
  const _WovenLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _WovenPatternPainter(),
    );
  }
}

class _WovenPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFFE8732A), const Color(0xFFFFD700), const Color(0xFF4CAF50),
      const Color(0xFF2196F3), const Color(0xFFE91E63), Colors.white,
    ];
    final paint = Paint()..strokeWidth = size.width / 12..strokeCap = StrokeCap.round;
    final step = size.width / 6;

    for (int i = 0; i < 6; i++) {
      paint.color = colors[i % colors.length];
      canvas.drawLine(
        Offset(i * step + step / 2, 0),
        Offset(i * step + step / 2, size.height),
        paint,
      );
    }
    for (int i = 0; i < 6; i++) {
      paint.color = colors[(i + 2) % colors.length].withOpacity(0.7);
      canvas.drawLine(
        Offset(0, i * step + step / 2),
        Offset(size.width, i * step + step / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
