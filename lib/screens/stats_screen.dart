import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../themes/app_theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlashcardProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final progressVal = provider.studyProgressPercentage;
    final progressPct = (progressVal * 100).toInt();

    final categoryStats = provider.categoryProgressStats;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Progress",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Two Top Stats Panels (Matching the layout of reference images exactly!)
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryBox(
                      title: "Total Flashcards",
                      value: "${provider.totalCount}",
                      context: context,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryBox(
                      title: "Categories",
                      value: "${provider.categories.length - 1}", // Excludes "All"
                      context: context,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Study Progress Header
              Text(
                "Study Progress",
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Progress Card with circular chart ring & counts
              Card(
                elevation: 2,
                color: isDark ? AppTheme.darkSurfaceColor : AppTheme.lightSurfaceColor,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      // Beautiful Custom Circular Progress Ring
                      SizedBox(
                        height: 90,
                        width: 90,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: progressVal,
                              strokeWidth: 9,
                              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                              color: AppTheme.primaryColor,
                            ),
                            Text(
                              "$progressPct%",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      // Details count
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${provider.studiedCount}/${provider.totalCount}",
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Cards Studied",
                              style: TextStyle(
                                color: isDark ? AppTheme.darkSecondaryTextColor : AppTheme.lightSecondaryTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Categories Progress Header
              Text(
                "Categories Progress",
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // dynamic list of category progress bars
              if (categoryStats.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      "No category stats available yet.",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                )
              else
                ...categoryStats.entries.map((entry) {
                  final catName = entry.key;
                  final studied = entry.value[0];
                  final total = entry.value[1];
                  final ratio = total == 0 ? 0.0 : studied / total;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              catName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "$studied/$total",
                              style: TextStyle(
                                color: isDark ? AppTheme.darkSecondaryTextColor : AppTheme.lightSecondaryTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 10,
                            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBox({
    required String title,
    required String value,
    required BuildContext context,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurfaceColor : AppTheme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : AppTheme.primaryColor.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDark ? AppTheme.darkSecondaryTextColor : AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}
