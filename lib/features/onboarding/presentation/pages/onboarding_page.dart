import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/security/secure_storage_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utilities/validators.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  final StorageService _storageService = StorageService();
  final TextEditingController _nameController = TextEditingController();
  int _currentStep = 0;

  String _childName = '';
  int _childAge = 4;
  int _selectedAvatar = 0;
  int _learningLevel = 1;
  String _ageGroup = AppConstants.ageGroup34;

  final List<String> _avatarEmojis = <String>[
    '🐱',
    '🐶',
    '🐻',
    '🦁',
    '🐸',
    '🦊',
    '🐧',
    '🦋',
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onAgeChanged(int age) {
    setState(() {
      _childAge = age;
      if (age <= 4) {
        _ageGroup = AppConstants.ageGroup34;
        _learningLevel = AppConstants.levelBeginner;
      } else if (age <= 6) {
        _ageGroup = AppConstants.ageGroup56;
        _learningLevel = AppConstants.levelIntermediate;
      } else {
        _ageGroup = AppConstants.ageGroup78;
        _learningLevel = AppConstants.levelAdvanced;
      }
    });
  }

  Future<void> _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final child = ChildProfile(
        id: 1,
        name: _childName.trim(),
        age: _childAge,
        avatarId: _selectedAvatar,
        learningLevel: _learningLevel,
        ageGroup: _ageGroup,
      );
      await _storageService.saveChild(child);
      await _storageService.saveRewards(const RewardData(childId: 1));
      final storage = SecureStorageService();
      await storage.setOnboardingComplete(true);
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomeStep(),
                  _buildNameStep(),
                  _buildAgeStep(),
                  _buildAvatarStep(),
                  _buildLevelStep(),
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: Row(
        children: List<Widget>.generate(5, (int index) {
          return Expanded(
            child: Container(
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? AppTheme.primaryColor
                    : AppTheme.textLight,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWelcomeStep() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('👋', style: TextStyle(fontSize: 80)),
          const SizedBox(height: AppConstants.spacing24),
          Text(
            'Welcome!',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacing16),
          Text(
            "Let's create your child's\nlearning profile!",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacing32),
          const Icon(Icons.lock_outline, color: AppTheme.textSecondary),
          const SizedBox(height: 8),
          Text(
            'No account needed • Works offline • Private & secure',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNameStep() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('✏️', style: TextStyle(fontSize: 60)),
          const SizedBox(height: AppConstants.spacing24),
          Text(
            "What's your child's nickname?",
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacing32),
          TextFormField(
            controller: _nameController,
            autofocus: false,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Enter nickname',
              errorText: _childName.isEmpty
                  ? null
                  : Validators.validateChildName(_childName),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(AppConstants.spacing16),
            ),
            onChanged: (String value) {
              setState(() {
                _childName = value;
              });
            },
            maxLength: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildAgeStep() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎂', style: TextStyle(fontSize: 60)),
          const SizedBox(height: AppConstants.spacing24),
          Text(
            'How old is ${_childName.isNotEmpty ? _childName : 'your child'}?',
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacing32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(6, (int i) {
              final age = i + 3;
              return Padding(
                padding: const EdgeInsets.all(AppConstants.spacing8),
                child: InkWell(
                  onTap: () => _onAgeChanged(age),
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _childAge == age
                          ? AppTheme.primaryColor
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$age',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _childAge == age
                              ? Colors.white
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppConstants.spacing24),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacing16,
              vertical: AppConstants.spacing8,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Text(
              'Learning Level: $_ageGroup',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStep() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_avatarEmojis[_selectedAvatar],
              style: const TextStyle(fontSize: 80)),
          const SizedBox(height: AppConstants.spacing16),
          Text(
            'Choose an Avatar',
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacing32),
          Wrap(
            spacing: AppConstants.spacing16,
            runSpacing: AppConstants.spacing16,
            alignment: WrapAlignment.center,
            children: List<Widget>.generate(_avatarEmojis.length, (int i) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatar = i;
                  });
                },
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _selectedAvatar == i
                        ? AppTheme.primaryColor.withOpacity(0.15)
                        : Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                    border: Border.all(
                      color: _selectedAvatar == i
                          ? AppTheme.primaryColor
                          : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _avatarEmojis[i],
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelStep() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎓', style: TextStyle(fontSize: 60)),
          const SizedBox(height: AppConstants.spacing16),
          Text(
            'Learning Level',
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Based on age: $_ageGroup',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppConstants.spacing32),
          ..._buildLevelCards(),
        ],
      ),
    );
  }

  List<Widget> _buildLevelCards() {
    const levels = <Map<String, Object>>[
      <String, Object>{
        'level': 1,
        'label': 'Beginner',
        'ages': 'Ages 3–4',
        'emoji': '🌱',
        'desc': 'Alphabet, Numbers, Colors, Shapes',
      },
      <String, Object>{
        'level': 2,
        'label': 'Explorer',
        'ages': 'Ages 5–6',
        'emoji': '🌟',
        'desc': 'Phonics, Reading, Addition, Time',
      },
      <String, Object>{
        'level': 3,
        'label': 'Champion',
        'ages': 'Ages 7–8',
        'emoji': '🏆',
        'desc': 'Grammar, Multiplication, Science',
      },
    ];

    return levels.map((Map<String, Object> level) {
      final isSelected = _learningLevel == level['level'];
      return GestureDetector(
        onTap: () {
          setState(() {
            _learningLevel = level['level']! as int;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: AppConstants.spacing12),
          padding: const EdgeInsets.all(AppConstants.spacing16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryColor.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 4),
            ],
          ),
          child: Row(
            children: [
              Text(level['emoji']! as String,
                  style: const TextStyle(fontSize: 32)),
              const SizedBox(width: AppConstants.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${level['label']} — ${level['ages']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      level['desc']! as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppTheme.primaryColor),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildNavigationButtons() {
    final canProceed = _currentStep != 1 ||
        Validators.validateChildName(_childName.trim()) == null;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _goToPreviousStep,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    AppConstants.minTouchTarget,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusLarge),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: AppConstants.spacing12),
          Expanded(
            flex: _currentStep > 0 ? 2 : 1,
            child: ElevatedButton(
              onPressed: canProceed
                  ? (_currentStep == 4 ? _completeOnboarding : _goToNextStep)
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  AppConstants.minTouchTarget,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(_currentStep == 4 ? "Let's Go! 🚀" : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}
