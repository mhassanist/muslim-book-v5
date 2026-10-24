import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_book/ads/ad_manager.dart';
import 'package:muslim_book/ads/ad_placeholder.dart';
import 'package:muslim_book/ads/ads_service.dart';
import 'package:muslim_book/models/banner_names_enum.dart';

/// Inline adaptive banner. Loads once consent allows it, shows [AdPlaceholder]
/// while loading, then resizes to the height the SDK actually returned.
/// https://developers.google.com/admob/flutter/banner/inline-adaptive
class AdmobBanner extends StatefulWidget {
  final BannerName bannerName;
  final double? width;

  /// Maximum height of the ad (and the placeholder height while loading).
  final double? height;
  const AdmobBanner({
    super.key,
    required this.bannerName,
    this.width,
    this.height,
  });

  @override
  State<AdmobBanner> createState() => _AdmobBannerState();
}

class _AdmobBannerState extends State<AdmobBanner> {
  static const int _maxRetries = 3;

  BannerAd? bannerAd;
  AdSize? _loadedSize;
  bool hasFailed = false;
  bool _loadStarted = false;
  int _retryAttempt = 0;
  Timer? _retryTimer;

  double get _maxHeight => widget.height ?? 250;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load once; MediaQuery is needed for the ad width, so it can't be done in initState
    if (!_loadStarted) {
      _loadStarted = true;
      _loadWhenAllowed();
    }
  }

  Future<void> _loadWhenAllowed() async {
    final allowed = await AdsService.canRequestAds;
    if (!mounted) return;
    if (allowed) {
      loadBanner();
    } else {
      setState(() => hasFailed = true);
    }
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (hasFailed) {
      return const SizedBox.shrink();
    }
    final loadedSize = _loadedSize;
    // Fade from the animated placeholder into the ad once it arrives
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: loadedSize != null && bannerAd != null
          ? SizedBox(
              key: const ValueKey('ad'),
              width: loadedSize.width.toDouble(),
              height: loadedSize.height.toDouble(),
              child: AdWidget(ad: bannerAd!),
            )
          : AdPlaceholder(key: const ValueKey('placeholder'), height: _maxHeight),
    );
  }

  void loadBanner() {
    final width = widget.width != null
        ? widget.width!.floor()
        : MediaQuery.of(context).size.width.floor();
    bannerAd = BannerAd(
      adUnitId: AdManager.getBannerAdUnitId(widget.bannerName),
      size: AdSize.getInlineAdaptiveBannerAdSize(width, _maxHeight.floor()),
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) async {
          if (!mounted) {
            ad.dispose();
            return;
          }
          // The returned height can differ from the requested maximum
          final size = await (ad as BannerAd).getPlatformAdSize();
          if (!mounted || size == null) return;
          setState(() => _loadedSize = size);
          Get.log('Ad loaded.');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          bannerAd = null;
          Get.log('Ad failed to load: $error');
          if (mounted) _scheduleRetry();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => Get.log('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => Get.log('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => Get.log('Ad impression.'),
      ),
    )..load();
  }

  /// Retries with exponential backoff (2s, 4s, 8s), then collapses the slot
  void _scheduleRetry() {
    if (_retryAttempt >= _maxRetries) {
      setState(() {
        hasFailed = true;
      });
      return;
    }
    final delay = Duration(seconds: 2 << _retryAttempt);
    _retryAttempt++;
    _retryTimer = Timer(delay, () {
      if (mounted) loadBanner();
    });
  }
}
