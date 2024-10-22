import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quran_app/generated/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Widgets/premiumcard.dart';
import '../../../Widgets/settingsCard.dart';
import '../../../Widgets/location_widget.dart';
import '../../../constants/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          S.of(context).settingsTitle,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LocationWidget(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              PremiumUpgradeCard(),
              SizedBox(height: 40),
              SettingsOptionCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsOptionCard extends StatefulWidget {
  const SettingsOptionCard({super.key});

  @override
  State<SettingsOptionCard> createState() => _SettingsOptionCardState();
}

class _SettingsOptionCardState extends State<SettingsOptionCard> {
  InterstitialAd? _interstitialAd;
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  AudioPlayer audioPlayer = AudioPlayer();

  String _currentLanguage = 'en'; // Default to English

  void _initializeMobileAdsSDK() async {
    MobileAds.instance.initialize();
    _loadAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _initializeMobileAdsSDK();
    _loadAd();
    _initializeNotifications();
    _loadCurrentLanguage();
  }

  void _initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        // Handle notification taps here
      },
    );

    // Request notification permissions for Android 13+
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin!
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    }
  }

  Future<void> _showInstantNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'instant_channel_id',
      'Instant Notifications',
      channelDescription: 'Notifications for instant messages',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('azaan'),
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    try {
      await flutterLocalNotificationsPlugin!.show(
        0,
        'Share App',
        'Thanks for sharing our app!',
        platformChannelSpecifics,
      );
      await audioPlayer.play(AssetSource('audio/azaan.mp3'));
    } on PlatformException catch (e) {
      print('Failed to show notification: ${e.message}');
    }
  }

  Future<void> _scheduleDelayedNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'delayed_channel_id',
      'Delayed Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin!.zonedSchedule(
      1,
      'Share App Reminder',
      'Don\'t forget to share our app with your friends!',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _loadAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _loadCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLanguage = prefs.getString('languageCode') ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          children: [
            SettingsOption(
              title: S.of(context).privacyPolicy,
              imagePath: "assets/images/arrow.png",
              color: primaryColor,
              onTap: () {
                // Handle tap for Privacy Policy
              },
            ),
            const SizedBox(height: 10),
            SettingsOption(
              title: S.of(context).shareApp,
              imagePath: "assets/images/arrow.png",
              color: primaryColor,
              onTap: () {
                _showInstantNotification();
                _scheduleDelayedNotification();
                // Add your share app logic here
              },
            ),
            const SizedBox(height: 10),
            SettingsOption(
              title: S.of(context).rateUs,
              imagePath: "assets/images/arrow.png",
              color: primaryColor,
              onTap: () {
                // Handle tap for Rate Us
              },
            ),
            const SizedBox(height: 10),
            SettingsOption(
              title: S.of(context).moreApps,
              imagePath: "assets/images/arrow.png",
              color: primaryColor,
              onTap: () {
                // Handle tap for More Apps
                _interstitialAd?.show();
              },
            ),
            const SizedBox(height: 10),
            _buildLanguageDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).languageSelection,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        DropdownButton<String>(
          value: _currentLanguage,
          onChanged: (String? newValue) {
            if (newValue != null) {
              _changeLanguage(newValue);
            }
          },
          items: <String>['en', 'ur', 'tr', 'ar']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(_getLanguageName(value)),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ur':
        return 'اردو';
      case 'tr':
        return 'Türkçe';
      case 'ar':
        return 'العربية';
      default:
        return 'Unknown';
    }
  }

  void _changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);

    setState(() {
      _currentLanguage = languageCode;
    });

    // Reload the app with the selected locale
    MyApp.setLocale(context, Locale(languageCode));
  }
}
