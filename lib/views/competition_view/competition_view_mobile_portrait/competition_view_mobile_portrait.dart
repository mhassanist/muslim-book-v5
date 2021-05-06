import 'package:base_app/ads/add_widget_edit.dart';
import 'package:base_app/ads/admob_rectangle.dart';
import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/home_feature/controllers/home_controller.dart';
import 'package:base_app/models/banner_names_enum.dart';
import 'package:base_app/providers/competition_provider.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/views/login_pop_up_view/login_pop_up_view.dart';
import 'package:base_app/widgets/retry_view_widget.dart';
import 'package:base_app/widgets/share_dialog.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
  CompetitionUI ui;
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
            content: AddWidgetEdit(
              title: "المسابقات",
              bannerName: BannerName.TheMiddleOfTheCompetition,
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

        child:
          SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Get.find<HomeController>()
                      .scaffoldKey.currentState.openDrawer();
                },
              ),
              actions: [
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

  Widget buildGettingQuestionWidget(context, CompetitionProvider provider,
      SizingInformation sizeConfig) {
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
    if (Provider
        .of<CompetitionProvider>(context)
        .questions == null ||
        Provider
            .of<CompetitionProvider>(context)
            .questions
            .isEmpty) {
      return Container();
    }
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      padding: EdgeInsets.only(top: kToolbarHeight),
      child: ListView(
          padding: EdgeInsets.only(bottom: 20),
          children: <Widget>[
          ui.questionText(),
      ui.questions(),
      ui.answers(),
      ui.continueButton(),
      AdMobRectangle(BannerName.COMPETITION)
//          ui.faceBookAdsWidget(
//              locator<RemoteConfigService>().underCompetitionAdsId)
      ],
    ),);
  }

  Widget buildSignInWidget(BuildContext context, SizingInformation sizeConfig) {
    return LoginPopUpView();
  }

  Widget getBody(context, CompetitionProvider model,
      SizingInformation sizeConfig) {
    if (model.viewState == ViewState.Loading /* add condition */) {
      return buildGettingQuestionWidget(context, model, sizeConfig);
    } else if (model.viewState == ViewState.Idle &&  Provider
        .of<CompetitionProvider>(context)
        .questions  == null &&
        Provider
            .of<CompetitionProvider>(context)
            .questions
            .isEmpty)
      return ui.buildNoMoreQuestions();
    else
      return buildCompetitionWidget(context);
  }
}