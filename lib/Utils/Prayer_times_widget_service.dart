import 'package:home_widget/home_widget.dart';

class PrayerTimesWidgetService {
  Future<void> updatePrayerTimes(String prayerName, String prayerTime) async {
    await HomeWidget.saveWidgetData<String>('prayer_name', prayerName);
    await HomeWidget.saveWidgetData<String>('prayer_time', prayerTime);
    await HomeWidget.updateWidget(name: 'PrayerTimesWidgetProvider');
  }
}
