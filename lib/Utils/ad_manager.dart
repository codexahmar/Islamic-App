import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static RewardedAd? _rewardedAd;
  static InterstitialAd? _interstitialAd;
  static bool _isAdLoaded = false;
  static DateTime? _lastAdShown;
  static const Duration _minimumDurationBetweenAds = Duration(minutes: 2);

  // Test ad unit IDs - Replace with your actual ad unit IDs
  static final String rewardedAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  static final String interstitialAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  static void loadRandomAd() {
    // Dispose existing ads first
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd = null;
    _interstitialAd = null;
    _isAdLoaded = false;

    bool showRewardedAd = Random().nextBool();
    debugPrint('Loading ${showRewardedAd ? 'Rewarded' : 'Interstitial'} Ad');

    if (showRewardedAd) {
      loadRewardedAd();
    } else {
      loadInterstitialAd();
    }
  }

  static void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('Rewarded ad loaded.');
          _rewardedAd = ad;
          _isAdLoaded = true;

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isAdLoaded = false;
              loadRandomAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isAdLoaded = false;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: $error');
          loadInterstitialAd();
        },
      ),
    );
  }

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('Interstitial ad loaded.');
          _interstitialAd = ad;
          _isAdLoaded = true;

          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isAdLoaded = false;
              loadRandomAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isAdLoaded = false;
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          loadRewardedAd();
        },
      ),
    );
  }

  static void showAdIfAvailable() {
    if (!_isAdLoaded) return;

    // Check if enough time has passed since last ad
    if (_lastAdShown != null) {
      final timeSinceLastAd = DateTime.now().difference(_lastAdShown!);
      if (timeSinceLastAd < _minimumDurationBetweenAds) {
        debugPrint('Not showing ad: Too soon since last ad');
        return;
      }
    }

    if (_rewardedAd != null) {
      _lastAdShown = DateTime.now();
      _rewardedAd!.show(onUserEarnedReward: (_, reward) {});
    } else if (_interstitialAd != null) {
      _lastAdShown = DateTime.now();
      _interstitialAd!.show();
    }
  }
}
