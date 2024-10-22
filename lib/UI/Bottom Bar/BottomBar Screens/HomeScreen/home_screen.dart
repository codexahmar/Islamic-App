import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/UI/Screens/prayer_screen.dart';
import 'package:quran_app/generated/l10n.dart';
import 'package:quran_app/Utils/location_util.dart';

import '../../../../Utils/prayer_times_manager.dart';
import '../../../Screens/40_rabana.dart';
import '../../../Screens/Allah_names.dart';
import '../../../Screens/ahadees.dart';
import '../../../Screens/bookmark_screen.dart';
import '../../../Screens/daily_azkar.dart';
import '../../../Screens/extra.dart';
import '../../../Screens/juzz_list.dart';
import '../../../Screens/mp3_Screen.dart';
import '../../../Screens/nearby_masjid.dart';
import '../../../Screens/six_kalima_screen.dart';
import '../../../Screens/surah_list.dart';
import '../../../Screens/tasbeeh_counter.dart';
import '../../../Widgets/al_quran_widget.dart';
import '../../../Widgets/feature_item_widget.dart';
import '../../../Widgets/icon_container_widget.dart';
import '../../../Widgets/prayer_info_widget.dart';
import '../../../Widgets/location_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String, dynamic>> featureItems;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    loadAd();
  }

  Future<void> _initializeData() async {
    await _fetchPrayerTimes();
    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _fetchPrayerTimes() async {
    if (await LocationUtil.checkLocationPermission()) {
      await Provider.of<PrayerTimeManager>(context, listen: false)
          .fetchPrayerTimes(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permission is required for this feature.')),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeFeatureItems();
  }

  void _initializeFeatureItems() {
    final localization = S.of(context); // Access localization here
    featureItems = [
      {
        "imagePath": "assets/images/tasbeeh_icon.png",
        "label": localization.tasbeehCounter,
        "screen": TasbeehCounter(),
      },
      {
        "imagePath": "assets/images/prayer_icon.png",
        "label": localization.dailyAzkar,
        "screen": DailyAzkar(),
      },
      {
        "imagePath": "assets/images/rabana_icon.png",
        "label": localization.fortyRabana,
        "screen": FortyRabana(),
      },
      {
        "imagePath": "assets/images/prayer_timing_icon.png",
        "label": localization.prayerTiming,
        "screen": PrayerScreen(),
      },
      {
        "imagePath": "assets/images/masjid_icon.png",
        "label": localization.nearbyMasjid,
        "screen": NearbyMasjidsScreen(),
      },
      {
        "imagePath": "assets/images/six_kalma_icon.png",
        "label": localization.sixKalima,
        "screen": SixKalimaScreen(),
      },
      {
        "imagePath": "assets/images/ahadees_icon.png",
        "label": localization.ahadees,
        "screen": Ahadees(),
      },
      {
        "imagePath": "assets/images/99_names.png",
        "label": localization.ninetyNineNames,
        "screen": AllahNames(),
      },
      {
        "imagePath": "assets/images/masjid_icon.png",
        "label": localization.extraFeatures,
        "screen": ExtraFeatures(),
      },
    ];
  }

  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  /// Loads a banner ad.
  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final prayerTimeManager = Provider.of<PrayerTimeManager>(context);
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog
        final shouldClose = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white, // Background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            title: Text(
              'Confirm Exit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Title color
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10.0), // Padding for content
              child: Text(
                'Are you sure you want to close the app?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54, // Content color
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // No
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600, // Button text style
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Yes
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600, // Button text style
                  ),
                ),
              ),
            ],
          ),
        );
        return shouldClose ?? false; // Close the app if user confirms
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              S.of(context).appTitle,
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: LocationWidget(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrayerInfoWidget(
                  prayerName: prayerTimeManager.prayerName,
                  prayerTime: prayerTimeManager.prayerTime,
                  nextPrayer: prayerTimeManager.nextPrayer,
                ),
                SizedBox(height: 15),
                (_isLoaded)
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: SafeArea(
                          child: SizedBox(
                            width: _bannerAd!.size.width.toDouble(),
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(height: 15),
                AlQuranWidget(),
                SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurahListScreen(),
                            ),
                          );
                        },
                        child: IconContainerWidget(
                          imagePath: "assets/images/surah_icon.png",
                          label: S.of(context).surah,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JuzzListScreen(),
                            ),
                          );
                        },
                        child: IconContainerWidget(
                          imagePath: "assets/images/juzz_icon.png",
                          label: S.of(context).juzz,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Mp3Screen(),
                            ),
                          );
                        },
                        child: IconContainerWidget(
                          imagePath: "assets/images/mp3_icon.png",
                          label: S.of(context).mp3,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookmarkScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: IconContainerWidget(
                            imagePath: "assets/images/bookmark_icon.png",
                            label: S.of(context).bookmark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  S.of(context).moreFeatures,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: featureItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                featureItems[index]["screen"] as Widget,
                          ),
                        );
                      },
                      child: FeatureItemWidget(
                          imagePath: featureItems[index]["imagePath"]!,
                          label: featureItems[index]["label"]!,
                          color: featureItems[index]["color"]),
                    );
                  },
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
