import 'package:flutter/material.dart';

import '../constants/constants.dart';

class PrayerInfoWidget extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final String nextPrayer;

  const PrayerInfoWidget({
    Key? key,
    required this.prayerName,
    required this.prayerTime,
    required this.nextPrayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayerName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  prayerTime,
                  style: TextStyle(
                      fontSize: 24,
                      color: primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(nextPrayer),
              ],
            ),
            Image.asset(
              "assets/images/masjid_image.png",
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
