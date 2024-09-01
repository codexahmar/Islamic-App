import 'package:flutter/material.dart';
import 'package:quran_app/generated/l10n.dart';
import 'package:quran_app/UI/constants/constants.dart';

import '../Screens/surah_list.dart';

class AlQuranWidget extends StatelessWidget {
  const AlQuranWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).alQuranTitle, // Use localized title
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      S.of(context).alQuranSubtitle, // Use localized subtitle
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurahListScreen(),
                          ),
                        );
                      },
                      child: Text(
                        S
                            .of(context)
                            .readNowButton, // Use localized button text
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
