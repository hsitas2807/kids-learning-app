import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ChildProfile {
  final int id;
  final String name;
  final int age;
  final int avatarId;
  final int learningLevel;
  final String ageGroup;

  const ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.avatarId,
    required this.learningLevel,
    required this.ageGroup,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'age': age,
        'avatarId': avatarId,
        'learningLevel': learningLevel,
        'ageGroup': ageGroup,
      };

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
        id: json['id'] as int,
        name: json['name'] as String,
        age: json['age'] as int,
        avatarId: json['avatarId'] as int,
        learningLevel: json['learningLevel'] as int,
        ageGroup: json['ageGroup'] as String,
      );
}

class RewardData {
  final int childId;
  final int stars;
  final int coins;
  final int streakDays;

  const RewardData({
    required this.childId,
    this.stars = 0,
    this.coins = 0,
    this.streakDays = 0,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'childId': childId,
        'stars': stars,
        'coins': coins,
        'streakDays': streakDays,
      };

  factory RewardData.fromJson(Map<String, dynamic> json) => RewardData(
        childId: json['childId'] as int,
        stars: json['stars'] as int? ?? 0,
        coins: json['coins'] as int? ?? 0,
        streakDays: json['streakDays'] as int? ?? 0,
      );
}

class ProgressData {
  final int lessonId;
  final double accuracy;
  final int starsEarned;
  final DateTime completedAt;

  const ProgressData({
    required this.lessonId,
    required this.accuracy,
    required this.starsEarned,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'lessonId': lessonId,
        'accuracy': accuracy,
        'starsEarned': starsEarned,
        'completedAt': completedAt.toIso8601String(),
      };

  factory ProgressData.fromJson(Map<String, dynamic> json) => ProgressData(
        lessonId: json['lessonId'] as int,
        accuracy: (json['accuracy'] as num).toDouble(),
        starsEarned: json['starsEarned'] as int? ?? 0,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );
}

class StorageService {
  static const String _childKey = 'child_profile';
  static const String _rewardsKey = 'rewards';
  static const String _progressKey = 'progress';

  Future<ChildProfile?> getChild() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_childKey);
    if (json == null) {
      return null;
    }
    return ChildProfile.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> saveChild(ChildProfile child) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_childKey, jsonEncode(child.toJson()));
  }

  Future<RewardData?> getRewards(int childId) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('${_rewardsKey}_$childId');
    if (json == null) {
      return null;
    }
    return RewardData.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> saveRewards(RewardData rewards) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '${_rewardsKey}_${rewards.childId}',
      jsonEncode(rewards.toJson()),
    );
  }

  Future<List<ProgressData>> getProgress(int childId) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('${_progressKey}_$childId');
    if (json == null) {
      return <ProgressData>[];
    }
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((dynamic e) => ProgressData.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addProgress(int childId, ProgressData progress) async {
    final existing = await getProgress(childId);
    final updated = <ProgressData>[...existing, progress];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '${_progressKey}_$childId',
      jsonEncode(updated.map((ProgressData p) => p.toJson()).toList()),
    );
  }
}
