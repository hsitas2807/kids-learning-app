import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/home_nav_button.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final StorageService _storageService = StorageService();
  ChildProfile? _child;

  static const List<String> _avatarEmojis = <String>[
    '🐱',
    '🐶',
    '🐻',
    '🦁',
    '🐸',
    '🦊',
    '🐧',
    '🦋',
  ];

  final List<Map<String, Object>> _menuItems = const <Map<String, Object>>[
    <String, Object>{
      'icon': '📚',
      'label': 'Learn',
      'route': AppRoutes.learning,
      'color': Color(0xFF6C63FF),
    },
    <String, Object>{
      'icon': '🎮',
      'label': 'Games',
      'route': AppRoutes.games,
      'color': Color(0xFFFF6B6B),
    },
    <String, Object>{
      'icon': '📖',
      'label': 'Stories',
      'route': AppRoutes.stories,
      'color': Color(0xFF4CAF50),
    },
    <String, Object>{
      'icon': '🎨',
      'label': 'Draw',
      'route': AppRoutes.drawing,
      'color': Color(0xFFFF9800),
    },
    <String, Object>{
      'icon': '🏆',
      'label': 'Rewards',
      'route': AppRoutes.rewards,
      'color': Color(0xFFFFD700),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadChild();
  }

  Future<void> _loadChild() async {
    final child = await _storageService.getChild();
    if (mounted) {
      setState(() {
        _child = child;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _child != null && _child!.avatarId < _avatarEmojis.length
        ? _avatarEmojis[_child!.avatarId]
        : '🐱';

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(avatar),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppConstants.spacing16,
                  mainAxisSpacing: AppConstants.spacing16,
                  children: _menuItems
                      .map(
                        (Map<String, Object> item) => HomeNavButton(
                          icon: item['icon']! as String,
                          label: item['label']! as String,
                          color: item['color']! as Color,
                          onTap: () => context.push(item['route']! as String),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Open parent dashboard',
        child: FloatingActionButton(
          onPressed: () => context.push(AppRoutes.pinEntry),
          backgroundColor: AppTheme.textSecondary,
          mini: true,
          child: const Icon(Icons.settings, size: 20),
        ),
      ),
    );
  }

  Widget _buildHeader(String avatar) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppTheme.primaryColor, AppTheme.primaryLight],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.radiusXLarge),
          bottomRight: Radius.circular(AppConstants.radiusXLarge),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            ),
            child: Center(
              child: Text(avatar, style: const TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(width: AppConstants.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${_child?.name ?? 'Friend'}! 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'What shall we learn today?',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
