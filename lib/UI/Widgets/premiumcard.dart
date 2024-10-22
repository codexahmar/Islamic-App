import 'package:flutter/material.dart';
import 'package:quran_app/UI/constants/constants.dart';
import 'package:quran_app/generated/l10n.dart';

class PremiumUpgradeCard extends StatelessWidget {
  const PremiumUpgradeCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Access localized strings using S class
    final localizations = S.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Get the width of the screen
        double screenWidth = constraints.maxWidth;

        // Calculate dynamic sizes based on screen width
        double dotSize =
            screenWidth * 0.015; // Small dot size, 1.5% of screen width
        double fontSize = screenWidth * 0.05; // 5% of the screen width
        double smallFontSize = screenWidth * 0.022; // 2.2% of the screen width
        double padding = screenWidth * 0.03; // 3% of the screen width
        double containerHeight = screenWidth * 0.15; // 15% of the screen width

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: padding, vertical: padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      "assets/images/quran_icon.png",
                      height: containerHeight, // Dynamic height for the image
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          Text(
                            localizations.upgradeToPremium,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: padding),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                size: dotSize, // Smaller dot size
                                color: Colors.white,
                              ),
                              SizedBox(width: padding / 2),
                              Text(
                                localizations.allFeaturesAccess,
                                style: TextStyle(
                                  fontSize: smallFontSize,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: padding),
                              Icon(
                                Icons.circle,
                                size: dotSize, // Smaller dot size
                                color: Colors.white,
                              ),
                              SizedBox(width: padding / 2),
                              Text(
                                localizations.withoutAds,
                                style: TextStyle(
                                  fontSize: smallFontSize,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: containerHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  localizations.purchasePremium,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
