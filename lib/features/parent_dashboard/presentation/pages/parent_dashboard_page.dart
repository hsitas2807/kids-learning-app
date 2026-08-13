import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_theme.dart';

class ParentDashboardPage extends StatefulWidget {
  const ParentDashboardPage({super.key});

  @override
  State<ParentDashboardPage> createState() => _ParentDashboardPageState();
}

class _ParentDashboardPageState extends State<ParentDashboardPage> {
  final StorageService _storageService = StorageService();
  ChildProfile? _child;
  RewardData? _reward;
  List<ProgressData> _progress = <ProgressData>[];
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final child = await _storageService.getChild();
    if (child != null) {
      final reward = await _storageService.getRewards(child.id);
      final progress = await _storageService.getProgress(child.id);
      if (mounted) {
        setState(() {
          _child = child;
          _reward = reward;
          _progress = progress;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.parentTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Parent Dashboard'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(AppRoutes.home),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
              tooltip: 'Settings',
            ),
          ],
        ),
        body: SafeArea(
          child: _child == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildChildCard(),
                      const SizedBox(height: AppConstants.spacing16),
                      _buildProgressCard(),
                      const SizedBox(height: AppConstants.spacing16),
                      _buildRewardsCard(),
                      const SizedBox(height: AppConstants.spacing16),
                      _buildSettingsCard(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildChildCard() {
    const avatarEmojis = <String>[
      '🐱',
      '🐶',
      '🐻',
      '🦁',
      '🐸',
      '🦊',
      '🐧',
      '🦋'
    ];
    final avatar = _child != null && _child!.avatarId < avatarEmojis.length
        ? avatarEmojis[_child!.avatarId]
        : '🐱';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Row(
          children: [
            Text(avatar, style: const TextStyle(fontSize: 48)),
            const SizedBox(width: AppConstants.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _child?.name ?? 'Child',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Age ${_child?.age} • Level ${_child?.learningLevel}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Group: ${_child?.ageGroup}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    final averageAccuracy = _progress.isEmpty
        ? 0.0
        : _progress
                .map((ProgressData p) => p.accuracy)
                .reduce((double a, double b) => a + b) /
            _progress.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learning Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppConstants.spacing12),
            if (_progress.isEmpty)
              const Text(
                'No lessons completed yet. Encourage your child to start learning!',
                style: TextStyle(color: Colors.grey),
              )
            else ...<Widget>[
              Text('Lessons completed: ${_progress.length}'),
              const SizedBox(height: 8),
              Text(
                'Average accuracy: ${(averageAccuracy * 100).toStringAsFixed(0)}%',
              ),
            ],
            const SizedBox(height: AppConstants.spacing12),
            _buildSubjectBar('English', 0.7),
            _buildSubjectBar('Mathematics', 0.6),
            _buildSubjectBar('Science', 0.4),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectBar(String subject, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subject,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('${(progress * 100).toInt()}%'),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: const Color(0xFF1565C0),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rewards', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppConstants.spacing12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRewardItem('⭐', '${_reward?.stars ?? 0}', 'Stars'),
                _buildRewardItem('🪙', '${_reward?.coins ?? 0}', 'Coins'),
                _buildRewardItem('🔥', '${_reward?.streakDays ?? 0}', 'Streak'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardItem(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 32)),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppConstants.spacing12),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Daily Learning Limit'),
              subtitle: const Text('60 minutes'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Sound Effects'),
              trailing: Switch(
                value: _soundEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Background Music'),
              trailing: Switch(
                value: _musicEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _musicEnabled = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
