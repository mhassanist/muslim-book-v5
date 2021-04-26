import 'package:audio_service/audio_service.dart';
import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/home_feature/controllers/home_controller.dart';
import 'package:base_app/network_utils/remote_config.dart';
import 'package:base_app/quran/provider/quran_provider.dart';
import 'package:base_app/quran/views/quran_loading_view.dart';
import 'package:base_app/quran/views/quran_settings_drawer.dart';
import 'package:base_app/quran/views/suras_view.dart';
import 'package:base_app/quran/widgets/retry_view_widget.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/widgets/share_dialog.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuranView extends StatefulWidget {
  @override
  _QuranViewState createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        allowFontScaling: true,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height);
    return AudioServiceWidget(
      child: Scaffold(
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
                      "المصحف الشريف",
                      style: GoogleFonts.almarai(
                        fontSize: ScreenUtil().setSp(25),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      "جاري تحميل المصحف",
                      style: GoogleFonts.almarai(
                        fontSize: ScreenUtil().setSp(25),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Get
                  .find<HomeController>()
                  .scaffoldKey.currentState.openDrawer();
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
      ),
    );
  }

  Widget getBody() {
    if (Provider.of<QuranProvider>(context).viewState == ViewState.Loading) {
      return QuranLoadingView();
    } else if (Provider.of<QuranProvider>(context).allSuras != null &&
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
  void deactivate() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: locator<RemoteConfigService>().azanPopUpAdId,
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd();
      },
    );
    super.deactivate();
  }
}
