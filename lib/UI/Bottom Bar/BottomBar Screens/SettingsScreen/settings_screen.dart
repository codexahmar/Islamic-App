// import 'package:share_plus/share_plus.dart';
import 'package:quran_app/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quran_app/generated/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

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
              // PremiumUpgradeCard(),
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
  void _initializeMobileAdsSDK() async {
    MobileAds.instance.initialize();
  }

  @override
  void initState() {
    super.initState();

    _initializeMobileAdsSDK();

    _loadCurrentLanguage();
  }

  final url_app =
      'https://play.google.com/store/apps/details?id=com.islamicazan.shzoneabbe';
  final privacy_policy =
      'https://www.termsfeed.com/live/63aa5ba8-5201-4175-bf28-97950de2f568';

  String _currentLanguage = 'en'; // Default to English

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
              onTap: () async {
                final Uri _url = Uri.parse(privacy_policy);
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
            ),
            const SizedBox(height: 10),
            SettingsOption(
              title: S.of(context).shareApp,
              imagePath: "assets/images/arrow.png",
              color: primaryColor,
              onTap: () async {
                final Uri _url = Uri.parse(url_app);
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
                // Share.share('Check out this app: $url_app'); // Replace with your app link

                // Add your share app logic here
              },
            ),
            const SizedBox(height: 10),
            SettingsOption(
              title: S.of(context).rateUs,
              imagePath: "assets/images/arrow.png",
              color: primaryColor,
              onTap: () async {
                final Uri _url = Uri.parse(url_app);
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
                // Handle tap for Rate Us
              },
            ),
            const SizedBox(height: 10),
            SettingsOption(
              title: S.of(context).moreApps,
              imagePath: "assets/images/arrow.png",
              color: primaryColor,
              onTap: () async {
                final Uri _url = Uri.parse(url_app);
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
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

  void _loadCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLanguage = prefs.getString('languageCode') ?? 'en';
    });
  }
}
