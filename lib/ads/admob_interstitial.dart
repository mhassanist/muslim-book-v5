import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_book/ads/ad_manager.dart';
import 'package:muslim_book/ads/ads_service.dart';
import 'package:muslim_book/models/banner_names_enum.dart';

/// Keeps one interstitial preloaded and shows it only at natural transition
/// points, following AdMob's interstitial policy:
/// - never shown "after load" (it is ready before the transition happens),
/// - never on app launch or exit,
/// - frequency capped.
/// https://support.google.com/admob/answer/6201362
class AdmobInterstitial {
  AdmobInterstitial._();

  static final AdmobInterstitial instance = AdmobInterstitial._();

  static const Duration _minInterval = Duration(minutes: 3);
  static const int _maxLoadAttempts = 3;

  InterstitialAd? _ad;
  bool _isLoading = false;
  int _loadAttempts = 0;
  DateTime? _lastShownAt;

  Future<void> preload() async {
    if (_ad != null || _isLoading) return;
    if (!await AdsService.canRequestAds) return;
    _isLoading = true;
    InterstitialAd.load(
      adUnitId: AdManager.getInterstitialAdUnitId(BannerName.INTERSTITIAL),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _isLoading = false;
          _loadAttempts = 0;
          _ad = ad..setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoading = false;
          _loadAttempts++;
          debugPrint('Interstitial failed to load: $error');
          if (_loadAttempts < _maxLoadAttempts) {
            Timer(Duration(seconds: 5 << _loadAttempts), preload);
          }
        },
      ),
    );
  }

  /// Call at a natural transition point (e.g. leaving a section). Shows the
  /// preloaded ad if one is ready and the frequency cap allows it; otherwise
  /// does nothing and makes sure one is loading for next time.
  void showIfReady() {
    final ad = _ad;
    if (ad == null) {
      preload();
      return;
    }
    final lastShownAt = _lastShownAt;
    if (lastShownAt != null &&
        DateTime.now().difference(lastShownAt) < _minInterval) {
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        preload();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('Interstitial failed to show: $error');
        ad.dispose();
        preload();
      },
    );
    _ad = null;
    _lastShownAt = DateTime.now();
    _loadAttempts = 0;
    ad.show();
  }
}
