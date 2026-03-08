import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/flashcard_model.dart';
import '../theme/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  // Mock 7-day study activity (cards reviewed per day)
  static const List<int> _weekActivity = [14, 8, 22, 18, 31, 25, 12];
  static const List<String> _weekDays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildStatsRow(context),
                const SizedBox(height: 24),
                _buildSectionTitle('Study Activity (Last 7 Days)'),
                const SizedBox(height: 12),
                _buildActivityChart(),
                const SizedBox(height: 24),
                _buildSectionTitle('Deck Breakdown'),
                const SizedBox(height: 12),
                _buildDeckBreakdown(),
                const SizedBox(height: 24),
                _buildSectionTitle('Difficulty Distribution'),
                const SizedBox(height: 12),
                _buildDifficultyDistribution(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 130,
      collapsedHeight: 60,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(gradient: AppTheme.heroGradient),
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.insights_rounded, color: Colors.white, size: 28),
              const SizedBox(width: 10),
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progress',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900)),
                  Text('Track your learning journey',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
        title: const Text('Progress',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18)),
        titlePadding: const EdgeInsets.only(left: 56, bottom: 14),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final stats = [
      _StatItem(
          icon: Icons.style_rounded,
          color: AppTheme.primary,
          label: 'Total Cards',
          value: '${MockData.totalCards}'),
      _StatItem(
          icon: Icons.verified_rounded,
          color: AppTheme.success,
          label: 'Mastered',
          value: '${MockData.masteredCards}'),
      _StatItem(
          icon: Icons.local_fire_department_rounded,
          color: AppTheme.accent,
          label: 'Streak',
          value: '${MockData.currentStreak}d'),
      _StatItem(
          icon: Icons.school_rounded,
          color: AppTheme.secondary,
          label: 'Sessions',
          value: '${MockData.totalStudySessions}'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: stats
            .map((s) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: stats.last == s ? 0 : 8),
                    child: _buildStatCard(s),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildStatCard(_StatItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: item.color, size: 18),
          ),
          const SizedBox(height: 6),
          Text(item.value,
              style: TextStyle(
                  color: item.color,
                  fontWeight: FontWeight.w900,
                  fontSize: 15)),
          Text(item.label,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildActivityChart() {
    final maxY = (_weekActivity.reduce((a, b) => a > b ? a : b) * 1.25)
        .roundToDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 200,
        padding: const EdgeInsets.fromLTRB(8, 20, 20, 12),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [AppTheme.cardShadow],
        ),
        child: BarChart(
          BarChartData(
            maxY: maxY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => const FlLine(
                  color: AppTheme.divider, strokeWidth: 1),
              horizontalInterval: maxY / 4,
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: maxY / 4,
                  reservedSize: 30,
                  getTitlesWidget: (val, meta) => Text('${val.round()}',
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 10)),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (val, meta) {
                    final i = val.toInt();
                    if (i < 0 || i >= _weekDays.length) return const SizedBox();
                    return Text(_weekDays[i],
                        style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600));
                  },
                ),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: List.generate(
              _weekActivity.length,
              (i) => BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: _weekActivity[i].toDouble(),
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, AppTheme.secondary],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    width: 22,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeckBreakdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: MockData.decks.map((deck) {
          final color =
              AppTheme.deckColors[deck.colorIndex % AppTheme.deckColors.length];
          final accuracyPct = deck.cards.isEmpty
              ? 0
              : (deck.cards
                          .map((c) => c.accuracy)
                          .reduce((a, b) => a + b) /
                      deck.cards.length *
                      100)
                  .round();

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [AppTheme.cardShadow],
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(deck.emoji, style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(deck.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppTheme.textPrimary)),
                          Text('$accuracyPct% acc.',
                              style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: deck.progress,
                          backgroundColor: color.withOpacity(0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                          '${deck.masteredCards} / ${deck.totalCards} mastered',
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDifficultyDistribution() {
    int easy = 0, medium = 0, hard = 0;
    for (final deck in MockData.decks) {
      for (final card in deck.cards) {
        switch (card.difficulty) {
          case CardDifficulty.easy:
            easy++;
            break;
          case CardDifficulty.medium:
            medium++;
            break;
          case CardDifficulty.hard:
            hard++;
            break;
        }
      }
    }
    final total = easy + medium + hard;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [AppTheme.cardShadow],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DiffLabel(
                    label: 'Easy',
                    count: easy,
                    color: AppTheme.success),
                _DiffLabel(
                    label: 'Medium',
                    count: medium,
                    color: AppTheme.accent),
                _DiffLabel(
                    label: 'Hard',
                    count: hard,
                    color: AppTheme.error),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  if (total > 0) ...[
                    _DiffBar(flex: easy, color: AppTheme.success),
                    _DiffBar(flex: medium, color: AppTheme.accent),
                    _DiffBar(flex: hard, color: AppTheme.error),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiffBar extends StatelessWidget {
  final int flex;
  final Color color;
  const _DiffBar({required this.flex, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex == 0 ? 1 : flex,
      child: Container(height: 16, color: color),
    );
  }
}

class _DiffLabel extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _DiffLabel(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count',
            style: TextStyle(
                color: color, fontWeight: FontWeight.w900, fontSize: 22)),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 12)),
        Container(
            width: 24, height: 4, decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(2))),
      ],
    );
  }
}

class _StatItem {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  const _StatItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });
}
