import '../models/flashcard_model.dart';

class StudyData {
  static List<Deck> get decks => [
        biologyDeck,
        historyDeck,
        spanishDeck,
        mathDeck,
        programmingDeck,
        geographyDeck,
      ];

  static Deck get biologyDeck => Deck(
        id: 'biology',
        name: 'Biology Basics',
        description: 'Cells, DNA, and life science fundamentals',
        colorIndex: 1,
        emoji: '🧬',
        cards: [
          Flashcard(
            id: 'bio_1', deckId: 'biology',
            front: 'What is the powerhouse of the cell?',
            back: 'Mitochondria — organelles that generate most of the cell\'s supply of ATP through cellular respiration.',
            hint: 'It produces energy (ATP)',
            difficulty: CardDifficulty.easy,
            timesReviewed: 5, correctCount: 5,
            lastReviewed: DateTime.now().subtract(const Duration(days: 1)),
          ),
          Flashcard(
            id: 'bio_2', deckId: 'biology',
            front: 'What is the process by which plants make food?',
            back: 'Photosynthesis — converting CO₂ and H₂O into glucose and oxygen using sunlight energy.',
            hint: 'Involves chlorophyll and sunlight',
            difficulty: CardDifficulty.easy,
            timesReviewed: 4, correctCount: 4,
          ),
          Flashcard(
            id: 'bio_3', deckId: 'biology',
            front: 'What does DNA stand for?',
            back: 'Deoxyribonucleic Acid — the molecule that carries genetic information.',
            difficulty: CardDifficulty.easy,
            timesReviewed: 3, correctCount: 3,
          ),
          Flashcard(
            id: 'bio_4', deckId: 'biology',
            front: 'What is the function of the ribosome?',
            back: 'Ribosomes are the sites of protein synthesis — they translate mRNA into polypeptide chains.',
            hint: 'Protein factory',
            difficulty: CardDifficulty.medium,
            timesReviewed: 3, correctCount: 2,
          ),
          Flashcard(
            id: 'bio_5', deckId: 'biology',
            front: 'What is osmosis?',
            back: 'The movement of water molecules through a semipermeable membrane from a region of low solute concentration to high solute concentration.',
            difficulty: CardDifficulty.medium,
            timesReviewed: 2, correctCount: 1,
          ),
          Flashcard(
            id: 'bio_6', deckId: 'biology',
            front: 'What are the 4 nitrogenous bases of DNA?',
            back: 'Adenine (A), Thymine (T), Guanine (G), Cytosine (C). A pairs with T; G pairs with C.',
            difficulty: CardDifficulty.hard,
            timesReviewed: 1, correctCount: 0,
          ),
          Flashcard(
            id: 'bio_7', deckId: 'biology',
            front: 'What is the difference between mitosis and meiosis?',
            back: 'Mitosis produces 2 genetically identical diploid cells (for growth/repair). Meiosis produces 4 genetically unique haploid cells (for sexual reproduction).',
            difficulty: CardDifficulty.hard,
            timesReviewed: 0, correctCount: 0,
          ),
        ],
      );

  static Deck get historyDeck => Deck(
        id: 'history',
        name: 'World History',
        description: 'Key events, dates, and civilizations',
        colorIndex: 3,
        emoji: '🏛️',
        cards: [
          Flashcard(
            id: 'hist_1', deckId: 'history',
            front: 'In what year did World War II end?',
            back: '1945 — VE Day (Victory in Europe) was May 8, 1945; VJ Day (Victory over Japan) was August 15, 1945.',
            difficulty: CardDifficulty.easy,
            timesReviewed: 4, correctCount: 4,
          ),
          Flashcard(
            id: 'hist_2', deckId: 'history',
            front: 'Who was the first Emperor of China?',
            back: 'Qin Shi Huang — unified the warring states in 221 BC and became the first Emperor of a unified China.',
            difficulty: CardDifficulty.medium,
            timesReviewed: 3, correctCount: 2,
          ),
          Flashcard(
            id: 'hist_3', deckId: 'history',
            front: 'What caused the fall of the Western Roman Empire?',
            back: 'Multiple factors: military pressures from barbarian invasions, economic troubles, political instability, and overextension. Traditionally dated to 476 AD.',
            difficulty: CardDifficulty.hard,
            timesReviewed: 2, correctCount: 1,
          ),
          Flashcard(
            id: 'hist_4', deckId: 'history',
            front: 'When did the French Revolution begin?',
            back: '1789 — The storming of the Bastille on July 14, 1789 is considered its symbolic start.',
            difficulty: CardDifficulty.easy,
            timesReviewed: 5, correctCount: 5,
          ),
          Flashcard(
            id: 'hist_5', deckId: 'history',
            front: 'What was the Silk Road?',
            back: 'A network of ancient trade routes connecting China to the Mediterranean world, facilitating trade in silk, spices, and ideas from ~130 BC to 1450 AD.',
            difficulty: CardDifficulty.medium,
            timesReviewed: 2, correctCount: 2,
          ),
          Flashcard(
            id: 'hist_6', deckId: 'history',
            front: 'Who wrote the Magna Carta, and when?',
            back: 'King John of England signed the Magna Carta in 1215, limiting royal power and establishing some rights for barons — seen as a precursor to modern democracy.',
            difficulty: CardDifficulty.medium,
            timesReviewed: 1, correctCount: 1,
          ),
        ],
      );

  static Deck get spanishDeck => Deck(
        id: 'spanish',
        name: 'Spanish Vocabulary',
        description: 'Essential words and phrases in Spanish',
        colorIndex: 4,
        emoji: '🇪🇸',
        cards: [
          Flashcard(
            id: 'esp_1', deckId: 'spanish',
            front: '¿Cómo te llamas?',
            back: '"What is your name?" — Literally "How do you call yourself?" Common greeting in Spanish.',
            difficulty: CardDifficulty.easy,
            timesReviewed: 6, correctCount: 6,
          ),
          Flashcard(
            id: 'esp_2', deckId: 'spanish',
            front: 'Mucho gusto',
            back: '"Nice to meet you" — Used when meeting someone for the first time.',
            difficulty: CardDifficulty.easy,
            timesReviewed: 5, correctCount: 5,
          ),
          Flashcard(
            id: 'esp_3', deckId: 'spanish',
            front: '¿Dónde está el baño?',
            back: '"Where is the bathroom?" — Essential travel phrase.',
            difficulty: CardDifficulty.easy,
            timesReviewed: 4, correctCount: 4,
          ),
          Flashcard(
            id: 'esp_4', deckId: 'spanish',
            front: 'Ser vs Estar',
            back: 'Both mean "to be". Ser = permanent/essential qualities (identity, origin). Estar = temporary states, location, emotions.',
            hint: 'One is permanent, one is temporary',
            difficulty: CardDifficulty.hard,
            timesReviewed: 3, correctCount: 1,
          ),
          Flashcard(
            id: 'esp_5', deckId: 'spanish',
            front: 'Los números 1-10',
            back: '1=uno, 2=dos, 3=tres, 4=cuatro, 5=cinco, 6=seis, 7=siete, 8=ocho, 9=nueve, 10=diez',
            difficulty: CardDifficulty.easy,
            timesReviewed: 7, correctCount: 7,
          ),
          Flashcard(
            id: 'esp_6', deckId: 'spanish',
            front: 'What is the subjunctive mood used for?',
            back: 'The subjunctive (subjuntivo) expresses doubt, wishes, emotions, and hypothetical situations. E.g., "Quiero que vayas" (I want you to go).',
            difficulty: CardDifficulty.hard,
            timesReviewed: 1, correctCount: 0,
          ),
          Flashcard(
            id: 'esp_7', deckId: 'spanish',
            front: 'Los días de la semana',
            back: 'Monday=lunes, Tuesday=martes, Wednesday=miércoles, Thursday=jueves, Friday=viernes, Saturday=sábado, Sunday=domingo.',
            difficulty: CardDifficulty.medium,
            timesReviewed: 4, correctCount: 3,
          ),
        ],
      );

  static Deck get mathDeck => Deck(
        id: 'math',
        name: 'Math Formulas',
        description: 'Key formulas for algebra, geometry, and calculus',
        colorIndex: 0,
        emoji: '📐',
        cards: [
          Flashcard(
            id: 'math_1', deckId: 'math',
            front: 'Quadratic Formula',
            back: 'x = (−b ± √(b² − 4ac)) / 2a\nUsed to solve ax² + bx + c = 0',
            difficulty: CardDifficulty.medium,
            timesReviewed: 4, correctCount: 3,
          ),
          Flashcard(
            id: 'math_2', deckId: 'math',
            front: 'Pythagorean Theorem',
            back: 'a² + b² = c²\nWhere c is the hypotenuse of a right triangle and a, b are the other two sides.',
            difficulty: CardDifficulty.easy,
            timesReviewed: 6, correctCount: 6,
          ),
          Flashcard(
            id: 'math_3', deckId: 'math',
            front: 'Area of a Circle',
            back: 'A = πr²\nWhere r is the radius of the circle.',
            difficulty: CardDifficulty.easy,
            timesReviewed: 5, correctCount: 5,
          ),
          Flashcard(
            id: 'math_4', deckId: 'math',
            front: 'Derivative of xⁿ',
            back: 'd/dx[xⁿ] = nxⁿ⁻¹\nPower Rule — multiply by exponent, reduce exponent by 1.',
            difficulty: CardDifficulty.medium,
            timesReviewed: 3, correctCount: 2,
          ),
          Flashcard(
            id: 'math_5', deckId: 'math',
            front: 'Euler\'s Identity',
            back: 'e^(iπ) + 1 = 0\nConsidered the most beautiful equation in mathematics, linking e, i, π, 1, and 0.',
            difficulty: CardDifficulty.hard,
            timesReviewed: 1, correctCount: 0,
          ),
          Flashcard(
            id: 'math_6', deckId: 'math',
            front: 'Surface area of a sphere',
            back: 'A = 4πr²\nWhere r is the radius.',
            difficulty: CardDifficulty.medium,
            timesReviewed: 2, correctCount: 2,
          ),
        ],
      );

  static Deck get programmingDeck => Deck(
        id: 'programming',
        name: 'Programming Concepts',
        description: 'CS fundamentals, algorithms, and patterns',
        colorIndex: 6,
        emoji: '💻',
        cards: [
          Flashcard(
            id: 'prog_1', deckId: 'programming',
            front: 'What is Big O notation?',
            back: 'A mathematical notation that describes the limiting behavior of a function — used to classify algorithms by their time/space complexity as input size grows.',
            difficulty: CardDifficulty.medium,
            timesReviewed: 4, correctCount: 3,
          ),
          Flashcard(
            id: 'prog_2', deckId: 'programming',
            front: 'What is a Binary Search Tree (BST)?',
            back: 'A tree where each node\'s left child contains only nodes with values less than the parent, and the right child only nodes with greater values. Search = O(log n).',
            difficulty: CardDifficulty.medium,
            timesReviewed: 3, correctCount: 2,
          ),
          Flashcard(
            id: 'prog_3', deckId: 'programming',
            front: 'What is the difference between a stack and a queue?',
            back: 'Stack = LIFO (Last In, First Out) — like a pile of plates.\nQueue = FIFO (First In, First Out) — like a line of people.',
            difficulty: CardDifficulty.easy,
            timesReviewed: 5, correctCount: 5,
          ),
          Flashcard(
            id: 'prog_4', deckId: 'programming',
            front: 'What is recursion?',
            back: 'A function that calls itself to solve a smaller instance of the same problem. Requires a base case to stop. Example: factorial(n) = n * factorial(n-1).',
            difficulty: CardDifficulty.easy,
            timesReviewed: 4, correctCount: 4,
          ),
          Flashcard(
            id: 'prog_5', deckId: 'programming',
            front: 'What is Dynamic Programming?',
            back: 'A technique for solving complex problems by breaking them into overlapping subproblems and storing results (memoization/tabulation) to avoid redundant computation.',
            difficulty: CardDifficulty.hard,
            timesReviewed: 2, correctCount: 1,
          ),
          Flashcard(
            id: 'prog_6', deckId: 'programming',
            front: 'What is REST?',
            back: 'Representational State Transfer — an architectural style for APIs using HTTP methods (GET, POST, PUT, DELETE) with stateless client-server communication.',
            difficulty: CardDifficulty.medium,
            timesReviewed: 3, correctCount: 3,
          ),
          Flashcard(
            id: 'prog_7', deckId: 'programming',
            front: 'What is the SOLID principle?',
            back: 'S = Single Responsibility, O = Open/Closed, L = Liskov Substitution, I = Interface Segregation, D = Dependency Inversion. Five OOP design principles.',
            difficulty: CardDifficulty.hard,
            timesReviewed: 1, correctCount: 0,
          ),
          Flashcard(
            id: 'prog_8', deckId: 'programming',
            front: 'Time complexity of quicksort',
            back: 'Average: O(n log n). Worst case: O(n²) when pivot is always the smallest/largest element. Best case: O(n log n).',
            difficulty: CardDifficulty.hard,
            timesReviewed: 2, correctCount: 1,
          ),
        ],
      );

  static Deck get geographyDeck => Deck(
        id: 'geography',
        name: 'World Geography',
        description: 'Countries, capitals, and physical geography',
        colorIndex: 2,
        emoji: '🌍',
        cards: [
          Flashcard(
            id: 'geo_1', deckId: 'geography',
            front: 'What is the capital of Australia?',
            back: 'Canberra — often confused with Sydney, but Canberra serves as the capital and is located between Sydney and Melbourne.',
            difficulty: CardDifficulty.medium,
            timesReviewed: 4, correctCount: 3,
          ),
          Flashcard(
            id: 'geo_2', deckId: 'geography',
            front: 'What is the longest river in the world?',
            back: 'The Nile River (6,650 km / 4,130 miles), flowing northward through northeastern Africa.',
            difficulty: CardDifficulty.easy,
            timesReviewed: 5, correctCount: 5,
          ),
          Flashcard(
            id: 'geo_3', deckId: 'geography',
            front: 'What are the five oceans?',
            back: 'Pacific, Atlantic, Indian, Southern (Antarctic), and Arctic Oceans. The Pacific is the largest, covering more area than all land combined.',
            difficulty: CardDifficulty.easy,
            timesReviewed: 4, correctCount: 4,
          ),
          Flashcard(
            id: 'geo_4', deckId: 'geography',
            front: 'Which country has the most natural freshwater?',
            back: 'Brazil — holds the largest share of freshwater resources, primarily in the Amazon River basin.',
            difficulty: CardDifficulty.hard,
            timesReviewed: 1, correctCount: 0,
          ),
          Flashcard(
            id: 'geo_5', deckId: 'geography',
            front: 'What is the highest mountain in Africa?',
            back: 'Mount Kilimanjaro (5,895 m / 19,341 ft) in Tanzania — the highest free-standing mountain in the world.',
            difficulty: CardDifficulty.medium,
            timesReviewed: 3, correctCount: 2,
          ),
          Flashcard(
            id: 'geo_6', deckId: 'geography',
            front: 'What is the Ring of Fire?',
            back: 'A horseshoe-shaped zone of frequent earthquakes and volcanic eruptions around the Pacific Ocean basin, spanning 40,000 km.',
            difficulty: CardDifficulty.medium,
            timesReviewed: 2, correctCount: 2,
          ),
        ],
      );

  static int get totalCards =>
      decks.fold(0, (sum, d) => sum + d.totalCards);
  static int get masteredCards =>
      decks.fold(0, (sum, d) => sum + d.masteredCards);
  static int get totalStudySessions => 47;
  static int get currentStreak => 5;
}
