import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../themes/app_theme.dart';
import 'card_list_screen.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlashcardProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FlashCard Quiz",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FlashcardSearchDelegate(provider),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              // Total Flashcards banner exactly matching the reference design!
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppTheme.purpleGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Flashcards",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${provider.totalCount}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),

              // Categories Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CardListScreen(category: 'All'),
                        ),
                      );
                    },
                    child: const Text(
                      "See All",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Build Dynamic Categories List (matching reference icons and colors!)
              ...(() {
                final displayCats = provider.categories.where((cat) => cat != 'All').toList();
                
                // Fallbacks for custom category icons and colors
                final Map<String, Map<String, dynamic>> catMeta = {
                  "General Knowledge": {
                    "icon": Icons.public,
                    "iconColor": const Color(0xFF00BFA5),
                    "bgColor": const Color(0xFFE0F2F1),
                  },
                  "Computer Science": {
                    "icon": Icons.computer,
                    "iconColor": const Color(0xFFFF9100),
                    "bgColor": const Color(0xFFFFF3E0),
                  },
                  "Science": {
                    "icon": Icons.science,
                    "iconColor": const Color(0xFF00E676),
                    "bgColor": const Color(0xFFE8F5E9),
                  },
                };

                return displayCats.map((cat) {
                  final meta = catMeta[cat] ?? {
                    "icon": Icons.folder_open,
                    "iconColor": AppTheme.primaryColor,
                    "bgColor": AppTheme.primaryColor.withOpacity(0.1),
                  };

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildCategoryCard(
                      context: context,
                      title: cat,
                      count: provider.flashcards.where((c) => c.category == cat).length,
                      icon: meta["icon"] as IconData,
                      iconColor: meta["iconColor"] as Color,
                      bgColor: meta["bgColor"] as Color,
                      isDark: isDark,
                    ),
                  );
                }).toList();
              }()),

              const SizedBox(height: 10),

              // Add Custom Category button
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _showAddCategoryDialog(context, provider),
                  icon: const Icon(Icons.folder_open, color: AppTheme.primaryColor),
                  label: const Text(
                    "Add Custom Category",
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.3), width: 1.5),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
 
              // Add Flashcard floating-style inline action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddEditScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Add Flashcard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, FlashcardProvider provider) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add Custom Category"),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: "Enter category name",
            ),
            textCapitalization: TextCapitalization.words,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final name = textController.text.trim();
                Navigator.pop(ctx);
                if (name.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditScreen(preselectedCategory: name),
                    ),
                  );
                }
              },
              child: const Text("Next"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required int count,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required bool isDark,
  }) {
    return Card(
      elevation: 0,
      color: isDark ? AppTheme.darkSurfaceColor : AppTheme.lightSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CardListScreen(category: title),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            children: [
              // Styled Icon container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? iconColor.withOpacity(0.15) : bgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              // Category Title and Card count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$count Cards",
                      style: TextStyle(
                        color: isDark ? AppTheme.darkSecondaryTextColor : AppTheme.lightSecondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isDark ? Colors.white30 : Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Search Delegate matching search parameters
class FlashcardSearchDelegate extends SearchDelegate {
  final FlashcardProvider provider;

  FlashcardSearchDelegate(this.provider);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    provider.updateSearchQuery(query);
    final results = provider.filteredFlashcards;

    if (results.isEmpty) {
      return const Center(child: Text("No flashcards found"));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final card = results[index];
        return ListTile(
          title: Text(card.question),
          subtitle: Text("Category: ${card.category}"),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CardListScreen(category: card.category),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    provider.updateSearchQuery(query);
    final suggestions = provider.filteredFlashcards;

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final card = suggestions[index];
        return ListTile(
          title: Text(card.question),
          subtitle: Text("Category: ${card.category}"),
          onTap: () {
            query = card.question;
            showResults(context);
          },
        );
      },
    );
  }
}
