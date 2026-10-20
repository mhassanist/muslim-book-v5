// import 'package:facebook_audience_network/ad/ad_banner.dart';
// import 'package:easy_audience_network/easy_audience_network.dart' as ad;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_book/ads/ad_manager.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/network_utils/remote_config.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/widgets/loading_pkg/loading.dart';

class AdmobBanner extends StatefulWidget {
  final BannerName bannerName;
  final double? width;
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
  bool isAdLoaded = false;
  bool hasFailed = false;
  int _retryAttempt = 0;
  Timer? _retryTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load once; MediaQuery is needed for the ad width, so it can't be done in initState
    if (bannerAd == null &&
        !hasFailed &&
        !locator<RemoteConfigService>().showFacebookAdsBanner) {
      loadBanner();
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
    // if (locator<RemoteConfigService>().showFacebookAdsBanner) {
    //   return Stack(
    //     children: [
    //       ad.BannerAd(
    //         placementId: AdManager.getBannerAdUnitId(widget.bannerName),
    //         bannerSize: ad.BannerSize.STANDARD,
    //         listener: ad.BannerAdListener(
    //           onClicked: () {
    //             setState(() {
    //               isAdLoaded = true;
    //             });
    //             debugPrint("BannerAd Clicked");
    //           },
    //           onError: (code, message) {
    //             setState(() {
    //               isAdLoaded = true;
    //             });
    //             debugPrint("BannerAd Error: code: $code, message: $message");
    //           },
    //           onLoaded: () {
    //             setState(() {
    //               isAdLoaded = true;
    //             });
    //             debugPrint("BannerAd Loaded");
    //           },
    //           onLoggingImpression: () {
    //             setState(() {
    //               isAdLoaded = true;
    //             });
    //             debugPrint("BannerAd Logging Impression");
    //           },
    //         ),
    //       ),
    //       if (!isAdLoaded)
    //         SizedBox(
    //           height: widget.height ?? 100,
    //           child: const Center(
    //             child: Loading(),
    //           ),
    //         ),
    //     ],
    //   );
    // }
    if (hasFailed || locator<RemoteConfigService>().showFacebookAdsBanner) {
      return const SizedBox.shrink();
    }
    if (isAdLoaded && bannerAd != null) {
      return SizedBox(
        height: widget.height ?? 250,
        child: AdWidget(ad: bannerAd!),
      );
    }
    return SizedBox(
      height: widget.height ?? 250,
      child: const Center(
        child: Loading(),
      ),
    );
  }

  void loadBanner() {
    final width = widget.width != null
        ? widget.width!.floor()
        : MediaQuery.of(context).size.width.floor();
    bannerAd = BannerAd(
      adUnitId: AdManager.getBannerAdUnitId(widget.bannerName),
      size: AdSize.getInlineAdaptiveBannerAdSize(
          width, widget.height != null ? widget.height!.floor() : 250),
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            isAdLoaded = true;
          });
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
