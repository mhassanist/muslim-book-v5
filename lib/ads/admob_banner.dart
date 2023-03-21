import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_book/ads/ad_manager.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/loading_pkg/indicator/ball_beat_indicator.dart';
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
  bool isAdLoaded = false;

  late BannerAdListener adListener;
  late BannerAd bannerAd;

  @override
  void initState() {
    super.initState();
    initializeAdd();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isAdLoaded) {
      final AdWidget adWidget = AdWidget(ad: bannerAd);
      return SizedBox(height: widget.height ?? 250, child: adWidget);
    } else {
      loadBanner();
      return SizedBox(
        height: widget.height ?? 250,
        child: Center(
          child: Loading(
            indicator: BallBeatIndicator(),
            size: 70.0,
            color: Constants.PRIMARY_DARK_COLOR,
          ),
        ),
      );
    }
  }

  void initializeAdd() {
    adListener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        if (mounted) {
          setState(() {
            isAdLoaded = true;
          });
          print('Ad loaded.');
        }
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );
  }

  void loadBanner() {
    bannerAd = BannerAd(
      adUnitId: AdManager.getBannerAdUnitId(this.widget.bannerName),
      size: AdSize.getInlineAdaptiveBannerAdSize(
          widget.width != null
              ? widget.width!.floor()
              : MediaQuery.of(context).size.width.floor(),
          widget.height != null ? widget.height!.floor() : 250),
      request: AdRequest(),
      listener: adListener,
    );
    bannerAd.load();
  }
}
