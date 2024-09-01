import 'package:flutter/material.dart';

class SettingsOption extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color color;
  final VoidCallback onTap;

  const SettingsOption({
    super.key,
    required this.title,
    required this.imagePath,
    required this.color,
    required this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Image.asset(
            height: 50,
            imagePath,
            color: color,
          ),
        ],
      ),
    );
  }
}
