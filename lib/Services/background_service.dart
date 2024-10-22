import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../Utils/prayer_times_manager.dart';

class BackgroundService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    await initializeNotifications();

    Timer.periodic(Duration(minutes: 1), (timer) async {
      await _checkAndNotifyPrayerTimes(service);
    });
  }

  static final Set<String> _playedPrayers = {};

  static Future<void> _checkAndNotifyPrayerTimes(
      ServiceInstance service) async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final enabledNotifications =
        prefs.getStringList('enabledNotifications') ?? [];

    final prayerTimeManager = PrayerTimeManager();
    await prayerTimeManager.fetchPrayerTimes();
    final prayerTimes = prayerTimeManager.timings;

    for (var prayer in PrayerTimeManager.prayersToSchedule) {
      if (enabledNotifications.contains(prayer)) {
        final prayerTime = prayerTimes[prayer];
        if (prayerTime != null &&
            prayerTime.difference(now).inMinutes >= 0 &&
            prayerTime.difference(now).inMinutes < 1) {
          if (!_playedPrayers.contains(prayer)) {
            _showNotification(prayer);
            _playedPrayers.add(prayer);
          }
        } else {
          _playedPrayers.remove(prayer);
        }
      }
    }
  }

  static void _showNotification(String prayer) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'prayer_channel',
      'Prayer Notifications',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('azaan'),
      enableVibration: true,
      fullScreenIntent: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationsPlugin.show(
      0,
      'Prayer Time',
      'It\'s time for $prayer prayer',
      platformChannelSpecifics,
    );
  }
}
