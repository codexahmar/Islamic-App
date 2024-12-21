import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/UI/Screens/chat_screen.dart';
import 'package:quran_app/UI/Screens/prayer_screen.dart';
import 'package:quran_app/UI/Widgets/searchbar.dart';
import 'package:quran_app/UI/constants/constants.dart';
import 'package:quran_app/generated/l10n.dart';
import 'package:quran_app/Utils/location_util.dart';

import '../../../../Services/chat_service.dart';
import '../../../../Utils/ad_manager.dart';
import '../../../../Utils/ad_state_mixin.dart';
import '../../../../Utils/navigation_helper.dart';
import '../../../../Utils/prayer_times_manager.dart';
import '../../../../services/rating_service.dart';
import '../../../Screens/40_rabana.dart';
import '../../../Screens/Allah_names.dart';
import '../../../Screens/ahadees.dart';
import '../../../Screens/bookmark_screen.dart';
import '../../../Screens/daily_azkar.dart';

import '../../../Screens/juzz_list.dart';
import '../../../Screens/mp3_Screen.dart';

// import '../../../Screens/nearby_masjid.dart';
import '../../../Screens/six_kalima_screen.dart';
import '../../../Screens/surah_list.dart';
import '../../../Screens/tasbeeh_counter.dart';
// import '../../../Widgets/al_quran_widget.dart';
import '../../../Widgets/feature_item_widget.dart';
import '../../../Widgets/icon_container_widget.dart';
import '../../../Widgets/prayer_info_widget.dart';
import '../../../Widgets/location_widget.dart';
import '../../../Widgets/rating_dialog.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AdStateMixin<HomeScreen> {
  late ChatService chatService;
  late List<Map<String, dynamic>> featureItems;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    _initializeData();
    loadAd();
    _initializeRating();
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

  Future<void> _initializeRating() async {
    await RatingService.initializeFirstOpen();
    // Add a delay before checking rating
    Future.delayed(Duration(minutes: 5), () {
      if (mounted) {
        _checkRating();
      }
    });
  }

  Future<void> _checkRating() async {
    if (await RatingService.shouldShowRating()) {
      await RatingService.updateLastPromptDate();
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => const AppRatingDialog(),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeFeatureItems();
  }

  void _initializeFeatureItems() {
    final localization = S.of(context);
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
      // {
      //   "imagePath": "assets/images/masjid_icon.png",
      //   "label": localization.nearbyMasjid,
      //   "screen": NearbyMasjidsScreen(),
      // },
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
        "label": localization.islamicChatbot,
        "screen": ChatScreen(),
      },
    ];
  }

  BannerAd? _bannerAd;
  bool _isLoaded = false;

// Real Test Ad unit for Banner Ad
  // final adUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-6315848158314441/3815576838'
  //     : 'ca-app-pub-3940256099942544/2934735716';

// Test Ad unit for Banner Ad
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/6300978111';

  // Loads a banner ad.
  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');

          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    // Show ad when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdManager.showAdIfAvailable();
    });

    if (!_isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final prayerTimeManager = Provider.of<PrayerTimeManager>(context);
    return WillPopScope(
      onWillPop: () async {
        final hasRated = await RatingService.hasUserRated();
        if (!hasRated) {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => const AppRatingDialog(),
          );
          if (shouldExit == null || !shouldExit) {
            return false;
          }
        }

        final shouldClose = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/app_logo.png',
                  width: 80,
                  height: 80,
                ),
                SizedBox(height: 16),
                Text(
                  "Are you sure you want to quit?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );

        return shouldClose ?? false;
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
                  fontSize: 20, fontWeight: FontWeight.w700),
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
                // SearchBarComponent(),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchBarScreen()),
                  ),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Image.asset(
                            "assets/images/ai-search.png",
                            color: primaryColor,
                            height: 25,
                          ),
                          onPressed: null, // Remove navigation redundancy
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SearchBarScreen()),
                            ),
                            child: Text(
                              "Ask anything",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'Islamic ',
                              style: TextStyle(
                                color: primaryColor,
                                fontFamily: 'NotoSans',
                                fontWeight: FontWeight.w600,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'AI',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Image.asset(
                            "assets/images/mic.png",
                            color: primaryColor,
                            height: 25,
                          ),
                          onPressed: null, // Remove navigation redundancy
                        ),
                      ],
                    ),
                  ),
                ),

                // AlQuranWidget(),
                SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          NavigationHelper.pushScreen(
                            context,
                            SurahListScreen(),
                          );
                        },
                        child: IconContainerWidget(
                          imagePath: "assets/images/Vector.png",
                          label: S.of(context).surah,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          NavigationHelper.pushScreen(
                            context,
                            JuzzListScreen(),
                          );
                        },
                        child: IconContainerWidget(
                          imagePath: "assets/images/juzz_icon.png",
                          label: S.of(context).juzz,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          NavigationHelper.pushScreen(
                            context,
                            Mp3Screen(),
                          );
                        },
                        child: IconContainerWidget(
                          imagePath: "assets/images/mp3_icon.png",
                          label: S.of(context).mp3,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          NavigationHelper.pushScreen(
                            context,
                            BookmarkScreen(),
                          );
                        },
                        child: IconContainerWidget(
                          imagePath: "assets/images/bookmark_icon.png",
                          label: S.of(context).saved,
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
                        NavigationHelper.pushScreen(
                          context,
                          featureItems[index]["screen"] as Widget,
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     NavigationHelper.pushScreen(context, ChatScreen());
        //   },
        //   backgroundColor: primaryColor,
        //   child: Icon(Icons.chat),
        // ),
      ),
    );
  }
}
