import 'dart:math';
import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../theme/app_theme.dart';

class QuizModeScreen extends StatefulWidget {
  final Deck deck;

  const QuizModeScreen({super.key, required this.deck});

  @override
  State<QuizModeScreen> createState() => _QuizModeScreenState();
}

class _QuizModeScreenState extends State<QuizModeScreen>
    with SingleTickerProviderStateMixin {
  final _rng = Random();
  int _questionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _answered = false;
  late List<_QuizQuestion> _questions;

  late AnimationController _feedbackCtrl;
  late Animation<double> _feedbackScale;

  @override
  void initState() {
    super.initState();
    _questions = _generateQuestions();
    _feedbackCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _feedbackScale = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _feedbackCtrl, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  List<_QuizQuestion> _generateQuestions() {
    final allCards = widget.deck.cards;
    if (allCards.length < 2) return [];

    return allCards.map((card) {
      // Get 3 wrong answers from other cards
      final others = allCards.where((c) => c.id != card.id).toList()
        ..shuffle(_rng);
      final wrongAnswers = others.take(3).map((c) => c.back).toList();
      final allOptions = [...wrongAnswers, card.back]..shuffle(_rng);
      final correctIndex = allOptions.indexOf(card.back);

      return _QuizQuestion(
        question: card.front,
        options: allOptions,
        correctIndex: correctIndex,
        hint: card.hint,
      );
    }).toList();
  }

  _QuizQuestion get _current => _questions[_questionIndex];
  bool get _isComplete => _questionIndex >= _questions.length;
  Color get _deckColor =>
      AppTheme.deckColors[widget.deck.colorIndex % AppTheme.deckColors.length];

  void _selectAnswer(int idx) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = idx;
      _answered = true;
      if (idx == _current.correctIndex) _score++;
    });
    _feedbackCtrl.forward(from: 0);
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      _selectedAnswer = null;
      _answered = false;
    });
    _feedbackCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: _questions.isEmpty
            ? _buildNotEnoughCards(context)
            : _isComplete
                ? _buildResults(context)
                : _buildQuizBody(context),
      ),
    );
  }

  Widget _buildNotEnoughCards(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppTheme.primary, size: 64),
          const SizedBox(height: 16),
          const Text('Need at least 2 cards for quiz',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizBody(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        _buildProgressBar(),
        const SizedBox(height: 20),
        _buildQuestionCard(),
        const SizedBox(height: 20),
        _buildOptions(),
        const Spacer(),
        if (_answered) _buildNextButton(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Text(widget.deck.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Quiz: ${widget.deck.name}',
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppTheme.textPrimary),
                overflow: TextOverflow.ellipsis),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$_score / $_questionIndex',
              style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Question ${_questionIndex + 1} of ${_questions.length}',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12)),
              Text('Score: $_score',
                  style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _questionIndex / _questions.length,
              backgroundColor: AppTheme.divider,
              valueColor: AlwaysStoppedAnimation<Color>(_deckColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_deckColor, _deckColor.withOpacity(0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _deckColor.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('QUESTION',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5)),
            const SizedBox(height: 12),
            Text(
              _current.question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
            if (_current.hint != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded,
                      color: Colors.amber, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _current.hint!,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(
          _current.options.length,
          (i) => _OptionTile(
            index: i,
            text: _current.options[i],
            isSelected: _selectedAnswer == i,
            isCorrect: _answered && i == _current.correctIndex,
            isWrong:
                _answered && _selectedAnswer == i && i != _current.correctIndex,
            onTap: () => _selectAnswer(i),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final isLast = _questionIndex == _questions.length - 1;
    return ScaleTransition(
      scale: _feedbackScale,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _nextQuestion,
            icon: Icon(isLast ? Icons.emoji_events_rounded : Icons.arrow_forward_rounded),
            label: Text(isLast ? 'See Results' : 'Next Question',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    final total = _questions.length;
    final pct = total == 0 ? 0 : (_score / total * 100).round();
    final grade = pct >= 90
        ? 'Excellent! 🎉'
        : pct >= 70
            ? 'Good Job! 👍'
            : pct >= 50
                ? 'Keep Practicing 💪'
                : 'Need More Study 📚';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              gradient: AppTheme.heroGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: AppTheme.primary.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$pct%',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900)),
                const Text('SCORE',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(grade,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          Text('$_score out of $total correct',
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 15)),
          const SizedBox(height: 32),
          Row(
            children: [
              _ResultCard(
                  icon: Icons.check_circle_rounded,
                  color: AppTheme.success,
                  label: 'Correct',
                  value: '$_score'),
              const SizedBox(width: 12),
              _ResultCard(
                  icon: Icons.cancel_rounded,
                  color: AppTheme.error,
                  label: 'Wrong',
                  value: '${total - _score}'),
              const SizedBox(width: 12),
              _ResultCard(
                  icon: Icons.emoji_events_rounded,
                  color: AppTheme.accent,
                  label: 'Score',
                  value: '$pct%'),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _questionIndex = 0;
                  _score = 0;
                  _selectedAnswer = null;
                  _answered = false;
                  _questions = _generateQuestions();
                });
              },
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Retry Quiz',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Study',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? hint;

  const _QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.hint,
  });
}

class _OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const _OptionTile({
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  Color get _bgColor {
    if (isCorrect) return AppTheme.success.withOpacity(0.12);
    if (isWrong) return AppTheme.error.withOpacity(0.12);
    return AppTheme.cardBg;
  }

  Color get _borderColor {
    if (isCorrect) return AppTheme.success;
    if (isWrong) return AppTheme.error;
    if (isSelected) return AppTheme.primary;
    return AppTheme.divider;
  }

  @override
  Widget build(BuildContext context) {
    final labels = ['A', 'B', 'C', 'D'];
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor, width: 1.5),
          boxShadow: [AppTheme.cardShadow],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppTheme.success
                    : isWrong
                        ? AppTheme.error
                        : AppTheme.surface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCorrect
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 16)
                    : isWrong
                        ? const Icon(Icons.close_rounded,
                            color: Colors.white, size: 16)
                        : Text(labels[index],
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: AppTheme.textSecondary)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight:
                      isCorrect || isWrong ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                  color: isCorrect
                      ? AppTheme.success
                      : isWrong
                          ? AppTheme.error
                          : AppTheme.textPrimary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _ResultCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w900, fontSize: 18)),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
