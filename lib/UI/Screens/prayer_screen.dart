import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:quran_app/generated/l10n.dart';

import '../../Utils/prayer_times_manager.dart';
import '../Widgets/location_widget.dart';
import '../Widgets/prayer_info_widget.dart';
import 'package:quran_app/services/background_service.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  HijriCalendar _currentMonth = HijriCalendar.now();
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  final AudioPlayer audioPlayer = AudioPlayer();

  // Change this to a late initialized variable
  late Set<String> _enabledNotifications;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initializeNotifications();
    _requestPermissions();
    _loadEnabledNotifications();
    _initializeBackgroundService();
  }

  Future<void> _requestPermissions() async {
    // Request location permissions
    var locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      print("Location permission granted");
    } else if (locationStatus.isDenied) {
      print("Location permission denied");
      _showPermissionDeniedDialog("Location");
    } else if (locationStatus.isPermanentlyDenied) {
      print("Location permission permanently denied");
      openAppSettings();
    }

    // Request notification permissions
    var notificationStatus = await Permission.notification.request();
    if (notificationStatus.isGranted) {
      print("Notification permission granted");
    } else if (notificationStatus.isDenied) {
      print("Notification permission denied");
      _showPermissionDeniedDialog("Notification");
    } else if (notificationStatus.isPermanentlyDenied) {
      print("Notification permission permanently denied");
      openAppSettings();
    }
  }

  void _showPermissionDeniedDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Permission Required"),
          content: Text(
              "$permissionType permission is required for the app to function properly. Please allow it in the settings."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _requestPermissions();
              },
              child: Text("Retry"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  void _initializeNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        audioPlayer.stop();
        // Handle any other notification tapped logic here
      },
    );

    // Request notification permissions for Android 13+
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin!
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    }

    print("Notifications initialized");
    // Fetch prayer times and schedule notifications
    Provider.of<PrayerTimeManager>(context, listen: false)
        .fetchPrayerTimes(context)
        .then((_) {
      _schedulePrayerNotifications();
    });
  }

  void _schedulePrayerNotifications() {
    if (_flutterLocalNotificationsPlugin == null) return;
    final prayerTimes =
        Provider.of<PrayerTimeManager>(context, listen: false).timings;

    if (prayerTimes.isEmpty) {
      print("No prayer times available.");
      return;
    }

    for (var prayer in PrayerTimeManager.prayersToSchedule) {
      DateTime? prayerTime = prayerTimes[prayer];
      if (prayerTime != null) {
        _scheduleNotification(prayer, prayerTime);
      }
    }
  }

  void _scheduleNotification(String prayer, DateTime prayerTime) {
    final now = DateTime.now();
    var scheduledDate = prayerTime;

    // If the prayer time has already passed for today, schedule it for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    _flutterLocalNotificationsPlugin!.zonedSchedule(
      PrayerTimeManager.prayersToSchedule
          .indexOf(prayer), // Unique ID for each prayer
      'Prayer Time', // Notification title
      'It\'s time for $prayer prayer', // Notification body
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_channel',
          'Prayer Notifications',
          channelDescription: 'Notifications for prayer times',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('azaan'),
          playSound: true,
          enableVibration: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: prayer,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final prayerTimeManager = Provider.of<PrayerTimeManager>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          l10n.prayerTiming,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LocationWidget(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrayerInfoWidget(
              prayerName: prayerTimeManager.prayerName,
              prayerTime: prayerTimeManager.prayerTime,
              nextPrayer: prayerTimeManager.nextPrayer,
            ),
            SizedBox(height: 20),
            _buildMonthHeader(),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildPrayerTimeTile(
                      'Fajr', prayerTimeManager.timings['Fajr'], l10n),
                  _buildPrayerTimeTile(
                      'Sunrise', prayerTimeManager.timings['Sunrise'], l10n),
                  _buildPrayerTimeTile(
                      'Dhuhr', prayerTimeManager.timings['Dhuhr'], l10n),
                  _buildPrayerTimeTile(
                      'Asr', prayerTimeManager.timings['Asr'], l10n),
                  _buildPrayerTimeTile(
                      'Maghrib', prayerTimeManager.timings['Maghrib'], l10n),
                  _buildPrayerTimeTile(
                      'Isha', prayerTimeManager.timings['Isha'], l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimeTile(String prayerKey, DateTime? prayerTime, S l10n) {
    final localizedPrayerName = _getLocalizedPrayerName(prayerKey, l10n);
    final bool isNotificationEnabled =
        _enabledNotifications.contains(prayerKey);

    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/${prayerKey.toLowerCase()}.png",
                width: 40,
                height: 40,
              ),
              SizedBox(width: 10),
              Text(
                localizedPrayerName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                prayerTime != null
                    ? DateFormat.jm().format(prayerTime)
                    : l10n.loading,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () => _toggleNotification(prayerKey),
                child: Icon(
                  isNotificationEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  color: isNotificationEnabled ? Colors.green : Colors.grey,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLocalizedPrayerName(String key, S l10n) {
    switch (key) {
      case 'Fajr':
        return l10n.fajr;
      case 'Sunrise':
        return l10n.sunrise;
      case 'Dhuhr':
        return l10n.dhuhr;
      case 'Asr':
        return l10n.asr;
      case 'Maghrib':
        return l10n.maghrib;
      case 'Isha':
        return l10n.isha;
      default:
        return l10n.loading;
    }
  }

  Widget _buildMonthHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_left,
              color: Colors.white,
              size: 25,
            ),
            onPressed: _previousMonth,
          ),
          Column(
            children: [
              Text(
                '${_currentMonth.getLongMonthName()} ${_currentMonth.hYear}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              Text(
                '${DateFormat.yMMMM().format(_currentMonth.hijriToGregorian(_currentMonth.hYear, _currentMonth.hMonth, _currentMonth.hDay))}',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_right,
              color: Colors.white,
              size: 25,
            ),
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = HijriCalendar.fromDate(
        _currentMonth
            .hijriToGregorian(
              _currentMonth.hYear,
              _currentMonth.hMonth,
              _currentMonth.hDay,
            )
            .subtract(Duration(days: 30)),
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = HijriCalendar.fromDate(
        _currentMonth
            .hijriToGregorian(
              _currentMonth.hYear,
              _currentMonth.hMonth,
              _currentMonth.hDay,
            )
            .add(Duration(days: 30)),
      );
    });
  }

  void _toggleNotification(String prayerKey) {
    setState(() {
      if (_enabledNotifications.contains(prayerKey)) {
        _enabledNotifications.remove(prayerKey);
        _cancelNotification(prayerKey);
      } else {
        _enabledNotifications.add(prayerKey);
        _scheduleNotificationForPrayer(prayerKey);
      }
      _saveEnabledNotifications(); // Add this line to save the changes
    });
  }

  void _scheduleNotificationForPrayer(String prayer) {
    final prayerTimes =
        Provider.of<PrayerTimeManager>(context, listen: false).timings;
    DateTime? prayerTime = prayerTimes[prayer];
    if (prayerTime != null) {
      _scheduleNotification(prayer, prayerTime);
    }
  }

  void _cancelNotification(String prayer) {
    _flutterLocalNotificationsPlugin
        ?.cancel(PrayerTimeManager.prayersToSchedule.indexOf(prayer));
  }

  // Add this method to load enabled notifications from SharedPreferences
  Future<void> _loadEnabledNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enabledNotifications =
          prefs.getStringList('enabledNotifications')?.toSet() ?? Set<String>();
    });
  }

  // Add this method to save enabled notifications to SharedPreferences
  Future<void> _saveEnabledNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'enabledNotifications', _enabledNotifications.toList());
  }

  // Add this method to initialize the background service
  Future<void> _initializeBackgroundService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: BackgroundService.onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: BackgroundService.onStart,
        onBackground: BackgroundService.onIosBackground,
      ),
    );

    service.startService();
  }
}
