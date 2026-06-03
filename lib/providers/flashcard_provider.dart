import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../models/flashcard_model.dart';

class FlashcardProvider with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();
  
  List<Flashcard> _flashcards = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  int _currentStudyIndex = 0;
  bool _isCardFlipped = false;
  String _searchQuery = "";
  List<String> _studyHistory = [];

  // Getters
  List<Flashcard> get flashcards => _flashcards;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  int get currentStudyIndex => _currentStudyIndex;
  bool get isCardFlipped => _isCardFlipped;
  String get searchQuery => _searchQuery;
  List<String> get studyHistory => _studyHistory;

  // Filtered lists based on Category and Search Query
  List<Flashcard> get filteredFlashcards {
    return _flashcards.where((card) {
      final matchesCategory = _selectedCategory == 'All' || card.category == _selectedCategory;
      final matchesSearch = card.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            card.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Get list of unique categories
  List<String> get categories {
    final Set<String> uniqueCats = {'All'};
    for (var card in _flashcards) {
      uniqueCats.add(card.category);
    }
    return uniqueCats.toList();
  }

  // Study metrics getters
  int get totalCount => _flashcards.length;
  int get studiedCount => _flashcards.where((c) => c.isStudied).length;
  double get studyProgressPercentage {
    if (totalCount == 0) return 0.0;
    return studiedCount / totalCount;
  }

  // Category specific stats helper
  Map<String, List<int>> get categoryProgressStats {
    final Map<String, List<int>> stats = {}; // Category -> [StudiedCount, TotalCount]
    for (var card in _flashcards) {
      if (!stats.containsKey(card.category)) {
        stats[card.category] = [0, 0];
      }
      stats[card.category]![1] += 1;
      if (card.isStudied) {
        stats[card.category]![0] += 1;
      }
    }
    return stats;
  }

  // --- Core Methods ---

  // Load Flashcards from DB
  Future<void> loadFlashcards() async {
    _isLoading = true;
    notifyListeners();

    try {
      _flashcards = await _dbHelper.fetchAllFlashcards();
      await loadStudyHistory();
    } catch (e) {
      debugPrint("Error loading flashcards: $e");
    } finally {
      _isLoading = false;
      _currentStudyIndex = 0;
      _isCardFlipped = false;
      notifyListeners();
    }
  }

  Future<void> loadStudyHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _studyHistory = prefs.getStringList('flashcard_study_history') ?? [];
    notifyListeners();
  }

  // Add Flashcard
  Future<void> addFlashcard(String question, String answer, String category) async {
    final newCard = Flashcard(
      question: question,
      answer: answer,
      category: category,
    );
    try {
      final id = await _dbHelper.insertFlashcard(newCard);
      _flashcards.add(newCard.copyWith(id: id));
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding flashcard: $e");
    }
  }

  // Update Flashcard
  Future<void> updateFlashcard(Flashcard updatedCard) async {
    try {
      await _dbHelper.updateFlashcard(updatedCard);
      final index = _flashcards.indexWhere((c) => c.id == updatedCard.id);
      if (index != -1) {
        _flashcards[index] = updatedCard;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error updating flashcard: $e");
    }
  }

  // Delete Flashcard
  Future<void> deleteFlashcard(int id) async {
    try {
      await _dbHelper.deleteFlashcard(id);
      _flashcards.removeWhere((c) => c.id == id);
      if (_currentStudyIndex >= filteredFlashcards.length && _currentStudyIndex > 0) {
        _currentStudyIndex = filteredFlashcards.length - 1;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting flashcard: $e");
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    try {
      await _dbHelper.clearAll();
      _flashcards.clear();
      _currentStudyIndex = 0;
      _isCardFlipped = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error clearing data: $e");
    }
  }

  // Study Session Controls
  void setCategoryFilter(String category) {
    _selectedCategory = category;
    _currentStudyIndex = 0;
    _isCardFlipped = false;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _currentStudyIndex = 0;
    _isCardFlipped = false;
    notifyListeners();
  }

  void nextCard() {
    if (filteredFlashcards.isEmpty) return;
    if (_currentStudyIndex < filteredFlashcards.length - 1) {
      _currentStudyIndex++;
    } else {
      _currentStudyIndex = 0; // Wrap around
    }
    _isCardFlipped = false;
    notifyListeners();
  }

  void prevCard() {
    if (filteredFlashcards.isEmpty) return;
    if (_currentStudyIndex > 0) {
      _currentStudyIndex--;
    } else {
      _currentStudyIndex = filteredFlashcards.length - 1; // Wrap around
    }
    _isCardFlipped = false;
    notifyListeners();
  }

  void setCardFlipped(bool isFlipped) {
    _isCardFlipped = isFlipped;
    notifyListeners();
  }

  // Mark current card in session as Studied
  Future<void> toggleCardStudied(int cardId, bool isStudied) async {
    final index = _flashcards.indexWhere((c) => c.id == cardId);
    if (index != -1) {
      final updated = _flashcards[index].copyWith(isStudied: isStudied);
      await updateFlashcard(updated);

      if (isStudied) {
        final prefs = await SharedPreferences.getInstance();
        final todayStr = DateTime.now().toIso8601String().split('T')[0];
        if (!_studyHistory.contains(todayStr)) {
          _studyHistory.add(todayStr);
          await prefs.setStringList('flashcard_study_history', _studyHistory);
          notifyListeners();
        }
      }
    }
  }

  // Reset progress: Sets all flashcards' isStudied state to false
  Future<void> resetAllProgress() async {
    for (int i = 0; i < _flashcards.length; i++) {
      if (_flashcards[i].isStudied) {
        final updated = _flashcards[i].copyWith(isStudied: false);
        await _dbHelper.updateFlashcard(updated);
        _flashcards[i] = updated;
      }
    }
    _currentStudyIndex = 0;
    _isCardFlipped = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('flashcard_study_history');
    _studyHistory.clear();
    
    notifyListeners();
  }
}
