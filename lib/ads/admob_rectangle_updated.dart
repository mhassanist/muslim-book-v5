import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_book/ads/ad_manager.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/loading_pkg/indicator/ball_beat_indicator.dart';
import 'package:muslim_book/widgets/loading_pkg/loading.dart';

class AdmobRectangleUpdated extends StatefulWidget {
  final BannerName bannerName;
  const AdmobRectangleUpdated({
    super.key,
    required this.bannerName,
  });

  @override
  State<AdmobRectangleUpdated> createState() => _AdmobRectangleUpdatedState();
}

class _AdmobRectangleUpdatedState extends State<AdmobRectangleUpdated> {
  bool isAdLoaded = false;

  late BannerAdListener adListener;
  late BannerAd myBanner;

  @override
  void initState() {
    super.initState();
    initializeAdd();
  }

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isAdLoaded) {
      final AdWidget adWidget = AdWidget(ad: myBanner);
      final Container adContainer = Container(
        alignment: Alignment.center,
        child: adWidget,
        width: myBanner.size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
      );
      return adContainer;
    } else {
      loadBanner();
      return Container(
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
        setState(() {
          isAdLoaded = true;
        });
        print('Ad loaded.');
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
    myBanner = BannerAd(
      adUnitId: AdManager.getAdUnitId(this.widget.bannerName),
      size: AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
          MediaQuery.of(context).size.width.floor()),
      request: AdRequest(),
      listener: adListener,
    );
    myBanner.load();
  }
}
