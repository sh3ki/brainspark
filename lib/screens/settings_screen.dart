import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _cardsPerSession = 20;
  bool _showHints = true;
  bool _autoFlip = false;
  double _autoFlipSeconds = 5;
  bool _dailyReminder = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 19, minute: 0);

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
                _buildProfileCard(),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Study Preferences',
                  icon: Icons.school_rounded,
                  children: [
                    _buildDropdownTile(),
                    _buildSwitchTile(
                      icon: Icons.lightbulb_rounded,
                      iconColor: AppTheme.accent,
                      title: 'Show Hints',
                      subtitle: 'Display hint prompts during study',
                      value: _showHints,
                      onChanged: (v) => setState(() => _showHints = v),
                    ),
                    _buildSwitchTile(
                      icon: Icons.timer_rounded,
                      iconColor: AppTheme.secondary,
                      title: 'Auto-Flip Timer',
                      subtitle: 'Automatically reveal answer after a delay',
                      value: _autoFlip,
                      onChanged: (v) => setState(() => _autoFlip = v),
                    ),
                    if (_autoFlip)
                      _buildSliderTile(
                        label:
                            'Auto-flip after ${_autoFlipSeconds.round()}s',
                        value: _autoFlipSeconds,
                        min: 2,
                        max: 15,
                        onChanged: (v) =>
                            setState(() => _autoFlipSeconds = v),
                        color: AppTheme.secondary,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'Notifications',
                  icon: Icons.notifications_rounded,
                  children: [
                    _buildSwitchTile(
                      icon: Icons.alarm_rounded,
                      iconColor: AppTheme.primary,
                      title: 'Daily Reminder',
                      subtitle: 'Remind me to study each day',
                      value: _dailyReminder,
                      onChanged: (v) => setState(() => _dailyReminder = v),
                    ),
                    if (_dailyReminder) _buildTimeTile(context),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'About',
                  icon: Icons.info_rounded,
                  children: [
                    _buildInfoTile(
                        icon: Icons.tag_rounded,
                        iconColor: AppTheme.textSecondary,
                        label: 'Version',
                        value: '1.0.0'),
                    _buildInfoTile(
                        icon: Icons.palette_rounded,
                        iconColor: AppTheme.secondary,
                        label: 'Design',
                        value: 'Material 3'),
                  ],
                ),
                const SizedBox(height: 40),
                _buildFooter(),
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
              Icon(Icons.settings_rounded,
                  color: AppTheme.accent, size: 26),
              const SizedBox(width: 10),
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900)),
                  Text('Personalize your experience',
                      style:
                          TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('AJ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Alex Johnson',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text('alex.johnson@example.com',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _ProfileBadge(
                          label: '40 Cards',
                          icon: Icons.style_rounded),
                      const SizedBox(width: 8),
                      _ProfileBadge(
                          label: '5d Streak',
                          icon:
                              Icons.local_fire_department_rounded),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: AppTheme.textPrimary)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppTheme.textPrimary)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.format_list_numbered_rounded,
                color: AppTheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cards per Session',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppTheme.textPrimary)),
                Text('How many cards to study at once',
                    style: TextStyle(
                        color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.divider),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _cardsPerSession,
                isDense: true,
                borderRadius: BorderRadius.circular(12),
                style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
                items: [10, 15, 20, 25, 30, 40].map((v) {
                  return DropdownMenuItem(value: v, child: Text('$v'));
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _cardsPerSession = v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 50),
            child: Divider(color: AppTheme.divider, height: 1),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).round(),
            activeColor: color,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.access_time_rounded,
                color: AppTheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reminder Time',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppTheme.textPrimary)),
                Text('Daily study reminder schedule',
                    style: TextStyle(
                        color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _reminderTime,
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context)
                        .colorScheme
                        .copyWith(primary: AppTheme.primary),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) setState(() => _reminderTime = picked);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _reminderTime.format(context),
                style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppTheme.textPrimary)),
          ),
          Text(value,
              style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const AppLogo(size: 40, showText: true),
        const SizedBox(height: 8),
        const Text('v1.0.0',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
      ],
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _ProfileBadge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white60, size: 12),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
