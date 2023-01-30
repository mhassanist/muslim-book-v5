import 'package:muslim_book/sebha_feature/views/new_tasbeeh_view.dart';
import 'package:muslim_book/widgets/app_scaffold_title.dart';
import 'package:muslim_book/widgets/share_dialog.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/sebha_feature/offline_sebha/database/sebha_database.dart';
import 'package:muslim_book/sebha_feature/providers/sebha_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';

class OfflineSebhaView extends StatefulWidget {
  OfflineSebhaView({super.key});

  @override
  _OfflineSebhaViewState createState() => _OfflineSebhaViewState();
}

class _OfflineSebhaViewState extends State<OfflineSebhaView> {
  final _backBackGroundColor = const Color(0XFFF6F9F7);
  final _greenColor = const Color(0XFF86CF72);
  final Color prymaryColor = const Color(0XFF347D53);

  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, SizingInformation sizeConfig) {
        return AppScaffold(
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
                ) ,

              Container(
                margin: EdgeInsets.only(
                    top: sizeConfig.blockSizeVertical,
                    left: sizeConfig.blockSizeHorizontal * 3,
                    right: sizeConfig.blockSizeHorizontal * 3),
                width: sizeConfig.blockSizeHorizontal * 9.5,
                height: sizeConfig.blockSizeHorizontal * 9.5,
                child: FittedBox(
                  child: FloatingActionButton(
                    heroTag: "1",
                    backgroundColor: Constants.ICON_COLOR,
                    onPressed: () {
                      Get.dialog(NewTasbeehView(
                        sizeConfig: sizeConfig,
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
            padding: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 4),
            title: AppScaffoldTitleWidget(title: "المسبحة"),
            centerTitle: true,
            child: (Provider.of<SebhaProvider>(context).list == null ||
                    Provider.of<SebhaProvider>(context).currentTasbeeh == null)
                ? Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(prymaryColor),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      Column(
                        children: [
                          CarouselSlider(
                            carouselController: Provider.of<SebhaProvider>(
                                    context,
                                    listen: false)
                                .controller,
                            options: CarouselOptions(
                                enableInfiniteScroll: true,
                                initialPage: Provider.of<SebhaProvider>(context)
                                    .currentIndex,
                                onPageChanged: (index, _) {
                                  Provider.of<SebhaProvider>(context,
                                          listen: false)
                                      .currentIndex = index;
                                },
                                viewportFraction: 0.9,
                                aspectRatio: 2.0,
                                height: sizeConfig.blockSizeVertical * 35),
                            items: (Provider.of<SebhaProvider>(context)
                                .list
                                .map((zikr) {
                              return Container(
                                child: Column(
                                  children: [
                                    buildContentStack(sizeConfig, zikr),
                                  ],
                                ),
                              );
                            }).toList()),
                          ),
                          Spacer(),
                          buildControllersContainerWidget(sizeConfig),
                        ],
                      ),
                      if (Provider.of<SebhaProvider>(context)
                          .showCongratulations)
                        Container(
                          width: double.infinity,
                          child: Image.asset(
                              "assets/images/sebha_view/congratulations.gif"),
                        ),
                      if (Provider.of<SebhaProvider>(context)
                          .showCongratulations)
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/sebha_view/swipe.gif",
                            width: double.infinity,
                            height: 100,
                          ),
                        ),
                    ],
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

  Widget buildContentStack(SizingInformation sizeConfig, Tasbeeh zikr) {
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
                              "${zikr.totalCounter}",
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
                      "${zikr.name}",
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

  Widget buildControllersContainerWidget(SizingInformation sizeConfig) {
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
          if (Provider.of<SebhaProvider>(context).showCongratulations)
            Image.asset("assets/images/sebha_view/congratulations.gif"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: "2",
                onPressed: () =>
                    Provider.of<SebhaProvider>(context, listen: false)
                        .setAllowClickSound(),
                backgroundColor: prymaryColor,
                child: Icon(
                  Provider.of<SebhaProvider>(context).allowClickSound
                      ? Icons.volume_up
                      : Icons.volume_off,
                  color: Colors.white,
                ),
              ),
              buildIncreaseWidget(sizeConfig),
              FloatingActionButton(
                heroTag: "3",
                onPressed: () async =>
                    await Provider.of<SebhaProvider>(context, listen: false)
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

  Widget buildIncreaseWidget(SizingInformation sizeConfig) {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 60,
      alignment: Alignment.center,
      height: sizeConfig.blockSizeVertical * 30,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/sebha_view/button_pattern.png"),
            fit: BoxFit.contain),
      ),
      child: InkWell(
        onTap: () async {
          await Provider.of<SebhaProvider>(context, listen: false)
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
                              "${Provider.of<SebhaProvider>(context).currentTasbeeh.counted / Provider.of<SebhaProvider>(context).currentTasbeeh.totalCounter * 100 / 100}") >
                          1.0
                      ? 1
                      : double.parse(
                          "${Provider.of<SebhaProvider>(context).currentTasbeeh.counted / Provider.of<SebhaProvider>(context).currentTasbeeh.totalCounter * 100 / 100}"),
                  backgroundColor: Colors.white,
                  center: Text(
                    "${Provider.of<SebhaProvider>(context).currentTasbeeh.counted}",
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
}
