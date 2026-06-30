import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _streakCountKey = 'streak_count';
  static const String _lastVisitDateKey = 'streak_last_visit_date';

  static String _formatDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  static Future<int> updateStreakForToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _formatDate(DateTime.now());
    final lastVisit = prefs.getString(_lastVisitDateKey);
    int streakCount = prefs.getInt(_streakCountKey) ?? 0;

    if (lastVisit == today) {
      return streakCount == 0 ? 1 : streakCount;
    }

    if (lastVisit != null) {
      final lastDate = DateTime.tryParse(lastVisit);
      if (lastDate != null) {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        if (_formatDate(lastDate) == _formatDate(yesterday)) {
          streakCount += 1;
        } else {
          streakCount = 1;
        }
      } else {
        streakCount = 1;
      }
    } else {
      streakCount = 1;
    }

    await prefs.setInt(_streakCountKey, streakCount);
    await prefs.setString(_lastVisitDateKey, today);
    return streakCount;
  }

  static Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakCountKey) ?? 0;
  }

  static Future<String?> getLastVisitDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastVisitDateKey);
  }

  static Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_streakCountKey);
    await prefs.remove(_lastVisitDateKey);
  }
}
