import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../providers/location_provider.dart';
import '../constants/constants.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<LocationProvider>(context).currentLocation;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/location_icon.png",
            color: primaryColor,
            height: 20,
          ),
          const SizedBox(width: 12),
          Text(
            location.isEmpty ? S.of(context).fetchingLocation : location,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
