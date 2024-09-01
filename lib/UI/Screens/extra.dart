import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../generated/l10n.dart';

class ExtraFeatures extends StatefulWidget {
  const ExtraFeatures({super.key});

  @override
  State<ExtraFeatures> createState() => _ExtraUiFeaturesState();
}

class _ExtraUiFeaturesState extends State<ExtraFeatures> {
  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.extraFeatures,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("This is for premium users")],
        ),
      ),
    );
  }
}
