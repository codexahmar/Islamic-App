// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Holy Quran`
  String get appTitle {
    return Intl.message(
      'Holy Quran',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `More Features`
  String get moreFeatures {
    return Intl.message(
      'More Features',
      name: 'moreFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Tasbeeh Counter`
  String get tasbeehCounter {
    return Intl.message(
      'Tasbeeh Counter',
      name: 'tasbeehCounter',
      desc: '',
      args: [],
    );
  }

  /// `Daily Azkar`
  String get dailyAzkar {
    return Intl.message(
      'Daily Azkar',
      name: 'dailyAzkar',
      desc: '',
      args: [],
    );
  }

  /// `40 Rabbana`
  String get fortyRabana {
    return Intl.message(
      '40 Rabbana',
      name: 'fortyRabana',
      desc: '',
      args: [],
    );
  }

  /// `Prayer Timing`
  String get prayerTiming {
    return Intl.message(
      'Prayer Timing',
      name: 'prayerTiming',
      desc: '',
      args: [],
    );
  }

  /// `Nearby Masjid`
  String get nearbyMasjid {
    return Intl.message(
      'Nearby Masjid',
      name: 'nearbyMasjid',
      desc: '',
      args: [],
    );
  }

  /// `Six Kalimas`
  String get sixKalima {
    return Intl.message(
      'Six Kalimas',
      name: 'sixKalima',
      desc: '',
      args: [],
    );
  }

  /// `Ahadees`
  String get ahadees {
    return Intl.message(
      'Ahadees',
      name: 'ahadees',
      desc: '',
      args: [],
    );
  }

  /// `99 Names`
  String get ninetyNineNames {
    return Intl.message(
      '99 Names',
      name: 'ninetyNineNames',
      desc: '',
      args: [],
    );
  }

  /// `Islamic Chatbot`
  String get islamicChatbot {
    return Intl.message(
      'Islamic Chatbot',
      name: 'islamicChatbot',
      desc: '',
      args: [],
    );
  }

  /// `Surah`
  String get surah {
    return Intl.message(
      'Surah',
      name: 'surah',
      desc: '',
      args: [],
    );
  }

  /// `Juzz`
  String get juzz {
    return Intl.message(
      'Juzz',
      name: 'juzz',
      desc: '',
      args: [],
    );
  }

  /// `MP3`
  String get mp3 {
    return Intl.message(
      'MP3',
      name: 'mp3',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Saved`
  String get saved {
    return Intl.message(
      'Saved',
      name: 'saved',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `Qibla`
  String get qibla {
    return Intl.message(
      'Qibla',
      name: 'qibla',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Fajr`
  String get fajr {
    return Intl.message(
      'Fajr',
      name: 'fajr',
      desc: '',
      args: [],
    );
  }

  /// `Sunrise`
  String get sunrise {
    return Intl.message(
      'Sunrise',
      name: 'sunrise',
      desc: '',
      args: [],
    );
  }

  /// `Dhuhr`
  String get dhuhr {
    return Intl.message(
      'Dhuhr',
      name: 'dhuhr',
      desc: '',
      args: [],
    );
  }

  /// `Asr`
  String get asr {
    return Intl.message(
      'Asr',
      name: 'asr',
      desc: '',
      args: [],
    );
  }

  /// `Maghrib`
  String get maghrib {
    return Intl.message(
      'Maghrib',
      name: 'maghrib',
      desc: '',
      args: [],
    );
  }

  /// `Isha`
  String get isha {
    return Intl.message(
      'Isha',
      name: 'isha',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Next Prayer: {prayer} at {time}`
  String nextPrayer(Object prayer, Object time) {
    return Intl.message(
      'Next Prayer: $prayer at $time',
      name: 'nextPrayer',
      desc: '',
      args: [prayer, time],
    );
  }

  /// `Fetching location...`
  String get fetchingLocation {
    return Intl.message(
      'Fetching location...',
      name: 'fetchingLocation',
      desc: '',
      args: [],
    );
  }

  /// `AL-Quran`
  String get alQuranTitle {
    return Intl.message(
      'AL-Quran',
      name: 'alQuranTitle',
      desc: '',
      args: [],
    );
  }

  /// `Read Holy Quran on your daily reminder`
  String get alQuranSubtitle {
    return Intl.message(
      'Read Holy Quran on your daily reminder',
      name: 'alQuranSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Read Now`
  String get readNowButton {
    return Intl.message(
      'Read Now',
      name: 'readNowButton',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching prayer times`
  String get errorFetchingPrayerTimes {
    return Intl.message(
      'Error fetching prayer times',
      name: 'errorFetchingPrayerTimes',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Share App`
  String get shareApp {
    return Intl.message(
      'Share App',
      name: 'shareApp',
      desc: '',
      args: [],
    );
  }

  /// `Rate us`
  String get rateUs {
    return Intl.message(
      'Rate us',
      name: 'rateUs',
      desc: '',
      args: [],
    );
  }

  /// `More Apps`
  String get moreApps {
    return Intl.message(
      'More Apps',
      name: 'moreApps',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message(
      'Settings',
      name: 'settingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade to premium`
  String get upgradeToPremium {
    return Intl.message(
      'Upgrade to premium',
      name: 'upgradeToPremium',
      desc: '',
      args: [],
    );
  }

  /// `All Features Access`
  String get allFeaturesAccess {
    return Intl.message(
      'All Features Access',
      name: 'allFeaturesAccess',
      desc: '',
      args: [],
    );
  }

  /// `Without Ads`
  String get withoutAds {
    return Intl.message(
      'Without Ads',
      name: 'withoutAds',
      desc: '',
      args: [],
    );
  }

  /// `Better UX Experience`
  String get betterUXExperience {
    return Intl.message(
      'Better UX Experience',
      name: 'betterUXExperience',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Premium`
  String get purchasePremium {
    return Intl.message(
      'Purchase Premium',
      name: 'purchasePremium',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Language Selection`
  String get languageSelection {
    return Intl.message(
      'Language Selection',
      name: 'languageSelection',
      desc: '',
      args: [],
    );
  }

  /// `MP3 Quran`
  String get mp3Title {
    return Intl.message(
      'MP3 Quran',
      name: 'mp3Title',
      desc: '',
      args: [],
    );
  }

  /// `Play`
  String get play {
    return Intl.message(
      'Play',
      name: 'play',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get pause {
    return Intl.message(
      'Pause',
      name: 'pause',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous {
    return Intl.message(
      'Previous',
      name: 'previous',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Bookmark Page`
  String get bookmarkPage {
    return Intl.message(
      'Bookmark Page',
      name: 'bookmarkPage',
      desc: '',
      args: [],
    );
  }

  /// `This page is already bookmarked!`
  String get pageAlreadyBookmarked {
    return Intl.message(
      'This page is already bookmarked!',
      name: 'pageAlreadyBookmarked',
      desc: '',
      args: [],
    );
  }

  /// `Page {pageNumber} bookmarked!`
  String pageBookmarked(Object pageNumber) {
    return Intl.message(
      'Page $pageNumber bookmarked!',
      name: 'pageBookmarked',
      desc: '',
      args: [pageNumber],
    );
  }

  /// `Remove Bookmark`
  String get removeBookmarkTitle {
    return Intl.message(
      'Remove Bookmark',
      name: 'removeBookmarkTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this bookmark?`
  String get removeBookmarkContent {
    return Intl.message(
      'Are you sure you want to remove this bookmark?',
      name: 'removeBookmarkContent',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Bookmarks`
  String get bookmarksTitle {
    return Intl.message(
      'Bookmarks',
      name: 'bookmarksTitle',
      desc: '',
      args: [],
    );
  }

  /// `No bookmarks added yet.`
  String get noBookmarks {
    return Intl.message(
      'No bookmarks added yet.',
      name: 'noBookmarks',
      desc: '',
      args: [],
    );
  }

  /// `Page: {pageNumber}`
  String pageNumber(Object pageNumber) {
    return Intl.message(
      'Page: $pageNumber',
      name: 'pageNumber',
      desc: '',
      args: [pageNumber],
    );
  }

  /// `Allah Names`
  String get appBarTitle {
    return Intl.message(
      'Allah Names',
      name: 'appBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `99 Names of Allah`
  String get sectionTitle {
    return Intl.message(
      '99 Names of Allah',
      name: 'sectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Listen and learn Allah names`
  String get sectionSubtitle {
    return Intl.message(
      'Listen and learn Allah names',
      name: 'sectionSubtitle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'ur'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
