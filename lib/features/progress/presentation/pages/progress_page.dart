import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_theme.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final StorageService _storageService = StorageService();
  List<ProgressData> _progress = <ProgressData>[];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final child = await _storageService.getChild();
    if (child != null) {
      final progress = await _storageService.getProgress(child.id);
      if (mounted) {
        setState(() {
          _progress = progress;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress 📊'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(),
              const SizedBox(height: AppConstants.spacing16),
              _buildSubjectProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final accuracy = _progress.isEmpty
        ? 0.0
        : _progress
                .map((ProgressData p) => p.accuracy)
                .reduce((double a, double b) => a + b) /
            _progress.length;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppTheme.primaryColor, AppTheme.primaryLight],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('📚', '${_progress.length}', 'Lessons'),
          _buildStat('🎯', '${(accuracy * 100).toInt()}%', 'Accuracy'),
          _buildStat(
            '⭐',
            '${_progress.fold<int>(0, (int sum, ProgressData p) => sum + p.starsEarned)}',
            'Stars',
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
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

  Widget _buildSubjectProgress() {
    const subjects = <Map<String, Object>>[
      <String, Object>{'name': 'English', 'icon': '📖', 'progress': 0.7},
      <String, Object>{'name': 'Mathematics', 'icon': '🔢', 'progress': 0.5},
      <String, Object>{'name': 'Science', 'icon': '🔬', 'progress': 0.3},
      <String, Object>{'name': 'Art', 'icon': '🎨', 'progress': 0.2},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject Progress',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppConstants.spacing12),
        ...subjects.map((Map<String, Object> subject) {
          return _buildSubjectCard(subject);
        }),
      ],
    );
  }

  Widget _buildSubjectCard(Map<String, Object> subject) {
    final progress = subject['progress']! as double;
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing12),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Row(
          children: [
            Text(subject['icon']! as String,
                style: const TextStyle(fontSize: 32)),
            const SizedBox(width: AppConstants.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subject['name']! as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text('${(progress * 100).toInt()}%'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      color: AppTheme.primaryColor,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
