class Flashcard {
  final int? id;
  final String question;
  final String answer;
  final String category;
  final bool isStudied;

  Flashcard({
    this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.isStudied = false,
  });

  // Convert a Flashcard into a Map for SQLite operations
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'is_studied': isStudied ? 1 : 0,
    };
  }

  // Extract a Flashcard object from a SQLite map
  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'] as int?,
      question: map['question'] as String,
      answer: map['answer'] as String,
      category: map['category'] as String,
      isStudied: (map['is_studied'] as int) == 1,
    );
  }

  // Create a copy of Flashcard with modified attributes
  Flashcard copyWith({
    int? id,
    String? question,
    String? answer,
    String? category,
    bool? isStudied,
  }) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      isStudied: isStudied ?? this.isStudied,
    );
  }
}
