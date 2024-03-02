import 'package:muslim_book/ads/ad_manager.dart';
import 'package:muslim_book/ads/admob_interstitial.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/home_feature/controllers/home_controller.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/network_utils/remote_config.dart';
import 'package:muslim_book/quran/provider/quran_provider.dart';
import 'package:muslim_book/quran/views/quran_loading_view.dart';
import 'package:muslim_book/quran/views/quran_settings_drawer.dart';
import 'package:muslim_book/quran/views/suras_view.dart';
import 'package:muslim_book/quran/widgets/retry_view_widget.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/widgets/share_dialog.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuranListeningView extends StatefulWidget {
  @override
  _QuranListeningViewState createState() => _QuranListeningViewState();
}

class _QuranListeningViewState extends State<QuranListeningView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
      // allowFontScaling: true,
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle:
            Provider.of<QuranProvider>(context).viewState != ViewState.Loading
                ? true
                : false,
        title:
            Provider.of<QuranProvider>(context).viewState != ViewState.Loading
                ? Text(
                    AppLocalizations.of(context)!.translate("moshaf"),
                    style: GoogleFonts.almarai(
                      fontSize: ScreenUtil().setSp(25),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    AppLocalizations.of(context)!.translate("Loading_moshaf"),
                    style: GoogleFonts.almarai(
                      fontSize: ScreenUtil().setSp(25),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        leading: InkWell(
          child: Container(
            margin: EdgeInsetsDirectional.only(start: 10),
            padding: EdgeInsets.all(5),
            height: 20,
            width: 20,
            child: SvgPicture.asset("assets/icons/iconappbar.svg",
                color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Get.find<HomeController>().scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: <Widget>[
          InkWell(
              onTap: () {
                Get.dialog(ShareDialog());
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.share),
              )),
          Provider.of<QuranProvider>(context).viewState != ViewState.Loading
              ? IconButton(
                  icon: Icon(Icons.settings),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    await Get.bottomSheet(QuranSettingsDrawer());
                    setState(() {});
                  })
              : SizedBox(),
          Container(
            width: 10,
          )
        ],
        backgroundColor:
            Provider.of<QuranProvider>(context).viewState != ViewState.Loading
                ? Colors.white
                : Theme.of(context).primaryColor,
      ),
      body: getBody(),
      backgroundColor: Colors.white,
    );
  }

  Widget getBody() {
    if (Provider.of<QuranProvider>(context).viewState == ViewState.Loading) {
      return QuranLoadingView();
    } else if (Provider.of<QuranProvider>(context).allSuras.isNotEmpty &&
        Provider.of<QuranProvider>(context).allSuras.length == 114) {
      return SurasView();
    } else {
      return RetryViewWidget(
        function: () {
          Provider.of<QuranProvider>(context, listen: false)
              .checkIsQuranDownloaded();
        },
        provider: Provider.of<QuranProvider>(context),
        text: "retry_quran",
      );
    }
  }

  @override
  void dispose() {
    if (locator<RemoteConfigService>().showFacebookInterstitial) {
      FacebookInterstitialAd.loadInterstitialAd(
        // placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
        placementId: locator<RemoteConfigService>().azanPopUpAdId,
        listener: (result, value) {
          if (result == InterstitialAdResult.LOADED) {
            FacebookInterstitialAd.showInterstitialAd();
          }
          if (result == InterstitialAdResult.ERROR) {
          }
        },
      );
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
  //         if (result == InterstitialAdResult.LOADED) {
  //           FacebookInterstitialAd.showInterstitialAd();
  //         }
  //         if (result == InterstitialAdResult.ERROR) {
  //         }
  //       },
  //     );
  //   } else {
  //     AdmobInterstitial interstitialAd = AdmobInterstitial();
  //     interstitialAd.createInterstitialAd();
  //   }
  //   super.deactivate();
  // }
}
