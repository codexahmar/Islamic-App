import 'package:flutter/material.dart';
import 'package:quran_app/UI/constants/constants.dart';

class FeatureItemWidget extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const FeatureItemWidget(
      {super.key,
      required this.imagePath,
      required this.label,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
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
      ),
    );
  }
}
