import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../../main.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).selectLanguage),
      ),
      body: ListView(
        children: [
          _buildLanguageOption(context, 'English', 'en'),
          _buildLanguageOption(context, 'اردو', 'ur'),
          _buildLanguageOption(context, 'Türkçe', 'tr'),
          _buildLanguageOption(context, 'العربية', 'ar'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String language, String code) {
    return ListTile(
      title: Text(language),
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('languageCode', code);

        // Reload the app with the selected locale
        MyApp.setLocale(context, Locale(code));
      },
    );
  }
}
