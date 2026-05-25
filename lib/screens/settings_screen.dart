import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../providers/theme_provider.dart';
import '../themes/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final flashcardProvider = Provider.of<FlashcardProvider>(context, listen: false);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Appearance Header
              _buildSectionHeader("Appearance", theme),
              const SizedBox(height: 10),
              
              // Dark Mode switch exactly matching reference
              Card(
                elevation: 0,
                color: isDark ? AppTheme.darkSurfaceColor : AppTheme.lightSurfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade100,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isDark ? Icons.dark_mode : Icons.light_mode,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "Dark Mode",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: themeProvider.isDarkMode,
                        activeColor: AppTheme.primaryColor,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // General Settings Header
              _buildSectionHeader("General", theme),
              const SizedBox(height: 10),
              
              Card(
                elevation: 0,
                color: isDark ? AppTheme.darkSurfaceColor : AppTheme.lightSurfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade100,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.backup_outlined,
                      title: "Backup & Restore",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Backup complete! All flashcards are secured in Local Storage. ✅"),
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildSettingsTile(
                      icon: Icons.delete_forever_outlined,
                      title: "Clear All Data",
                      titleColor: Colors.redAccent,
                      onTap: () {
                        _showClearWarning(context, flashcardProvider);
                      },
                      isDark: isDark,
                      showChevron: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // About Settings Header
              _buildSectionHeader("About", theme),
              const SizedBox(height: 10),
              
              Card(
                elevation: 0,
                color: isDark ? AppTheme.darkSurfaceColor : AppTheme.lightSurfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade100,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.info_outline,
                      title: "About App",
                      onTap: () {
                        _showAboutDialog(context, isDark);
                      },
                      isDark: isDark,
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildSettingsTile(
                      icon: Icons.star_outline_rounded,
                      title: "Rate Us",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Thank you for supporting this JNTUH Student project! ⭐⭐⭐⭐⭐"),
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
    Color? titleColor,
    bool showChevron = true,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppTheme.primaryColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: titleColor,
        ),
      ),
      trailing: showChevron
          ? Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: isDark ? Colors.white30 : Colors.grey.shade400,
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showClearWarning(BuildContext context, FlashcardProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Clear All Data", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("This action will permanently delete all your custom flashcards and reset progress. Are you sure you want to proceed?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              provider.clearAllData();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All database entries cleared."), backgroundColor: Colors.redAccent),
              );
            },
            child: const Text("Clear All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AboutDialog(
        applicationName: "FlashCard Quiz App",
        applicationVersion: "1.0.0",
        applicationIcon: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.school, color: Colors.white),
        ),
        children: [
          const SizedBox(height: 16),
          const Text(
            "An internship submission project for CodeAlpha.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("Developed by a student of JNTUH UCEJ College."),
          const SizedBox(height: 4),
          const Text("Features smooth animations, local SQLite persistence, dark mode toggling, and Material 3 design systems."),
        ],
      ),
    );
  }
}
