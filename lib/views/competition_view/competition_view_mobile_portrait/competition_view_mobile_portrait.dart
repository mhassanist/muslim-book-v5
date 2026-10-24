import 'package:muslim_book/widgets/exit_confirm_dialog.dart';
import 'package:muslim_book/ads/admob_banner.dart';
import 'package:muslim_book/ads/load_ui_with_add.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/home_feature/controllers/home_controller.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/providers/competition_provider.dart';
import 'package:muslim_book/providers/top_provider.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/views/login_pop_up_view/login_pop_up_view.dart';
import 'package:muslim_book/views/scoreboard_views/quiz_scoreboard_view.dart';
import 'package:muslim_book/widgets/app_scaffold_title.dart';
import 'package:muslim_book/widgets/retry_view_widget.dart';
import 'package:muslim_book/widgets/share_dialog.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'competition_mobile_portrait_ui.dart';

class CompetitionViewMobilePortrait extends StatefulWidget {
  @override
  _CompetitionViewMobilePortraitState createState() =>
      _CompetitionViewMobilePortraitState();
}

class _CompetitionViewMobilePortraitState
    extends State<CompetitionViewMobilePortrait> {
  late CompetitionUI ui;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    ui = CompetitionUI(
      _scaffoldKey.currentContext ?? context,
    );
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            content: ExitConfirmDialog(
              title: "المسابقات",
              buttomTitle: "مواصله اللعب",
              exit: go,
            ),
          ),
        )) ??
        false;
  }

  go() {
    Provider.of<UserProvider>(context, listen: false).selectedPage = 2;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return Consumer<CompetitionProvider>(builder: (context, model, __) {
        model.ui = ui;
        ui.sizeConfig = sizeConfig;
        return WillPopScope(
            onWillPop: _onWillPop,
            child: SafeArea(
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Constants.PRIMARY_COLOR,
                  title: AppScaffoldTitleWidget(
                      title: AppLocalizations.of(context)!
                          .translate("competitions")),
                  leading: InkWell(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(start: 10),
                      padding: EdgeInsets.all(5),
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset("assets/icons/iconappbar.svg",
                          color: Colors.white),
                    ),
                    onTap: () {
                      Get.find<HomeController>()
                          .scaffoldKey
                          .currentState!
                          .openDrawer();
                    },
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => _getCompetitionPage()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(Icons.wine_bar),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Get.dialog(ShareDialog());
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(Icons.share),
                        )),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(Icons.settings),
                      ),
                    ),
                    Container(
                      width: 10,
                    )
                  ],
                ),
                body: ConnectivityWidgetWrapper(
                    disableInteraction: true,
                    offlineWidget: RetryViewWidget(
                      text: 'competitions',
                      provider: model,
                      function: () => model.getQuestions(),
                    ),
                    child: getBody(context, model, sizeConfig)),
              ),
            ));
      });
    });
  }

  Widget buildGettingQuestionWidget(
      context, CompetitionProvider provider, SizingInformation sizeConfig) {
    return Container(
      width: double.infinity,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Constants.PRIMARY_COLOR),
        ),
      ),
    );
  }

  Container buildCompetitionWidget(BuildContext context) {
    if (Provider.of<CompetitionProvider>(context).questions.isEmpty) {
      return Container(
        child: Center(
          child: Text("لا توجد اسئلة متاحة لك الان"),
        ),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(top: 10),
      child: ListView(
        padding: EdgeInsets.only(bottom: 10),
        children: <Widget>[
          ui.questionText(),
          ui.questions(),
          ui.answers(),
          ui.continueButton(),
          AdmobBanner(bannerName: BannerName.COMPETITION)
//          ui.faceBookAdsWidget(
//              locator<RemoteConfigService>().underCompetitionAdsId)
        ],
      ),
    );
  }

  Widget buildSignInWidget(BuildContext context, SizingInformation sizeConfig) {
    return LoginPopUpView();
  }

  Widget getBody(
      context, CompetitionProvider model, SizingInformation sizeConfig) {
    if (model.viewState == ViewState.Loading /* add condition */) {
      return buildGettingQuestionWidget(context, model, sizeConfig);
    } else if (model.viewState == ViewState.Idle &&
        Provider.of<CompetitionProvider>(context).questions == null &&
        Provider.of<CompetitionProvider>(context).questions.isEmpty)
      return ui.buildNoMoreQuestions();
    else
      return LoadUiWithAd(mainView: buildCompetitionWidget(context));
  }

  _getCompetitionPage() {
    return ChangeNotifierProxyProvider<UserProvider, TopProvider>(
      create: (_) => TopProvider(null),
      update: (_, user, __) => TopProvider(user),
      child: ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => QuizScoreboard(),
        ),
      ),
    );
  }
}
