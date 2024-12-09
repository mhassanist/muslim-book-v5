// import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:easy_audience_network/easy_audience_network.dart' as ad;
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
  bool isAdLoaded = false;

  late BannerAdListener adListener;
  late BannerAd bannerAd;

  @override
  void initState() {
    super.initState();
    if (!locator<RemoteConfigService>().showFacebookAdsBanner) {
      initializeAdd();
    }
  }

  @override
  void dispose() {
    super.dispose();
    try {
      bannerAd.dispose();
    } catch(e) {
      Get.log('If facebook ads, bannerAd may be did not initialized $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (locator<RemoteConfigService>().showFacebookAdsBanner) {
      return Stack(
        children: [
          ad.BannerAd(
            placementId: AdManager.getBannerAdUnitId(widget.bannerName),
            bannerSize: ad.BannerSize.STANDARD,
            listener: ad.BannerAdListener(
              onClicked: () {
                setState(() {
                  isAdLoaded = true;
                });
                debugPrint("BannerAd Clicked");
              },
              onError: (code, message) {
                setState(() {
                  isAdLoaded = true;
                });
                debugPrint("BannerAd Error: code: $code, message: $message");
              },
              onLoaded: () {
                setState(() {
                  isAdLoaded = true;
                });
                debugPrint("BannerAd Loaded");
              },
              onLoggingImpression: () {
                setState(() {
                  isAdLoaded = true;
                });
                debugPrint("BannerAd Logging Impression");
              },
            ),
            // listener: (result, value) {
            //   setState(() {
            //     isAdLoaded = true;
            //   });
              // switch (result) {
              //   case BannerAdResult.ERROR:
              //     debugPrint("FacebookBannerAd Error: $value");
              //     break;
              //   case BannerAdResult.LOADED:
              //     debugPrint("FacebookBannerAd Loaded: $value");
              //     break;
              //   case BannerAdResult.CLICKED:
              //     debugPrint("FacebookBannerAd Clicked: $value");
              //     break;
              //   case BannerAdResult.LOGGING_IMPRESSION:
              //     debugPrint("FacebookBannerAd Logging Impression: $value");
              //     break;
              // }
            // },
          ),
          if (!isAdLoaded)
            SizedBox(
              height: widget.height ?? 100,
              child: const Center(
                child: Loading(),
              ),
            ),
        ],
      );
    }
    if (isAdLoaded) {
      final AdWidget adWidget = AdWidget(ad: bannerAd);
      return SizedBox(height: widget.height ?? 250, child: adWidget);
    } else {
      loadBanner();
      return SizedBox(
        height: widget.height ?? 250,
        child: const Center(
          child: Loading(),
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
          Get.log('Ad loaded.');
        }
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        Get.log('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => Get.log('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => Get.log('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => Get.log('Ad impression.'),
    );
  }

  void loadBanner() {
    bannerAd = BannerAd(
      adUnitId: AdManager.getBannerAdUnitId(widget.bannerName),
      size: AdSize.getInlineAdaptiveBannerAdSize(
          widget.width != null
              ? widget.width!.floor()
              : MediaQuery.of(context).size.width.floor(),
          widget.height != null ? widget.height!.floor() : 250),
      request: const AdRequest(),
      listener: adListener,
    );
    bannerAd.load();
  }
}
