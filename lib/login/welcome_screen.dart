// wealthwise_welcome_screen.dart
//
// Welcome / onboarding screen for WealthWise.
//
// pubspec.yaml:
//   dependencies:
//     flutter_svg: ^2.0.10+1
//
//   flutter:
//     assets:
//       - assets/images/welcome_illustration.svg

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wealthwise/login/login_screen.dart';
import 'package:wealthwise/login/signup_screen.dart';

class WealthWiseWelcomeScreen extends StatelessWidget {
  const WealthWiseWelcomeScreen({super.key});

  static const Color cream = Color(0xFFFAF6EC);
  static const Color darkGreen = Color(0xFF1F4D2C);
  static const Color midGreen = Color(0xFF4C7A4F);
  static const Color textGrey = Color(0xFF6E6E6E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _Logo(darkGreen: darkGreen),
              const SizedBox(height: 8),
              Text(
                'Track. Analyze. Grow.',
                style: TextStyle(fontSize: 16, color: textGrey),
              ),

              // Illustration placeholder — drop your SVG into
              // assets/images/welcome_illustration.svg
              SizedBox(
                height: 320,
                child: SvgPicture.asset(
                  'assets/images/welcomee.svg',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 1),
              Text(
                'Take Control of Your Wealth',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'All your assets. One place. Smarter decisions.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: textGrey),
              ),
              const SizedBox(height: 28),
              // Log In button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person, color: Colors.white),
                  label: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: midGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Sign Up button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpScreen(),
                    ),
                    );
                  },
                  icon: Icon(Icons.person_add_alt_1, color: darkGreen),
                  label: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: darkGreen, width: 1.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
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

/// App logo: little bar-chart-with-arrow icon + wordmark.
class _Logo extends StatelessWidget {
  final Color darkGreen;
  const _Logo({required this.darkGreen});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 56,
          child: CustomPaint(painter: _BarArrowPainter(color: darkGreen)),
        ),
        const SizedBox(height: 8),
        Text(
          'WealthWise',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: darkGreen,
          ),
        ),
      ],
    );
  }
}

class _BarArrowPainter extends CustomPainter {
  final Color color;
  _BarArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()..color = color;

    // three bars of increasing height
    final barWidth = size.width / 5;
    final bars = [0.45, 0.7, 1.0];
    for (int i = 0; i < bars.length; i++) {
      final h = size.height * 0.55 * bars[i];
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(i * (barWidth + 4), size.height - h, barWidth, h),
        const Radius.circular(3),
      );
      canvas.drawRRect(rect, barPaint);
    }

    // arrow above the bars
    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height * 0.35)
      ..lineTo(size.width * 0.45, size.height * 0.1)
      ..lineTo(size.width * 0.85, size.height * 0.25);
    canvas.drawPath(path, arrowPaint);

    // arrowhead
    final headPaint = Paint()..color = color;
    final headPath = Path()
      ..moveTo(size.width * 0.85, size.height * 0.25)
      ..lineTo(size.width * 0.68, size.height * 0.18)
      ..lineTo(size.width * 0.8, size.height * 0.40)
      ..close();
    canvas.drawPath(headPath, headPaint);
  }

  @override
  bool shouldRepaint(covariant _BarArrowPainter oldDelegate) => false;
}
