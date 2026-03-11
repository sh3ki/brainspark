import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../data/study_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/deck_card.dart';
import 'study_session_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final decks = StudyData.decks;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildStatsRow(),
          _buildSectionHeader('Your Decks', '${decks.length} decks'),
          _buildDeckGrid(context, decks),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppTheme.surface,
      pinned: false,
      floating: true,
      elevation: 0,
      titleSpacing: 20,
      title: const AppLogo(size: 38),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.primary,
            child: Text('AJ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Row(
          children: [
            _StatTile(
              icon: Icons.local_fire_department_rounded,
              iconColor: AppTheme.accent,
              value: '${StudyData.currentStreak}',
              label: 'Day Streak',
            ),
            const SizedBox(width: 10),
            _StatTile(
              icon: Icons.star_rounded,
              iconColor: AppTheme.success,
              value: '${StudyData.masteredCards}',
              label: 'Mastered',
            ),
            const SizedBox(width: 10),
            _StatTile(
              icon: Icons.history_edu_rounded,
              iconColor: AppTheme.secondary,
              value: '${StudyData.totalStudySessions}',
              label: 'Sessions',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: AppTheme.textPrimary)),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(subtitle,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeckGrid(BuildContext context, List decks) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.82,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => AnimationConfiguration.staggeredGrid(
            position: i,
            columnCount: 2,
            duration: const Duration(milliseconds: 350),
            child: SlideAnimation(
              verticalOffset: 30,
              child: FadeInAnimation(
                child: DeckCard(
                  deck: decks[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          StudySessionScreen(deck: decks[i]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          childCount: decks.length,
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: TextStyle(
                          color: iconColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 17)),
                  Text(label,
                      style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
