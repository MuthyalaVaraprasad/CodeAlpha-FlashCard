import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/flashcard_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'flashcards.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        category TEXT NOT NULL,
        is_studied INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Pre-seed table with starter internship-level flashcards matching the reference image perfectly!
    final List<Flashcard> starterCards = [
      Flashcard(
        question: "What is the capital of France?",
        answer: "Paris",
        category: "General Knowledge",
      ),
      Flashcard(
        question: "Which planet is known as the Red Planet?",
        answer: "Mars",
        category: "General Knowledge",
      ),
      Flashcard(
        question: "Who wrote the play Hamlet?",
        answer: "William Shakespeare",
        category: "General Knowledge",
      ),
      Flashcard(
        question: "What is the chemical symbol for water?",
        answer: "H2O",
        category: "Science",
      ),
      Flashcard(
        question: "Who is known as the father of India?",
        answer: "Mahatma Gandhi",
        category: "General Knowledge",
      ),
      Flashcard(
        question: "What does CPU stand for?",
        answer: "Central Processing Unit",
        category: "Computer Science",
      ),
      Flashcard(
        question: "What is the primary language used to build Flutter apps?",
        answer: "Dart",
        category: "Computer Science",
      ),
      Flashcard(
        question: "What does HTML stand for?",
        answer: "HyperText Markup Language",
        category: "Computer Science",
      ),
      Flashcard(
        question: "Which planet is closest to the Sun?",
        answer: "Mercury",
        category: "Science",
      ),
      Flashcard(
        question: "What is the square root of 144?",
        answer: "12",
        category: "General Knowledge",
      ),
      Flashcard(
        question: "What gas do plants absorb during photosynthesis?",
        answer: "Carbon Dioxide",
        category: "Science",
      ),
      Flashcard(
        question: "What is the full form of SQL?",
        answer: "Structured Query Language",
        category: "Computer Science",
      ),
    ];

    for (var card in starterCards) {
      await db.insert('flashcards', card.toMap());
    }
  }

  // --- CRUD API ---

  // Insert Flashcard
  Future<int> insertFlashcard(Flashcard card) async {
    final db = await database;
    return await db.insert('flashcards', card.toMap());
  }

  // Fetch All Flashcards
  Future<List<Flashcard>> fetchAllFlashcards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('flashcards');
    return List.generate(maps.length, (i) => Flashcard.fromMap(maps[i]));
  }

  // Update Flashcard
  Future<int> updateFlashcard(Flashcard card) async {
    final db = await database;
    return await db.update(
      'flashcards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  // Delete Flashcard
  Future<int> deleteFlashcard(int id) async {
    final db = await database;
    return await db.delete(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear Database
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('flashcards');
  }
}
