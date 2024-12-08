import 'package:flutter/material.dart';
import 'package:quran_app/UI/constants/constants.dart';

class IconContainerWidget extends StatelessWidget {
  final String imagePath;
  final String label;

  const IconContainerWidget({
    Key? key,
    required this.imagePath,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Added padding to adjust the container
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Added box shadow
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 40,
              color: primaryColor,
            ),
            const SizedBox(height: 5),
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
