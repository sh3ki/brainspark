import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../theme/app_theme.dart';
import '../widgets/flip_card.dart';
import 'quiz_mode_screen.dart';

class StudySessionScreen extends StatefulWidget {
  final Deck deck;

  const StudySessionScreen({super.key, required this.deck});

  @override
  State<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends State<StudySessionScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isFlipped = false;
  int _knownCount = 0;
  int _unknownCount = 0;
  List<String> _knownIds = [];

  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  bool _animatingOut = false;
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _slideAnim =
        Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut),
    );
    _fadeAnim =
        Tween<double>(begin: 1.0, end: 0.0).animate(_slideCtrl);
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  Flashcard get _currentCard => widget.deck.cards[_currentIndex];
  bool get _isComplete => _currentIndex >= widget.deck.cards.length;
  Color get _deckColor =>
      AppTheme.deckColors[widget.deck.colorIndex % AppTheme.deckColors.length];

  void _nextCard(bool known) async {
    if (_animatingOut) return;
    setState(() => _animatingOut = true);
    final endX = known ? 1.2 : -1.2;
    _slideAnim = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(endX, 0),
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeIn));

    _slideCtrl.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 280));

    setState(() {
      if (known) {
        _knownCount++;
        _knownIds.add(_currentCard.id);
      } else {
        _unknownCount++;
      }
      _currentIndex++;
      _isFlipped = false;
      _dragOffset = Offset.zero;
      _animatingOut = false;
    });
    _slideCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildProgress(),
            const SizedBox(height: 16),
            Expanded(
              child: _isComplete
                  ? _buildCompletionScreen(context)
                  : _buildCardArea(),
            ),
            if (!_isComplete) _buildActionButtons(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Text(widget.deck.emoji,
              style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.deck.name,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: AppTheme.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => QuizModeScreen(deck: widget.deck)),
            ),
            icon: const Icon(Icons.quiz_rounded,
                color: AppTheme.secondary, size: 18),
            label: const Text('Quiz',
                style: TextStyle(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    final total = widget.deck.cards.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isComplete
                    ? 'Complete!'
                    : 'Card ${_currentIndex + 1} of $total',
                style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppTheme.success, size: 16),
                  const SizedBox(width: 4),
                  Text('$_knownCount',
                      style: const TextStyle(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(width: 10),
                  const Icon(Icons.cancel_rounded,
                      color: AppTheme.error, size: 16),
                  const SizedBox(width: 4),
                  Text('$_unknownCount',
                      style: const TextStyle(
                          color: AppTheme.error,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: total == 0
                  ? 0
                  : _currentIndex.clamp(0, total) / total,
              backgroundColor: AppTheme.divider,
              valueColor: AlwaysStoppedAnimation<Color>(_deckColor),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardArea() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() => _dragOffset = Offset(
            _dragOffset.dx + details.delta.dx, 0));
      },
      onPanEnd: (details) {
        if (_dragOffset.dx > 80) {
          _nextCard(true);
        } else if (_dragOffset.dx < -80) {
          _nextCard(false);
        } else {
          setState(() => _dragOffset = Offset.zero);
        }
      },
      child: AnimatedBuilder(
        animation: _slideCtrl,
        builder: (_, child) {
          final offset = _animatingOut
              ? _slideAnim.value
              : Offset(
                  _dragOffset.dx / MediaQuery.of(context).size.width, 0);
          final opacity = _animatingOut ? _fadeAnim.value : 1.0;
          final tilt = offset.dx * 0.04;

          return Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Transform(
              transform: Matrix4.identity()
                ..translate(
                    offset.dx * MediaQuery.of(context).size.width, 0)
                ..rotateZ(tilt),
              alignment: Alignment.center,
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            children: [
              if (_dragOffset.dx > 40)
                Positioned(
                  top: 24,
                  left: 24,
                  child: _FeedbackLabel(
                      label: 'KNOW', color: AppTheme.success),
                ),
              if (_dragOffset.dx < -40)
                Positioned(
                  top: 24,
                  right: 24,
                  child: _FeedbackLabel(
                      label: 'SKIP', color: AppTheme.error),
                ),
              SizedBox(
                height: double.infinity,
                child: FlipCard(
                  front: _currentCard.front,
                  back: _currentCard.back,
                  hint: _currentCard.hint,
                  color: _deckColor,
                  isFlipped: _isFlipped,
                  onFlip: () =>
                      setState(() => _isFlipped = !_isFlipped),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _nextCard(false),
              icon: const Icon(Icons.close_rounded,
                  color: AppTheme.error, size: 20),
              label: const Text('Skip',
                  style: TextStyle(
                      color: AppTheme.error,
                      fontWeight: FontWeight.w700)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(
                    color: AppTheme.error, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _nextCard(true),
              icon: const Icon(Icons.check_rounded, size: 20),
              label: const Text('Know It',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen(BuildContext context) {
    final total = widget.deck.cards.length;
    final score = total == 0 ? 0 : (_knownCount / total * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$score%',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Session Complete!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          Text(
            '$_knownCount of $total cards known',
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _ResultBadge(
                  icon: Icons.check_circle_rounded,
                  color: AppTheme.success,
                  label: 'Known',
                  value: '$_knownCount'),
              const SizedBox(width: 12),
              _ResultBadge(
                  icon: Icons.cancel_rounded,
                  color: AppTheme.error,
                  label: 'Skipped',
                  value: '$_unknownCount'),
              const SizedBox(width: 12),
              _ResultBadge(
                  icon: Icons.star_rounded,
                  color: AppTheme.accent,
                  label: 'Score',
                  value: '$score%'),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                  _knownCount = 0;
                  _unknownCount = 0;
                  _knownIds = [];
                  _isFlipped = false;
                });
              },
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Study Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        QuizModeScreen(deck: widget.deck)),
              ),
              icon: const Icon(Icons.quiz_rounded,
                  color: AppTheme.secondary),
              label: const Text('Try Quiz Mode',
                  style: TextStyle(
                      color: AppTheme.secondary,
                      fontWeight: FontWeight.w700)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(
                    color: AppTheme.secondary, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Decks',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _FeedbackLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _FeedbackLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: 1)),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _ResultBadge({
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
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 18)),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
