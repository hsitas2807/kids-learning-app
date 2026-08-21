import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_theme.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final StorageService _storageService = StorageService();
  RewardData? _reward;
  int _lessonsCompleted = 0;

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  Future<void> _loadRewards() async {
    final child = await _storageService.getChild();
    if (child != null) {
      final reward = await _storageService.getRewards(child.id);
      final progress = await _storageService.getProgress(child.id);
      if (mounted) {
        setState(() {
          _reward = reward;
          _lessonsCompleted = progress.length;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rewards 🏆'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          child: Column(
            children: [
              _buildRewardsSummary(),
              const SizedBox(height: AppConstants.spacing24),
              _buildBadgesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardsSummary() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppTheme.primaryColor, AppTheme.primaryLight],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('⭐', '${_reward?.stars ?? 0}', 'Stars'),
          _buildStat('🪙', '${_reward?.coins ?? 0}', 'Coins'),
          _buildStat('🔥', '${_reward?.streakDays ?? 0}', 'Day Streak'),
        ],
      ),
    );
  }

  Widget _buildStat(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 36)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
    // Badge unlock conditions derived from real progress/reward data.
    final streak = _reward?.streakDays ?? 0;
    final stars = _reward?.stars ?? 0;
    final badges = <Map<String, Object>>[
      <String, Object>{
        'icon': '🌟',
        'name': 'First Lesson',
        'locked': _lessonsCompleted == 0,
      },
      <String, Object>{
        'icon': '📚',
        'name': 'Bookworm',
        'locked': _lessonsCompleted < 10,
      },
      <String, Object>{
        'icon': '🔢',
        'name': 'Math Wizard',
        'locked': stars < 50,
      },
      <String, Object>{
        'icon': '🎨',
        'name': 'Artist',
        'locked': _lessonsCompleted < 5,
      },
      <String, Object>{
        'icon': '🏃',
        'name': '7-Day Streak',
        'locked': streak < 7,
      },
      <String, Object>{
        'icon': '🎯',
        'name': 'Perfect Score',
        'locked': stars < 100,
      },
    ];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Badges', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppConstants.spacing12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: AppConstants.spacing12,
              mainAxisSpacing: AppConstants.spacing12,
              children: badges.map((Map<String, Object> badge) {
                final isLocked = badge['locked']! as bool;
                return Container(
                  decoration: BoxDecoration(
                    color: isLocked ? Colors.grey.shade200 : Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        badge['icon']! as String,
                        style: const TextStyle(fontSize: 36),
                      ),
                      if (isLocked)
                        const Icon(Icons.lock, size: 14, color: Colors.grey)
                      else
                        const SizedBox.shrink(),
                      const SizedBox(height: 4),
                      Text(
                        badge['name']! as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: isLocked ? Colors.grey : AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
