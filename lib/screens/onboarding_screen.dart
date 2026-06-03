import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/app_theme.dart';
import 'google_signin_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Welcome Header
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Welcome to",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      color: isDark ? AppTheme.darkSecondaryTextColor : AppTheme.lightSecondaryTextColor,
                    ),
                  ),
                  Text(
                    "FlashCard Quiz!",
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),

              // Visual graphic showing cards/notes
              _buildGraphicWidget(),

              // Dynamic checklist features
              Column(
                children: [
                  _buildFeatureRow("Create your own flashcards", theme),
                  const SizedBox(height: 12),
                  _buildFeatureRow("Study and test your knowledge", theme),
                  const SizedBox(height: 12),
                  _buildFeatureRow("Edit or delete anytime", theme),
                  const SizedBox(height: 12),
                  _buildFeatureRow("Track your progress", theme),
                ],
              ),

              // Get Started CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('onboarding_completed', true);
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const GoogleSignInScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          return SlideTransition(position: animation.drive(tween), child: child);
                        },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 4,
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  Widget _buildGraphicWidget() {
    return Container(
      height: 180,
      width: 180,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(-25, 0),
              child: Transform.rotate(
                angle: -0.2,
                child: _buildOnboardingCard(AppTheme.primaryColor.withOpacity(0.3), Icons.lightbulb_outline),
              ),
            ),
            Transform.translate(
              offset: const Offset(25, 0),
              child: Transform.rotate(
                angle: 0.2,
                child: _buildOnboardingCard(AppTheme.primaryColor, Icons.check_circle_outline, isMain: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingCard(Color color, IconData icon, {bool isMain = false}) {
    return Container(
      width: 80,
      height: 110,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: AppTheme.primaryColor,
            size: 18,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
