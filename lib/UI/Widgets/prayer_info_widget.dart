import 'package:flutter/material.dart';

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
      margin: EdgeInsets.all(5),
      height: 150,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
                image: AssetImage("assets/images/mosque.png"),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            height: double.infinity,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayerName,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        prayerTime,
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 15),
                      Text(
                        nextPrayer,
                        style: TextStyle(color: Colors.yellow, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
