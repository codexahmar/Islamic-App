
//  CREATED THIS FILE TO MAKE WIDGET FOR THE HOME SCREEN




// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; 
// import '../../Services/prayer_times_services.dart';

// class PrayerTimesScreen extends StatefulWidget {
//   @override
//   _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
// }

// class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
//   String _prayerTimes = "Fetching prayer times...";

//   @override
//   void initState() {
//     super.initState();
//     _fetchPrayerTimes();
//   }

//   Future<void> _fetchPrayerTimes() async {
//     final service = PrayerTimesService();
//     try {
//       final timings = await service.getPrayerTimes();

//       // Format the prayer times
//       final formattedTimes =
//           "Fajr: ${DateFormat.jm().format(timings['Fajr']!)}\n"
//           "Sunrise: ${DateFormat.jm().format(timings['Sunrise']!)}\n"
//           "Dhuhr: ${DateFormat.jm().format(timings['Dhuhr']!)}\n"
//           "Asr: ${DateFormat.jm().format(timings['Asr']!)}\n"
//           "Maghrib: ${DateFormat.jm().format(timings['Maghrib']!)}\n"
//           "Isha: ${DateFormat.jm().format(timings['Isha']!)}";

//       // Update the UI
//       setState(() {
//         _prayerTimes = formattedTimes;
//       });

//       // Print the prayer times to the console
//       print("Prayer Times:");
//       print(formattedTimes);
//     } catch (e) {
//       setState(() {
//         _prayerTimes = "Error fetching prayer times.";
//       });

//       // Print the error to the console
//       print("Error fetching prayer times: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Prayer Times"),
//       ),
//       body: Center(
//         child: Text(
//           _prayerTimes,
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }

// 