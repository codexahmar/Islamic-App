import 'package:flutter/material.dart';

class IconContainerWidget extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap; // Added onTap parameter

  const IconContainerWidget({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onTap, // Initialize the onTap parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Added padding to adjust the container
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: onTap, // Handle tap events
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(3, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Image.asset(imagePath, height: 40),
              const SizedBox(height: 5),
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
