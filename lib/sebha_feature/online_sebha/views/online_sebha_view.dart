import 'package:base_app/ads/add_widget_edit.dart';
import 'package:base_app/ads/load_ui_with_add.dart';
import 'package:base_app/models/banner_names_enum.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/sebha_feature/online_sebha/controllers/online_sebha_controller.dart';
import 'package:base_app/sebha_feature/online_sebha/models/tasabeeh_model.dart';
import 'package:base_app/sebha_feature/views/new_tasbeeh_view.dart';
import 'package:base_app/views/login_pop_up_view/login_pop_up_view.dart';
import 'package:base_app/views/myProfile_view/myProfile_view.dart';
import 'package:base_app/widgets/app_scaffold_title.dart';
import 'package:base_app/widgets/share_dialog.dart';
import 'package:flutter/material.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/widgets/app_scaffold.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:base_app/utils/sizing_info_extension.dart';

class OnlineSebhaView extends StatefulWidget {
  const OnlineSebhaView({Key key}) : super(key: key);

  @override
  _OnlineSebhaViewState createState() => _OnlineSebhaViewState();
}

class _OnlineSebhaViewState extends State<OnlineSebhaView>
    with WidgetsBindingObserver {
  final _backBackGroundColor = const Color(0XFFF6F9F7);

  final _greenColor = const Color(0XFF86CF72);

  final Color prymaryColor = const Color(0XFF347D53);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        contentPadding: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(borderRadius:
        BorderRadius.all(Radius.circular(12))),
        content: Container(
            height: 400,
            child: LoadUiWithAdd(mainView: AddWidgetEdit( title:   "المسبحة",bannerName :BannerName.SEBHA ,buttomTitle:  "متابعه",))),
      ),
    )) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return !Provider.of<UserProvider>(context).isLoggedIn
        ? LoginPopUpView()
        : ResponsiveBuilder(
      builder: (context, SizingInformation sizeConfig) {
        return

          WillPopScope(
            onWillPop: _onWillPop,

            child:
          AppScaffold(
          onProfileTap: () => Get.to(MyProfileView()),
          actions: [
            Container(
              margin: EdgeInsets.only(
                top: sizeConfig.blockSizeVertical,
                left: sizeConfig.blockSizeHorizontal * 3,
              ),
              width: sizeConfig.blockSizeHorizontal * 9.5,
              height: sizeConfig.blockSizeHorizontal * 9.5,
              child: FittedBox(
                child: FloatingActionButton(
                  heroTag: "1",
                  backgroundColor: Constants.ICON_COLOR,
                  onPressed: () {
                    Provider.of<OnlineSebhaProvider>(context,
                        listen: false)
                        .uploadLastSebhaCount();
                    Get.dialog(NewTasbeehView(
                      sizeConfig: sizeConfig,
                      isLocal: false,
                    ));
                  },
                  child: FittedBox(
                    child: Icon(
                      Icons.add,
                      size: sizeConfig.blockSizeHorizontal * 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
          floatingActionButton: new Container(
            height: 100.0,
            child: new Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 35),

                        height: 60.0,
                        child: new FloatingActionButton(
                          key: UniqueKey(),
                          backgroundColor:prymaryColor ,

                          onPressed: (){
                            Get.dialog(ShareDialog());

                          },
                          heroTag:  'ShareDialog',

                          tooltip: 'ShareDialog',
                          child: new Icon(Icons.share ,color: Colors.white,),
                        ),
                      ),
                      new Container(
                        width: 50.0,
                      ), // a space
                      Container(
                        height: 60.0,
                        child: new FloatingActionButton(
                          key: UniqueKey(),

                          backgroundColor:prymaryColor ,

                          onPressed: (){
                            Navigator.pushNamed(context, '/settings');

                          },
                          heroTag: 'settings',

                          tooltip: 'settings',
                          child: new Icon(Icons.settings, color: Colors.white,),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),),
          padding: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 4),
          title: AppScaffoldTitleWidget(title: "المسبحة"),
          centerTitle: true,
          child: (Provider.of<OnlineSebhaProvider>(context).list ==
              null ||
              Provider.of<OnlineSebhaProvider>(context)
                  .currentTasbeeh ==
                  null)
              ? Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      prymaryColor),
                ),
              ],
            ),
          )
              : Stack(
            children: [
              Column(
                children: [
                  CarouselSlider(
                    carouselController:
                    Provider.of<OnlineSebhaProvider>(
                      context,
                    ).controller,
                    options: CarouselOptions(
                        initialPage:
                        Provider.of<OnlineSebhaProvider>(
                          context,
                        ).currentIndex,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, _) {
                          Provider.of<OnlineSebhaProvider>(context,
                              listen: false)
                              .currentIndex = index;
                        },
                        viewportFraction: 0.9,
                        aspectRatio: 2.0,
                        height: sizeConfig.blockSizeVertical * 35),
                    items:
                    (Provider.of<OnlineSebhaProvider>(context)
                        .list
                        .map((zikr) {
                      return Container(
                        child: Column(
                          children: [
                            buildContentStack(
                                sizeConfig, zikr, context),
                          ],
                        ),
                      );
                    }).toList()),
                  ),
                  Spacer(),
                  buildControllersContainerWidget(
                      sizeConfig, context),
                ],
              ),
              if (Provider.of<OnlineSebhaProvider>(context)
                  .showCongratulations)
                IgnorePointer(
                  child: Container(
                    width: double.infinity,
                    child: Image.asset(
                        "assets/images/sebha_view/congratulations.gif"),
                  ),
                ),
              if (Provider.of<OnlineSebhaProvider>(context)
                  .showCongratulations)
                IgnorePointer(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/sebha_view/swipe.gif",
                      width: double.infinity,
                      height: 100,
                    ),
                  ),
                ),
            ],
          ),
        ));
      },
    );
  }

  Container buildControllesWidget(SizingInformation sizeConfig) {
    return Container(
      margin: EdgeInsets.only(
        top: sizeConfig.blockSizeVertical * 6,
        left: sizeConfig.blockSizeHorizontal * 10,
        right: sizeConfig.blockSizeHorizontal * 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // buildIncreaseButtonWidget(sizeConfig,),
        ],
      ),
    );
  }

  Widget buildContentStack(
      SizingInformation sizeConfig, TasbeehModel zikr, context) {
    return Container(
      margin:
      EdgeInsets.symmetric(horizontal: sizeConfig.blockSizeHorizontal * 2),
      height: sizeConfig.blockSizeVertical * 33,
      child: Stack(
        children: [
          Container(
              height: sizeConfig.blockSizeVertical * 30,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                // bottom: sizeConfig.blockSizeVertical * 6,
                  top: sizeConfig.blockSizeVertical * 2,
                  left: sizeConfig.blockSizeHorizontal * 4,
                  right: sizeConfig.blockSizeHorizontal * 4),
              decoration: BoxDecoration(
                  color: _backBackGroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border:
                  Border.all(color: Constants.PRIMARY_COLOR, width: .4)),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: sizeConfig.blockSizeVertical * 3),
                        padding: EdgeInsets.symmetric(
                            horizontal: sizeConfig.blockSizeHorizontal * 5,
                            vertical: sizeConfig.blockSizeVertical),
                        decoration: BoxDecoration(
                            color: _greenColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              "assets/images/sebha_view/sebha_icon.svg",
                              width: sizeConfig.blockSizeHorizontal * 3.5,
                            ),
                            SizedBox(
                              width: sizeConfig.blockSizeHorizontal * 3,
                            ),
                            Text(
                              "${zikr.count}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: sizeConfig.blockSizeHorizontal * 5,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "${zikr.content}",
                      style: TextStyle(
                          height: 1.7,
                          fontSize: sizeConfig.blockSizeHorizontal * 5,
                          color: Constants.PRIMARY_COLOR,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${zikr.note}",
                      style: TextStyle(
                          height: 1.7,
                          fontSize: sizeConfig.blockSizeHorizontal * 4,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget buildControllersContainerWidget(
      SizingInformation sizeConfig, context) {
    return Container(
      height: sizeConfig.blockSizeVertical * 40,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: sizeConfig.blockSizeVertical * 25,
              decoration: BoxDecoration(
                color: _backBackGroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(sizeConfig.blockSizeHorizontal * 15),
                  topRight:
                  Radius.circular(sizeConfig.blockSizeHorizontal * 15),
                ),
              ),
            ),
          ),
          if (Provider.of<OnlineSebhaProvider>(context).showCongratulations)
            Image.asset("assets/images/sebha_view/congratulations.gif"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: "2",
                onPressed: () =>
                    Provider.of<OnlineSebhaProvider>(context, listen: false)
                        .setAllowClickSound(),
                backgroundColor: prymaryColor,
                child: Icon(
                  Provider.of<OnlineSebhaProvider>(context).allowClickSound
                      ? Icons.volume_up
                      : Icons.volume_off,
                  color: Colors.white,
                ),
              ),
              buildIncreaseWidget(sizeConfig, context),
              FloatingActionButton(
                heroTag: "3",
                onPressed: () async => await Provider.of<OnlineSebhaProvider>(
                    context,
                    listen: false)
                    .increaseTasbeeh(count: 0),
                backgroundColor: prymaryColor,
                child: Icon(
                  Icons.restore,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildIncreaseWidget(SizingInformation sizeConfig, context) {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 60,
      alignment: Alignment.center,
      height: sizeConfig.blockSizeVertical * 30,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/sebha_view/button_pattern.png"),
            fit: BoxFit.contain),
      ),
      child: FlatButton(
        shape: CircleBorder(),
        onPressed: () async {
          await Provider.of<OnlineSebhaProvider>(context, listen: false)
              .increaseTasbeeh();
        },
        child: Card(
          elevation: 2,
          shape: CircleBorder(),
          color: Colors.white,
          child: Container(
            width: sizeConfig.blockSizeHorizontal * 45,
            decoration:
            BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            padding: EdgeInsets.all(sizeConfig.blockSizeHorizontal * 4),
            child: Container(
              decoration: BoxDecoration(
                  color: Constants.PRIMARY_COLOR, shape: BoxShape.circle),
              child: FittedBox(
                child: CircularPercentIndicator(
                  radius: sizeConfig.blockSizeHorizontal * 16,
                  lineWidth: sizeConfig.blockSizeHorizontal * 1,
                  percent: double.parse(
                      "${Provider.of<OnlineSebhaProvider>(context).currentTasbeeh.counted / Provider.of<OnlineSebhaProvider>(context).currentTasbeeh.count * 100 / 100}") >
                      1.0
                      ? 1
                      : double.parse(
                      "${Provider.of<OnlineSebhaProvider>(context).currentTasbeeh.counted / Provider.of<OnlineSebhaProvider>(context).currentTasbeeh.count * 100 / 100}"),
                  backgroundColor: Colors.white,
                  center: Text(
                    "${Provider.of<OnlineSebhaProvider>(context).currentTasbeeh.totalCounted}",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  progressColor: _greenColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      await Provider.of<OnlineSebhaProvider>(context, listen: false)
          .uploadLastSebhaCount();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
