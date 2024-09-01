import 'package:flutter/material.dart';
import 'package:quran_app/generated/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Screens/language_selection.dart';
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

class SettingsOptionCard extends StatelessWidget {
  const SettingsOptionCard({super.key});

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
                // Handle tap for Share App
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
              },
            ),
            const SizedBox(height: 10),
            SettingsOption(
              title: S.of(context).languageSelection,
              imagePath: "assets/images/arrow.png",
              color: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageSelectionScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
