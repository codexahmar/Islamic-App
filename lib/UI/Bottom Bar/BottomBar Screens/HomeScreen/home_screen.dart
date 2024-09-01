import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/UI/Screens/prayer_screen.dart';
import 'package:quran_app/generated/l10n.dart';
import 'package:quran_app/Utils/location_util.dart'; // Import the utility

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

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // Check for location permission and fetch prayer times
      if (await LocationUtil.checkLocationPermission()) {
        Provider.of<PrayerTimeManager>(context, listen: false)
            .fetchPrayerTimes(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission is required for this feature.'),
          ),
        );
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final prayerTimeManager = Provider.of<PrayerTimeManager>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            S.of(context).appTitle,
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
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
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
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
              AlQuranWidget(),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconContainerWidget(
                    imagePath: "assets/images/surah_icon.png",
                    label: S.of(context).surah,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurahListScreen(),
                        ),
                      );
                    },
                  ),
                  IconContainerWidget(
                    imagePath: "assets/images/juzz_icon.png",
                    label: S.of(context).juzz,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JuzzListScreen(),
                        ),
                      );
                    },
                  ),
                  IconContainerWidget(
                    imagePath: "assets/images/mp3_icon.png",
                    label: S.of(context).mp3,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Mp3Screen(),
                        ),
                      );
                    },
                  ),
                  IconContainerWidget(
                    imagePath: "assets/images/bookmark_icon.png",
                    label: S.of(context).bookmark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookmarkScreen(),
                        ),
                      );
                    },
                  ),
                ],
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
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return FeatureItemWidget(
                      imagePath: featureItems[index]["imagePath"]!,
                      label: featureItems[index]["label"]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                featureItems[index]["screen"] as Widget,
                          ),
                        );
                      },
                      color: featureItems[index]["color"]);
                },
              ),
              SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
