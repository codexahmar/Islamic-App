import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';
import '../UI/Widgets/prayer_info_widget.dart';

class HomeScreenWidget extends StatefulWidget {
  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  String _prayerName = "Loading...";
  String _prayerTime = "Loading...";
  String _nextPrayer = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
  }

  Future<void> _fetchPrayerTimes() async {
    try {
      // Dummy data to simulate fetching prayer times
      setState(() {
        _prayerName = "Fajr";
        _prayerTime = "04:45 AM";
        _nextPrayer = "Next: Dhuhr at 12:30 PM";
      });

      // Here you would update the HomeWidget with the fetched prayer times
      await HomeWidget.saveWidgetData<String>('prayerName', _prayerName);
      await HomeWidget.saveWidgetData<String>('prayerTime', _prayerTime);
      await HomeWidget.saveWidgetData<String>('nextPrayer', _nextPrayer);
      await HomeWidget.updateWidget(
        name: 'HomeScreenWidgetProvider',
        iOSName: 'HomeScreenWidget',
      );
    } catch (e) {
      print("Error fetching prayer times: $e");
      setState(() {
        _prayerName = "Error";
        _prayerTime = "Error";
        _nextPrayer = "Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Holy Quran",
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrayerInfoWidget(
                prayerName: _prayerName,
                prayerTime: _prayerTime,
                nextPrayer: _nextPrayer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
