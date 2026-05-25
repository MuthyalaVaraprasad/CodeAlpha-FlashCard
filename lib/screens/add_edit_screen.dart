import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard_model.dart';
import '../providers/flashcard_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/delete_confirmation_dialog.dart';

class AddEditScreen extends StatefulWidget {
  final Flashcard? card; // Null represents Adding new card, non-null is Editing
  final String? preselectedCategory;

  const AddEditScreen({super.key, this.card, this.preselectedCategory});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late TextEditingController _answerController;
  
  String? _selectedCategory;
  late List<String> _staticCategories;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.card?.question ?? '');
    _answerController = TextEditingController(text: widget.card?.answer ?? '');
    
    _staticCategories = ["General Knowledge", "Computer Science", "Science"];
    
    // Load existing custom categories from provider
    final provider = Provider.of<FlashcardProvider>(context, listen: false);
    for (var cat in provider.categories) {
      if (cat != 'All' && !_staticCategories.contains(cat)) {
        _staticCategories.add(cat);
      }
    }

    // Assign preselected or existing category, fallback to GK
    _selectedCategory = widget.card?.category ?? widget.preselectedCategory;
    if (_selectedCategory == null || _selectedCategory == 'All') {
      _selectedCategory = _staticCategories[0];
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<FlashcardProvider>(context, listen: false);

    if (widget.card == null) {
      // Create new Flashcard
      await provider.addFlashcard(
        _questionController.text.trim(),
        _answerController.text.trim(),
        _selectedCategory!,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Flashcard saved successfully!"), backgroundColor: Colors.green),
        );
      }
    } else {
      // Update existing Flashcard
      final updated = widget.card!.copyWith(
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
        category: _selectedCategory!,
      );
      await provider.updateFlashcard(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Flashcard updated successfully!"), backgroundColor: Colors.green),
        );
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = widget.card != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Flashcard" : "Add Flashcard",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question field label & card
                Text(
                  "Question",
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _questionController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 16),
                  decoration: _buildInputDecoration(
                    hint: "Enter your question",
                    isDark: isDark,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Question field cannot be empty";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Answer field label & card
                Text(
                  "Answer",
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _answerController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 16),
                  decoration: _buildInputDecoration(
                    hint: "Enter the answer",
                    isDark: isDark,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Answer field cannot be empty";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Category field label & card dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Category",
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    TextButton.icon(
                      onPressed: _showAddCategoryDialog,
                      icon: const Icon(Icons.add, size: 18, color: AppTheme.primaryColor),
                      label: const Text(
                        "Add Custom",
                        style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkSurfaceColor : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryColor),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      items: _staticCategories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Main CTA Save/Update button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 2,
                    ),
                    child: Text(
                      isEditing ? "Update Flashcard" : "Save Flashcard",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // In Edit mode show "Delete Flashcard" secondary option
                if (isEditing) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => DeleteConfirmationDialog(
                            onDelete: () {
                              final provider = Provider.of<FlashcardProvider>(context, listen: false);
                              provider.deleteFlashcard(widget.card!.id!);
                              Navigator.pop(context); // Close Edit Screen
                            },
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Delete Flashcard",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hint, required bool isDark}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      fillColor: isDark ? AppTheme.darkSurfaceColor : Colors.grey.shade50,
      filled: true,
      contentPadding: const EdgeInsets.all(20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppTheme.primaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
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
                if (name.isNotEmpty) {
                  setState(() {
                    if (!_staticCategories.contains(name)) {
                      _staticCategories.add(name);
                    }
                    _selectedCategory = name;
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
