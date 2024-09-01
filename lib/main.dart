import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/prayer_times_manager.dart';
import 'generated/l10n.dart';
import 'UI/Screens/splash_screen.dart';
import 'providers/location_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final String? languageCode = prefs.getString('languageCode');

  runApp(MyApp(
    initialLocale:
        languageCode != null ? Locale(languageCode) : const Locale('en'),
  ));
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimeManager()),
      ],
      child: MaterialApp(
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
        home: const SplashScreen(),
      ),
    );
  }
}
