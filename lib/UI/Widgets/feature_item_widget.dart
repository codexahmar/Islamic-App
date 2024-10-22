import 'package:flutter/material.dart';
import 'package:quran_app/UI/constants/constants.dart';

class FeatureItemWidget extends StatelessWidget {
  final String imagePath;
  final String label;

  final Color? color;

  const FeatureItemWidget(
      {super.key, required this.imagePath, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, color: primaryColor, height: 40),
            const SizedBox(height: 20),
            Text(
              label,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
