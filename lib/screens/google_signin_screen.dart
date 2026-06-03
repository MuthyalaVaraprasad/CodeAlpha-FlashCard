import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/app_theme.dart';
import 'main_navigation_screen.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool _isLoading = false;

  void _handleGoogleSignIn() {
    setState(() {
      _isLoading = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Connecting to Google Auth..."),
        duration: Duration(milliseconds: 1000),
      ),
    );

    Timer(const Duration(milliseconds: 1800), () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('user_authenticated', true);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Signed in with Google! 🚀"),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 1000),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      }
    });
  }

  void _handleGuestSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Entering as Guest..."),
        duration: Duration(milliseconds: 800),
      ),
    );
    Timer(const Duration(milliseconds: 800), () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('user_authenticated', true);
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              
              // Auth Header with shield icon
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      size: 44,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Secure Access",
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.lightTextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Sign in to save and sync your study decks",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? AppTheme.darkSecondaryTextColor : AppTheme.lightSecondaryTextColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),

              // Sign-in Card
              Card(
                elevation: 0,
                color: isDark ? AppTheme.darkSurfaceColor : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Google Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(
                              color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            backgroundColor: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: AppTheme.primaryColor,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Custom vector G representation
                                    Container(
                                      width: 22,
                                      height: 22,
                                      margin: const EdgeInsets.only(right: 12),
                                      child: CustomPaint(
                                        painter: GoogleIconPainter(),
                                      ),
                                    ),
                                    Text(
                                      "Sign in with Google",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Divider OR
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: isDark ? Colors.white12 : Colors.grey.shade300,
                              thickness: 1.2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "or",
                              style: TextStyle(
                                color: isDark ? AppTheme.darkSecondaryTextColor : AppTheme.lightSecondaryTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: isDark ? Colors.white12 : Colors.grey.shade300,
                              thickness: 1.2,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Guest Bypass Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: TextButton(
                          onPressed: _isLoading ? null : _handleGuestSignIn,
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Continue as Guest",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Auth Policy Footer
              Text.rich(
                TextSpan(
                  text: "By signing in, you agree to our \n",
                  children: [
                    TextSpan(
                      text: "Terms of Service",
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: " & "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppTheme.darkSecondaryTextColor : AppTheme.lightSecondaryTextColor,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter to draw a clean Google logo vector
class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    
    // G letter path coordinates
    final Path redPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.43)
      ..lineTo(size.width * 0.5, size.height * 0.6)
      ..lineTo(size.width * 0.78, size.height * 0.6)
      ..cubicTo(size.width * 0.75, size.height * 0.77, size.width * 0.64, size.height * 0.88, size.width * 0.5, size.height * 0.88)
      ..cubicTo(size.width * 0.29, size.height * 0.88, size.width * 0.12, size.height * 0.71, size.width * 0.12, size.height * 0.5)
      ..cubicTo(size.width * 0.12, size.height * 0.29, size.width * 0.29, size.height * 0.12, size.width * 0.5, size.height * 0.12)
      ..cubicTo(size.width * 0.61, size.height * 0.12, size.width * 0.7, size.height * 0.16, size.width * 0.77, size.height * 0.23)
      ..lineTo(size.width * 0.89, size.height * 0.11)
      ..cubicTo(size.width * 0.79, size.height * 0.02, size.width * 0.65, size.height * -0.05, size.width * 0.5, size.height * -0.05)
      ..cubicTo(size.width * 0.19, size.height * -0.05, size.width * -0.05, size.height * 0.19, size.width * -0.05, size.height * 0.5)
      ..cubicTo(size.width * -0.05, size.height * 0.81, size.width * 0.19, size.height * 1.05, size.width * 0.5, size.height * 1.05)
      ..cubicTo(size.width * 0.81, size.height * 1.05, size.width * 1.05, size.height * 0.81, size.width * 1.05, size.height * 0.5)
      ..cubicTo(size.width * 1.05, size.height * 0.48, size.width * 1.05, size.height * 0.45, size.width * 1.04, size.height * 0.43)
      ..close();
      
    // Simplified Google color mapping (red-orange branding fill)
    paint.color = const Color(0xFFEA4335);
    canvas.drawPath(redPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
