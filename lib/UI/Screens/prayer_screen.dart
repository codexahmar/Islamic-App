import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:quran_app/generated/l10n.dart';

import '../../Utils/prayer_times_manager.dart';
import '../Widgets/location_widget.dart';
import '../Widgets/prayer_info_widget.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  HijriCalendar _currentMonth = HijriCalendar.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PrayerTimeManager>(context, listen: false)
            .fetchPrayerTimes(context));
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
              Icon(
                Icons.notifications,
                color: Colors.grey,
                size: 24,
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
}
