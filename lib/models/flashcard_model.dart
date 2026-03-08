enum CardDifficulty { easy, medium, hard }

class Flashcard {
  final String id;
  final String deckId;
  final String front;
  final String back;
  final String? hint;
  CardDifficulty difficulty;
  int timesReviewed;
  int correctCount;
  DateTime? lastReviewed;

  Flashcard({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    this.hint,
    this.difficulty = CardDifficulty.medium,
    this.timesReviewed = 0,
    this.correctCount = 0,
    this.lastReviewed,
  });

  double get accuracy =>
      timesReviewed == 0 ? 0 : correctCount / timesReviewed;

  bool get isMastered => accuracy >= 0.8 && timesReviewed >= 3;

  Flashcard copyWith({
    CardDifficulty? difficulty,
    int? timesReviewed,
    int? correctCount,
    DateTime? lastReviewed,
  }) {
    return Flashcard(
      id: id,
      deckId: deckId,
      front: front,
      back: back,
      hint: hint,
      difficulty: difficulty ?? this.difficulty,
      timesReviewed: timesReviewed ?? this.timesReviewed,
      correctCount: correctCount ?? this.correctCount,
      lastReviewed: lastReviewed ?? this.lastReviewed,
    );
  }
}

class Deck {
  final String id;
  final String name;
  final String description;
  final int colorIndex;
  final String emoji;
  final List<Flashcard> cards;

  const Deck({
    required this.id,
    required this.name,
    required this.description,
    required this.colorIndex,
    required this.emoji,
    required this.cards,
  });

  int get totalCards => cards.length;
  int get masteredCards => cards.where((c) => c.isMastered).length;
  double get progress =>
      totalCards == 0 ? 0 : masteredCards / totalCards;
  int get dueCards => cards
      .where((c) => !c.isMastered || c.timesReviewed < 2)
      .length;
}
