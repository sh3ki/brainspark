import 'package:flutter/material.dart';
import '../data/study_data.dart';
import '../models/flashcard_model.dart';
import '../theme/app_theme.dart';

class CreateCardScreen extends StatefulWidget {
  const CreateCardScreen({super.key});

  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedDeckIndex = 0;
  final _frontCtrl = TextEditingController();
  final _backCtrl = TextEditingController();
  final _hintCtrl = TextEditingController();
  CardDifficulty _difficulty = CardDifficulty.medium;
  bool _showPreview = false;

  late AnimationController _previewCtrl;
  late Animation<double> _previewAnim;

  @override
  void initState() {
    super.initState();
    _previewCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _previewAnim =
        CurvedAnimation(parent: _previewCtrl, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _frontCtrl.dispose();
    _backCtrl.dispose();
    _hintCtrl.dispose();
    _previewCtrl.dispose();
    super.dispose();
  }

  Deck get _selectedDeck => StudyData.decks[_selectedDeckIndex];
  Color get _deckColor =>
      AppTheme.deckColors[_selectedDeck.colorIndex % AppTheme.deckColors.length];

  bool get _canCreate =>
      _frontCtrl.text.trim().isNotEmpty && _backCtrl.text.trim().isNotEmpty;

  void _togglePreview() {
    setState(() => _showPreview = !_showPreview);
    if (_showPreview) {
      _previewCtrl.forward();
    } else {
      _previewCtrl.reverse();
    }
  }

  void _createCard() {
    if (!_canCreate) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Card added!',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  Text('Added to "${_selectedDeck.name}"',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
    _frontCtrl.clear();
    _backCtrl.clear();
    _hintCtrl.clear();
    setState(() {
      _difficulty = CardDifficulty.medium;
      _showPreview = false;
    });
    _previewCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDeckSelector(),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _frontCtrl,
                    label: 'Front (Question)',
                    hint: 'What is the powerhouse of the cell?',
                    icon: Icons.help_outline_rounded,
                    color: _deckColor,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _backCtrl,
                    label: 'Back (Answer)',
                    hint: 'The mitochondria',
                    icon: Icons.lightbulb_rounded,
                    color: AppTheme.secondary,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _hintCtrl,
                    label: 'Hint (Optional)',
                    hint: 'Think about energy production...',
                    icon: Icons.tips_and_updates_rounded,
                    color: AppTheme.accent,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  _buildDifficultySelector(),
                  const SizedBox(height: 24),
                  _buildPreviewToggle(),
                  if (_showPreview) ...[
                    const SizedBox(height: 16),
                    ScaleTransition(
                        scale: _previewAnim, child: _buildPreviewCard()),
                  ],
                  const SizedBox(height: 32),
                  _buildCreateButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 110,
      collapsedHeight: 60,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppTheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppTheme.primary,
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.add_card_rounded,
                  color: AppTheme.accent, size: 26),
              const SizedBox(width: 10),
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Card',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900)),
                  Text('Add a new flashcard',
                      style: TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeckSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Deck',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: AppTheme.textPrimary)),
        const SizedBox(height: 10),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: StudyData.decks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final deck = StudyData.decks[i];
              final color = AppTheme
                  .deckColors[deck.colorIndex % AppTheme.deckColors.length];
              final isSelected = _selectedDeckIndex == i;

              return GestureDetector(
                onTap: () => setState(() => _selectedDeckIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? color : AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                        color: isSelected ? color : AppTheme.divider,
                        width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(deck.emoji, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(deck.name,
                          style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppTheme.textPrimary)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            filled: true,
            fillColor: AppTheme.cardBg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Difficulty',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: AppTheme.textPrimary)),
        const SizedBox(height: 10),
        Row(
          children: [
            _DiffChip(
              label: 'Easy',
              icon: Icons.sentiment_satisfied_rounded,
              color: AppTheme.success,
              isSelected: _difficulty == CardDifficulty.easy,
              onTap: () => setState(() => _difficulty = CardDifficulty.easy),
            ),
            const SizedBox(width: 10),
            _DiffChip(
              label: 'Medium',
              icon: Icons.sentiment_neutral_rounded,
              color: AppTheme.accent,
              isSelected: _difficulty == CardDifficulty.medium,
              onTap: () =>
                  setState(() => _difficulty = CardDifficulty.medium),
            ),
            const SizedBox(width: 10),
            _DiffChip(
              label: 'Hard',
              icon: Icons.sentiment_very_dissatisfied_rounded,
              color: AppTheme.error,
              isSelected: _difficulty == CardDifficulty.hard,
              onTap: () => setState(() => _difficulty = CardDifficulty.hard),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewToggle() {
    return GestureDetector(
      onTap: _togglePreview,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _deckColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _deckColor.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.preview_rounded, color: _deckColor, size: 18),
                const SizedBox(width: 8),
                Text('Preview Card',
                    style: TextStyle(
                        color: _deckColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
              ],
            ),
            Icon(
              _showPreview
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: _deckColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    final hasContent = _canCreate;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: _deckColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Text('FRONT',
                    style: TextStyle(
                        color: _deckColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2)),
              ),
              const Spacer(),
              Text(_selectedDeck.emoji,
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hasContent
                ? _frontCtrl.text.trim()
                : 'Your question will appear here...',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: hasContent
                  ? AppTheme.textPrimary
                  : AppTheme.textSecondary,
              fontStyle: hasContent ? FontStyle.normal : FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.divider),
          const SizedBox(height: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: AppTheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20)),
            child: const Text('BACK',
                style: TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2)),
          ),
          const SizedBox(height: 10),
          Text(
            _backCtrl.text.trim().isEmpty
                ? 'Your answer will appear here...'
                : _backCtrl.text.trim(),
            style: TextStyle(
              fontSize: 14,
              color: _backCtrl.text.trim().isEmpty
                  ? AppTheme.textSecondary
                  : AppTheme.textPrimary,
              fontStyle: _backCtrl.text.trim().isEmpty
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _canCreate ? _createCard : null,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Card',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          disabledBackgroundColor: AppTheme.divider,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}

class _DiffChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _DiffChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? color : AppTheme.divider, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : color, size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
