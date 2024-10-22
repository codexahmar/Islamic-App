import 'package:flutter/material.dart';

import 'package:quran_app/generated/l10n.dart';

import '../constants/constants.dart';
import 'BottomBar Screens/CalendarScreen/calendar_screen.dart';
import 'BottomBar Screens/HomeScreen/home_screen.dart';
import 'BottomBar Screens/QiblaScreen/qibla_screen.dart';
import 'BottomBar Screens/SettingsScreen/settings_screen.dart';


class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  var selectedIndex = 0;
  List<Widget> tabs = [];

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    tabs = [
      HomeScreen(),
      HijriCalendarScreen(),
      QiblahScreen(),
      SettingsScreen()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => onTap(index),
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        iconSize: 28,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/home_icon.png",
              height: 30,
              color: selectedIndex == 0 ? primaryColor : Colors.grey,
            ),
            label: localization.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              color: selectedIndex == 1 ? primaryColor : Colors.grey,
            ),
            label: localization.calendar,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/qibla_icon.png",
              height: 30,
              color: selectedIndex == 2 ? primaryColor : Colors.grey,
            ),
            label: localization.qibla,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/settings.png",
              height: 30,
              color: selectedIndex == 3 ? primaryColor : Colors.grey,
            ),
            label: localization.settings,
          ),
        ],
      ),
      body: tabs[selectedIndex],
    );
  }
}
