import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quran_app/providers/alarm_provider.dart';
import 'package:quran_app/services/rating_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'UI/Widgets/rating_dialog.dart';
import 'Utils/prayer_times_manager.dart';
import 'generated/l10n.dart';

import 'providers/location_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'providers/chat_service_provider.dart';
import 'splash_screen.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Permission.microphone.request();

  tz.initializeTimeZones();

  final prefs = await SharedPreferences.getInstance();
  final String? languageCode = prefs.getString('languageCode');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimeManager()),
        ChangeNotifierProvider(create: (_) => alarmprovider()),
        ChangeNotifierProvider(create: (_) => ChatServiceProvider()),
      ],
      child: MyApp(
        initialLocale:
            languageCode != null ? Locale(languageCode) : const Locale('en'),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Locale? initialLocale;

  const MyApp({super.key, this.initialLocale});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: _locale,
      builder: (context, child) {
        return WillPopScope(
          onWillPop: () async {
            if (Navigator.of(context).canPop()) {
              return true;
            }
            final hasRated = await RatingService.hasUserRated();
            if (!hasRated) {
              final shouldExit = await showDialog<bool>(
                context: context,
                builder: (context) => const AppRatingDialog(),
              );
              return shouldExit ?? false;
            }
            return true;
          },
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}
