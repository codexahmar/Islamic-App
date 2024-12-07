import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class RatingService {
  static const String _hasRatedKey = 'has_rated_app';
  static const String _lastPromptDateKey = 'last_rating_prompt_date';
  static const String _firstOpenTimeKey = 'first_open_time';
  static const String _isFirstOpenKey = 'is_first_open';

  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.islamicazan.shzoneabbe';
  static const String webPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.islamicazan.shzoneabbe';

  static Future<bool> hasUserRated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasRatedKey) ?? false;
  }

  static Future<void> setUserRated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasRatedKey, true);
  }

  static Future<void> initializeFirstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstOpen = prefs.getBool(_isFirstOpenKey) ?? true;

    if (isFirstOpen) {
      await prefs.setBool(_isFirstOpenKey, false);
      await prefs.setString(
          _firstOpenTimeKey, DateTime.now().toIso8601String());
    }
  }

  static Future<bool> shouldShowRating() async {
    final prefs = await SharedPreferences.getInstance();

    // If already rated, don't show
    if (await hasUserRated()) return false;

    final firstOpenTimeStr = prefs.getString(_firstOpenTimeKey);
    if (firstOpenTimeStr == null) return false;

    final firstOpenTime = DateTime.parse(firstOpenTimeStr);
    final timeSinceFirstOpen = DateTime.now().difference(firstOpenTime);

    // For first-time users, only show after 5-10 minutes
    if (timeSinceFirstOpen.inMinutes < 5) return false;

    final lastPrompt = prefs.getString(_lastPromptDateKey);

    // If no last prompt, and it's been more than 5 minutes since first open
    if (lastPrompt == null) {
      // Random time between 5 and 10 minutes
      final randomMinutes = 5 + Random().nextInt(6);
      return timeSinceFirstOpen.inMinutes >= randomMinutes;
    }

    final lastPromptDate = DateTime.parse(lastPrompt);
    final daysSinceLastPrompt =
        DateTime.now().difference(lastPromptDate).inDays;

    // Show randomly every 3 days with 30% chance
    return daysSinceLastPrompt >= 3 && Random().nextDouble() < 0.3;
  }

  static Future<void> updateLastPromptDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPromptDateKey, DateTime.now().toIso8601String());
  }

  static Future<void> openPlayStore() async {
    try {
      final url = Uri.parse(playStoreUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        final webUrl = Uri.parse(webPlayStoreUrl);
        await launchUrl(webUrl);
      }
    } catch (e) {
      print('Error opening Play Store: $e');
    }
  }
}
