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
      Flashcard(question: "What is the capital of France?", answer: "Paris", category: "General Knowledge"),
      Flashcard(question: "Which planet is known as the Red Planet?", answer: "Mars", category: "General Knowledge"),
      Flashcard(question: "Who wrote the play Hamlet?", answer: "William Shakespeare", category: "General Knowledge"),
      Flashcard(question: "Who is known as the father of India?", answer: "Mahatma Gandhi", category: "General Knowledge"),
      Flashcard(question: "What is the square root of 144?", answer: "12", category: "General Knowledge"),
      Flashcard(question: "What is the currency of Japan?", answer: "Yen", category: "General Knowledge"),
      Flashcard(question: "Which is the largest ocean on Earth?", answer: "Pacific Ocean", category: "General Knowledge"),
      Flashcard(question: "What is the capital of the United States?", answer: "Washington D.C.", category: "General Knowledge"),
      Flashcard(question: "Which is the longest river in the world?", answer: "Nile River", category: "General Knowledge"),
      Flashcard(question: "What is the tallest mountain in the world?", answer: "Mount Everest", category: "General Knowledge"),
      Flashcard(question: "Who painted the Mona Lisa?", answer: "Leonardo da Vinci", category: "General Knowledge"),
      Flashcard(question: "Which is the largest country in the world by area?", answer: "Russia", category: "General Knowledge"),
      Flashcard(question: "What is the currency of the United Kingdom?", answer: "Pound Sterling", category: "General Knowledge"),
      Flashcard(question: "What is the smallest country in the world?", answer: "Vatican City", category: "General Knowledge"),
      Flashcard(question: "What is the capital of Italy?", answer: "Rome", category: "General Knowledge"),
      Flashcard(question: "What is the national animal of India?", answer: "Bengal Tiger", category: "General Knowledge"),
      Flashcard(question: "What is the capital of Germany?", answer: "Berlin", category: "General Knowledge"),
      Flashcard(question: "Who wrote the Harry Potter series?", answer: "J.K. Rowling", category: "General Knowledge"),
      Flashcard(question: "What is the hardest natural substance on Earth?", answer: "Diamond", category: "General Knowledge"),
      Flashcard(question: "What is the capital of Canada?", answer: "Ottawa", category: "General Knowledge"),
      Flashcard(question: "Who discovered gravity?", answer: "Sir Isaac Newton", category: "General Knowledge"),
      Flashcard(question: "Who was the first man to walk on the moon?", answer: "Neil Armstrong", category: "General Knowledge"),
      Flashcard(question: "What is the capital of Australia?", answer: "Canberra", category: "General Knowledge"),
      Flashcard(question: "Which is the largest hot desert in the world?", answer: "Sahara Desert", category: "General Knowledge"),
      Flashcard(question: "Who wrote the novel War and Peace?", answer: "Leo Tolstoy", category: "General Knowledge"),
      Flashcard(question: "Who is credited with inventing the telephone?", answer: "Alexander Graham Bell", category: "General Knowledge"),
      Flashcard(question: "What is the capital of Spain?", answer: "Madrid", category: "General Knowledge"),
      Flashcard(question: "Who painted The Starry Night?", answer: "Vincent van Gogh", category: "General Knowledge"),
      Flashcard(question: "Which is the largest island in the world?", answer: "Greenland", category: "General Knowledge"),
      Flashcard(question: "What is the capital of Brazil?", answer: "Brasilia", category: "General Knowledge"),
      Flashcard(question: "Who wrote Pride and Prejudice?", answer: "Jane Austen", category: "General Knowledge"),
      Flashcard(question: "Who is credited with inventing the electric light bulb?", answer: "Thomas Edison", category: "General Knowledge"),
      Flashcard(question: "What is the capital of China?", answer: "Beijing", category: "General Knowledge"),
      Flashcard(question: "Which is the largest mammal in the world?", answer: "Blue Whale", category: "General Knowledge"),
      Flashcard(question: "Who discovered penicillin?", answer: "Alexander Fleming", category: "General Knowledge"),
      Flashcard(question: "What is the capital of Egypt?", answer: "Cairo", category: "General Knowledge"),
      Flashcard(question: "Who is the ancient Greek poet who wrote The Odyssey?", answer: "Homer", category: "General Knowledge"),
      Flashcard(question: "Who created the cartoon character Mickey Mouse?", answer: "Walt Disney", category: "General Knowledge"),
      Flashcard(question: "What is the capital of India?", answer: "New Delhi", category: "General Knowledge"),
      Flashcard(question: "Which is the coldest continent on Earth?", answer: "Antarctica", category: "General Knowledge"),
      Flashcard(question: "Who wrote the novel The Great Gatsby?", answer: "F. Scott Fitzgerald", category: "General Knowledge"),
      Flashcard(question: "Who invented the printing press?", answer: "Johannes Gutenberg", category: "General Knowledge"),
      Flashcard(question: "What is the capital of Russia?", answer: "Moscow", category: "General Knowledge"),
      Flashcard(question: "Which is the smallest continent by land area?", answer: "Australia", category: "General Knowledge"),
      Flashcard(question: "Who wrote Don Quixote?", answer: "Miguel de Cervantes", category: "General Knowledge"),
      Flashcard(question: "What is the administrative capital of South Africa?", answer: "Pretoria", category: "General Knowledge"),
      Flashcard(question: "Which is the largest continent on Earth?", answer: "Asia", category: "General Knowledge"),
      Flashcard(question: "Who wrote Crime and Punishment?", answer: "Fyodor Dostoevsky", category: "General Knowledge"),
      Flashcard(question: "Who was the first President of the United States?", answer: "George Washington", category: "General Knowledge"),
      Flashcard(question: "What is the capital of the United Kingdom?", answer: "London", category: "General Knowledge"),
      Flashcard(question: "Which country is the most populous in the world?", answer: "India", category: "General Knowledge"),
      Flashcard(question: "Which language has the most native speakers?", answer: "Mandarin Chinese", category: "General Knowledge"),
      Flashcard(question: "What does CPU stand for?", answer: "Central Processing Unit", category: "Computer Science"),
      Flashcard(question: "What is the primary programming language used for Flutter?", answer: "Dart", category: "Computer Science"),
      Flashcard(question: "What does HTML stand for?", answer: "HyperText Markup Language", category: "Computer Science"),
      Flashcard(question: "What is the full form of SQL?", answer: "Structured Query Language", category: "Computer Science"),
      Flashcard(question: "What does RAM stand for?", answer: "Random Access Memory", category: "Computer Science"),
      Flashcard(question: "What does ROM stand for?", answer: "Read Only Memory", category: "Computer Science"),
      Flashcard(question: "Who is widely regarded as the first computer programmer?", answer: "Ada Lovelace", category: "Computer Science"),
      Flashcard(question: "Who created the Linux kernel?", answer: "Linus Torvalds", category: "Computer Science"),
      Flashcard(question: "What does CSS stand for?", answer: "Cascading Style Sheets", category: "Computer Science"),
      Flashcard(question: "Who is the co-founder of Microsoft?", answer: "Bill Gates", category: "Computer Science"),
      Flashcard(question: "Who created the Python programming language?", answer: "Guido van Rossum", category: "Computer Science"),
      Flashcard(question: "What does HTTP stand for?", answer: "HyperText Transfer Protocol", category: "Computer Science"),
      Flashcard(question: "Who was the co-founder of Apple Inc.?", answer: "Steve Jobs", category: "Computer Science"),
      Flashcard(question: "What does IP stand for in IP Address?", answer: "Internet Protocol", category: "Computer Science"),
      Flashcard(question: "Who created the Java programming language?", answer: "James Gosling", category: "Computer Science"),
      Flashcard(question: "What does DNS stand for?", answer: "Domain Name System", category: "Computer Science"),
      Flashcard(question: "Who designed the C++ programming language?", answer: "Bjarne Stroustrup", category: "Computer Science"),
      Flashcard(question: "What does URL stand for?", answer: "Uniform Resource Locator", category: "Computer Science"),
      Flashcard(question: "Who invented the World Wide Web?", answer: "Tim Berners-Lee", category: "Computer Science"),
      Flashcard(question: "What does API stand for?", answer: "Application Programming Interface", category: "Computer Science"),
      Flashcard(question: "Who created JavaScript?", answer: "Brendan Eich", category: "Computer Science"),
      Flashcard(question: "What does GUI stand for?", answer: "Graphical User Interface", category: "Computer Science"),
      Flashcard(question: "Who are the co-founders of Google?", answer: "Larry Page and Sergey Brin", category: "Computer Science"),
      Flashcard(question: "What does VPN stand for?", answer: "Virtual Private Network", category: "Computer Science"),
      Flashcard(question: "Who created the C programming language?", answer: "Dennis Ritchie", category: "Computer Science"),
      Flashcard(question: "What does BIOS stand for?", answer: "Basic Input Output System", category: "Computer Science"),
      Flashcard(question: "Who is the co-founder of Facebook?", answer: "Mark Zuckerberg", category: "Computer Science"),
      Flashcard(question: "What does LAN stand for?", answer: "Local Area Network", category: "Computer Science"),
      Flashcard(question: "Who invented the Git version control system?", answer: "Linus Torvalds", category: "Computer Science"),
      Flashcard(question: "What does JSON stand for?", answer: "JavaScript Object Notation", category: "Computer Science"),
      Flashcard(question: "Who wrote the first compiler?", answer: "Grace Hopper", category: "Computer Science"),
      Flashcard(question: "What does IDE stand for?", answer: "Integrated Development Environment", category: "Computer Science"),
      Flashcard(question: "Who is the Turing Award named after?", answer: "Alan Turing", category: "Computer Science"),
      Flashcard(question: "What does PDF stand for?", answer: "Portable Document Format", category: "Computer Science"),
      Flashcard(question: "Who wrote the influential book 'Design Patterns'?", answer: "Gang of Four", category: "Computer Science"),
      Flashcard(question: "What does SMTP stand for?", answer: "Simple Mail Transfer Protocol", category: "Computer Science"),
      Flashcard(question: "Who is known as the father of computers?", answer: "Charles Babbage", category: "Computer Science"),
      Flashcard(question: "What does SSD stand for?", answer: "Solid State Drive", category: "Computer Science"),
      Flashcard(question: "Who invented the computer mouse?", answer: "Douglas Engelbart", category: "Computer Science"),
      Flashcard(question: "What does XML stand for?", answer: "Extensible Markup Language", category: "Computer Science"),
      Flashcard(question: "What does TCP stand for?", answer: "Transmission Control Protocol", category: "Computer Science"),
      Flashcard(question: "Who invented the Relational Database model?", answer: "Edgar F. Codd", category: "Computer Science"),
      Flashcard(question: "What does FTP stand for?", answer: "File Transfer Protocol", category: "Computer Science"),
      Flashcard(question: "Who co-developed the Unix operating system?", answer: "Ken Thompson & Dennis Ritchie", category: "Computer Science"),
      Flashcard(question: "What does CLI stand for?", answer: "Command Line Interface", category: "Computer Science"),
      Flashcard(question: "Who designed the Von Neumann architecture?", answer: "John von Neumann", category: "Computer Science"),
      Flashcard(question: "What does WAN stand for?", answer: "Wide Area Network", category: "Computer Science"),
      Flashcard(question: "Who is known as the father of Artificial Intelligence?", answer: "John McCarthy", category: "Computer Science"),
      Flashcard(question: "What does OS stand for?", answer: "Operating System", category: "Computer Science"),
      Flashcard(question: "Which protocol is used to secure web traffic?", answer: "HTTPS", category: "Computer Science"),
      Flashcard(question: "What is the binary representation of decimal number 10?", answer: "1010", category: "Computer Science"),
      Flashcard(question: "What does OOP stand for?", answer: "Object-Oriented Programming", category: "Computer Science"),
      Flashcard(question: "What is the chemical symbol for water?", answer: "H2O", category: "Science"),
      Flashcard(question: "Which planet is closest to the Sun?", answer: "Mercury", category: "Science"),
      Flashcard(question: "What gas do plants absorb during photosynthesis?", answer: "Carbon Dioxide", category: "Science"),
      Flashcard(question: "What is the approximate speed of light?", answer: "300,000 km/s", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Gold?", answer: "Au", category: "Science"),
      Flashcard(question: "What is known as the powerhouse of the cell?", answer: "Mitochondria", category: "Science"),
      Flashcard(question: "What substance gives blood its red color?", answer: "Hemoglobin", category: "Science"),
      Flashcard(question: "What is the unit of electrical resistance?", answer: "Ohm", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Oxygen?", answer: "O", category: "Science"),
      Flashcard(question: "Which acid is found in lemons?", answer: "Citric Acid", category: "Science"),
      Flashcard(question: "What is the largest organ in the human body?", answer: "Skin", category: "Science"),
      Flashcard(question: "What is the SI unit of force?", answer: "Newton", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Iron?", answer: "Fe", category: "Science"),
      Flashcard(question: "Which is the nearest star to Earth?", answer: "Sun", category: "Science"),
      Flashcard(question: "Which gas makes up 78% of Earth's atmosphere?", answer: "Nitrogen", category: "Science"),
      Flashcard(question: "What is normal human body temperature in Celsius?", answer: "37°C", category: "Science"),
      Flashcard(question: "What is the unit of frequency?", answer: "Hertz", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Sodium?", answer: "Na", category: "Science"),
      Flashcard(question: "Who formulated the theory of relativity?", answer: "Albert Einstein", category: "Science"),
      Flashcard(question: "What is the smallest particle of an element?", answer: "Atom", category: "Science"),
      Flashcard(question: "Which is the lightest element in the periodic table?", answer: "Hydrogen", category: "Science"),
      Flashcard(question: "Which type of mirror is used in car headlights?", answer: "Concave Mirror", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Silver?", answer: "Ag", category: "Science"),
      Flashcard(question: "Which is the master gland of the endocrine system?", answer: "Pituitary Gland", category: "Science"),
      Flashcard(question: "Which instrument is used to measure atmospheric pressure?", answer: "Barometer", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Helium?", answer: "He", category: "Science"),
      Flashcard(question: "Who discovered the laws of planetary motion?", answer: "Johannes Kepler", category: "Science"),
      Flashcard(question: "Which gas is commonly used in electric light bulbs?", answer: "Argon", category: "Science"),
      Flashcard(question: "What is the hardest substance in the human body?", answer: "Tooth Enamel", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Carbon?", answer: "C", category: "Science"),
      Flashcard(question: "Who discovered radioactivity?", answer: "Henri Becquerel", category: "Science"),
      Flashcard(question: "What is the outermost solid layer of the Earth?", answer: "Crust", category: "Science"),
      Flashcard(question: "Which instrument is used to measure earthquakes?", answer: "Seismograph", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Nitrogen?", answer: "N", category: "Science"),
      Flashcard(question: "What is the process of a liquid turning into a gas?", answer: "Evaporation", category: "Science"),
      Flashcard(question: "What is the main component of natural gas?", answer: "Methane", category: "Science"),
      Flashcard(question: "What is the study of plants called?", answer: "Botany", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Copper?", answer: "Cu", category: "Science"),
      Flashcard(question: "Who is credited with creating the periodic table?", answer: "Dmitri Mendeleev", category: "Science"),
      Flashcard(question: "What is the study of animals called?", answer: "Zoology", category: "Science"),
      Flashcard(question: "What is the main gas that makes up the Sun?", answer: "Hydrogen", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Calcium?", answer: "Ca", category: "Science"),
      Flashcard(question: "What type of lens is present in the human eye?", answer: "Convex Lens", category: "Science"),
      Flashcard(question: "Which is the primary source of energy for Earth?", answer: "Sun", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Potassium?", answer: "K", category: "Science"),
      Flashcard(question: "Which acid is present in an ant's sting?", answer: "Formic Acid", category: "Science"),
      Flashcard(question: "What is the study of earthquakes called?", answer: "Seismology", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Lead?", answer: "Pb", category: "Science"),
      Flashcard(question: "What is the boiling point of water in Celsius?", answer: "100°C", category: "Science"),
      Flashcard(question: "Who is known as the father of modern chemistry?", answer: "Antoine Lavoisier", category: "Science"),
      Flashcard(question: "What is the chemical symbol for Zinc?", answer: "Zn", category: "Science"),
      Flashcard(question: "Which is the only natural satellite of Earth?", answer: "Moon", category: "Science"),
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
