import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/generated/l10n.dart';
import '../../../Widgets/location_widget.dart';
import '../../../constants/constants.dart';

class HijriCalendarScreen extends StatefulWidget {
  @override
  _HijriCalendarScreenState createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen> {
  HijriCalendar _currentMonth = HijriCalendar.now();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          S.of(context).calendar,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02), // Adjust padding
            child: LocationWidget(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMonthHeader(screenWidth),
          _buildDayHeaders(screenWidth),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.03), // Adjust padding
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenWidth * 0.04,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
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
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_left,
                  color: Colors.white,
                  size: screenWidth * 0.07,
                ),
                onPressed: _previousMonth,
              ),
            ),
            Column(
              children: [
                Text(
                  '${_currentMonth.getLongMonthName()} ${_currentMonth.hYear}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${DateFormat.yMMMM().format(_currentMonth.hijriToGregorian(_currentMonth.hYear, _currentMonth.hMonth, _currentMonth.hDay))}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                  size: screenWidth * 0.07,
                ),
                onPressed: _nextMonth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayHeaders(double screenWidth) {
    List<String> weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    int currentDayIndex = DateTime.now().weekday % 7;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: screenWidth * 0.01, // Reduced vertical padding
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: weekdays.asMap().entries.map(
          (entry) {
            int index = entry.key;
            String day = entry.value;
            bool isToday = index == currentDayIndex;

            return Column(
              children: [
                Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday ? primaryColor : Colors.black,
                    ),
                  ),
                ),
                if (isToday)
                  Container(
                    margin: EdgeInsets.only(top: screenWidth * 0.01),
                    width: screenWidth * 0.1,
                    height: screenWidth * 0.01,
                    color: primaryColor,
                  ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    int totalDays = _currentMonth.lengthOfMonth;
    int firstWeekday = _currentMonth.hDay;
    List<Widget> dayCells = [];

    for (int i = 1; i < firstWeekday; i++) {
      dayCells.add(Container());
    }

    for (int i = 1; i <= totalDays; i++) {
      bool isToday = _currentMonth.hDay == i &&
          _currentMonth.hMonth == HijriCalendar.now().hMonth &&
          _currentMonth.hYear == HijriCalendar.now().hYear;

      dayCells.add(
        Container(
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: isToday ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: Text(
              '$i',
              style: TextStyle(
                color: isToday ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: GridView.count(
        crossAxisCount: 7,

        padding: EdgeInsets.zero, // Remove extra padding
        children: dayCells,
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = HijriCalendar.fromDate(_currentMonth
          .hijriToGregorian(
              _currentMonth.hYear, _currentMonth.hMonth, _currentMonth.hDay)
          .subtract(Duration(days: 30)));
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = HijriCalendar.fromDate(_currentMonth
          .hijriToGregorian(
              _currentMonth.hYear, _currentMonth.hMonth, _currentMonth.hDay)
          .add(Duration(days: 30)));
    });
  }
}
