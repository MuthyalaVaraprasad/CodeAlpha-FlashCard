import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/flip_card.dart';
import 'add_edit_screen.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlashcardProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cards = provider.filteredFlashcards;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Study Deck",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // Category Deck Dropdown Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurfaceColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: provider.selectedCategory,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryColor),
                  onChanged: (String? value) {
                    if (value != null) {
                      provider.setCategoryFilter(value);
                    }
                  },
                  items: provider.categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value == 'All' ? "All Categories" : value,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (cards.isEmpty)
              Expanded(
                child: _buildEmptyState(context, provider.selectedCategory),
              )
            else ...[
              // Progress indicator e.g. "3/12 cards"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.selectedCategory,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.darkSecondaryTextColor : AppTheme.lightSecondaryTextColor,
                    ),
                  ),
                  Text(
                    "${provider.currentStudyIndex + 1}/${cards.length}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Horizontal linear progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (provider.currentStudyIndex + 1) / cards.length,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  color: AppTheme.primaryColor,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 30),

              // Large 3D Flashcard showing Front/Back!
              Expanded(
                child: FlipCard(
                  isFlipped: provider.isCardFlipped,
                  onTap: () {
                    provider.setCardFlipped(!provider.isCardFlipped);
                  },
                  front: _buildCardFace(
                    context: context,
                    text: cards[provider.currentStudyIndex].question,
                    isFront: true,
                    isDark: isDark,
                  ),
                  back: _buildCardFace(
                    context: context,
                    text: cards[provider.currentStudyIndex].answer,
                    isFront: false,
                    isDark: isDark,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Study evaluation controls ("Know It" / "Still Learning" buttons)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      provider.toggleCardStudied(
                        cards[provider.currentStudyIndex].id!,
                        false,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Marked: Need to review this card later!"),
                          duration: Duration(milliseconds: 600),
                        ),
                      );
                    },
                    icon: const Icon(Icons.close, color: Colors.red),
                    label: const Text("Still Learning", style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.toggleCardStudied(
                        cards[provider.currentStudyIndex].id!,
                        true,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Amazing! Marked as Studied! 🚀"),
                          duration: Duration(milliseconds: 600),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text("Know It!", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.emerald,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Navigation Buttons Row matching the mock exactly
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  IconButton(
                    onPressed: provider.prevCard,
                    icon: const Icon(Icons.arrow_back_ios_new),
                    padding: const EdgeInsets.all(16),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark ? AppTheme.darkSurfaceColor : Colors.white,
                      elevation: 2,
                    ),
                  ),
                  // Center Primary Flip Action
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          provider.setCardFlipped(!provider.isCardFlipped);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          provider.isCardFlipped ? "Hide Answer" : "Show Answer",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Next Button
                  IconButton(
                    onPressed: provider.nextCard,
                    icon: const Icon(Icons.arrow_forward_ios),
                    padding: const EdgeInsets.all(16),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark ? AppTheme.darkSurfaceColor : Colors.white,
                      elevation: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardFace({
    required BuildContext context,
    required String text,
    required bool isFront,
    required bool isDark,
  }) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.08),
      color: isDark ? AppTheme.darkSurfaceColor : AppTheme.lightSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
          width: 2,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isFront ? "QUESTION" : "ANSWER",
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Icon(
              isFront ? Icons.flip : Icons.check_circle_outline,
              color: Colors.grey.shade400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String category) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_outlined,
              size: 64,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No Cards Available",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            "Add a card to your $category deck\nto begin studying!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEditScreen(preselectedCategory: category)),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Create Card", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
