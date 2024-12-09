import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:muslim_book/ads/admob_banner.dart';
import 'package:muslim_book/ads/admob_interstitial.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/network_utils/remote_config.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:muslim_book/widgets/app_scaffold_title.dart';
import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'islamic_offline/islamics_offline_screen.dart';
import 'islamics_screen.dart';

class IslamicsView extends StatefulWidget {
  const IslamicsView({super.key});

  @override
  State<IslamicsView> createState() => _IslamicsViewState();
}

class _IslamicsViewState extends State<IslamicsView> {
  bool isInternetConnected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await InternetConnectionChecker().hasConnection.then((value) {
        if (value == true) {
          setState(() {
            isInternetConnected = true;
          });
        } else {
          setState(() {
            isInternetConnected = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, SizingInformation sizeConfig) {
      return AppScaffold(
        title: AppScaffoldTitleWidget(
            title: AppLocalizations.of(context)!.translate("more")),
        centerTitle: true,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              IslamicsOfflineScreen(),
              AdmobBanner(bannerName: BannerName.AZKAR),
              isInternetConnected == true ? IslamicsScreen(mounted: mounted) : Container(),
              isInternetConnected == true
                  ? AdmobBanner(bannerName: BannerName.AZKAR)
                  : Container(),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    if (locator<RemoteConfigService>().showFacebookInterstitial) {
      final interstitialAd = InterstitialAd(locator<RemoteConfigService>().azanPopUpAdId);
      interstitialAd.listener = InterstitialAdListener(
        onLoaded: () {
          interstitialAd.show();
        },
        onDismissed: () {
          interstitialAd.destroy();
          debugPrint('Interstitial dismissed');
        },
      );
      interstitialAd.load();


      // ad.InterstitialAd.loadInterstitialAd(
      //   // placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
      //   placementId: locator<RemoteConfigService>().azanPopUpAdId,
      //   listener: (result, value) {
      //     if (result == ad.InterstitialAdResult.LOADED) {
      //       ad.InterstitialAd.showInterstitialAd();
      //     }
      //   },
      // );
    } else {
      AdmobInterstitial interstitialAd = AdmobInterstitial();
      interstitialAd.createInterstitialAd();
    }
    super.dispose();
  }
  // @override
  // void deactivate() {
  //   if (locator<RemoteConfigService>().showFacebookInterstitial) {
  //     FacebookInterstitialAd.loadInterstitialAd(
  //       // placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
  //       placementId: locator<RemoteConfigService>().azanPopUpAdId,
  //       listener: (result, value) {
  //         if (result == InterstitialAdResult.LOADED)
  //           FacebookInterstitialAd.showInterstitialAd();
  //       },
  //     );
  //   } else {
  //     AdmobInterstitial interstitialAd = AdmobInterstitial();
  //     interstitialAd.createInterstitialAd();
  //   }
  //
  //   super.deactivate();
  // }
}
