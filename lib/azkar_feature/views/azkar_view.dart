// import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:muslim_book/ads/admob_rectangle.dart';
import 'package:muslim_book/ads/load_ui_with_add.dart';
import 'package:muslim_book/azkar_feature/models/azkar_model.dart';
import 'package:muslim_book/ads/add_widget_edit.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:muslim_book/widgets/app_scaffold_title.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:responsive_builder/responsive_builder.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:share_plus/share_plus.dart';

class AzkarView extends StatefulWidget {
  AzkarView({
    super.key,
    required this.zikr,
  });

  final Map<String, String> zikr;

  @override
  _AzkarViewState createState() => _AzkarViewState();
}

class _AzkarViewState extends State<AzkarView> {
  List<Zikr>? azkar;
  late Zikr currentZikr;
  int currentIndex = 0;
  final CarouselController controller = CarouselController();
  // late AudioCache _audioCache;
  // late AudioPlayer audioPlayer;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    // _audioCache = AudioCache(
    //   prefix: "audio/",
    //   fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
    // );
    getAzkarContent();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            content: Container(
              height: 400,
              child: LoadUiWithAdd(
                  mainView: AddWidgetEdit(
                title: AppLocalizations.of(context)!.translate("azkar"),
                bannerName: BannerName.AZKAR,
                buttomTitle: AppLocalizations.of(context)!.translate("follow"),
              )),
            ),
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, SizingInformation sizeConfig) {
        return WillPopScope(
            onWillPop: _onWillPop,
            child: AppScaffold(
              padding: EdgeInsets.symmetric(vertical: 20),
              title: AppScaffoldTitleWidget(title: "${widget.zikr["name"]}"),
              centerTitle: true,
              transparentBackground: true,
              child: azkar == null
                  ? Container()
                  : LoadUiWithAdd(
                      mainView: ListView(
                        children: [
                          CarouselSlider(
                            carouselController: controller,
                            options: CarouselOptions(
                                enableInfiniteScroll: false,
                                scrollPhysics: NeverScrollableScrollPhysics(),
                                initialPage: currentIndex,
                                onPageChanged: (index, _) {
                                  setState(() {
                                    currentIndex = index;
                                    currentZikr = azkar![index];
                                  });
                                },
                                viewportFraction: 0.9,
                                aspectRatio: 2.0,
                                height: sizeConfig.blockSizeVertical * 50,),
                            items: azkar!.map((zikr) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        buildContentStack(sizeConfig, zikr),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          buildControllesWidget(sizeConfig, currentZikr),
                          Spacer(),
                          Container(
                              height: 300,
                              child: AdMobRectangle(BannerName.BOSLA)),
                        ],
                      ),
                    ),
            ));
      },
    );
  }

  Container buildControllesWidget(SizingInformation sizeConfig, Zikr zikr) {
    return Container(
      margin: EdgeInsets.only(
        top: sizeConfig.blockSizeVertical * 6,
        left: sizeConfig.blockSizeHorizontal * 10,
        right: sizeConfig.blockSizeHorizontal * 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   child: FloatingActionButton(
          //     heroTag: "2 ${zikr.content}",
          //     backgroundColor: Colors.white,
          //     onPressed: () {
          //       controller.animateToPage(currentIndex - 1);
          //     },
          //     child: Image.asset(
          //       "assets/images/azkar_view/ios_back.png",
          //       height: sizeConfig.blockSizeVertical * 3,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          buildIncreaseButtonWidget(sizeConfig, zikr),
          // Container(
          //   child: FloatingActionButton(
          //     heroTag: "3 ${zikr.content}",
          //     backgroundColor: Colors.white,
          //     onPressed: () {
          //       controller.animateToPage(currentIndex + 1);
          //     },
          //     child: Image.asset(
          //       "assets/images/azkar_view/ios_forward.png",
          //       height: sizeConfig.blockSizeVertical * 3,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildContentStack(SizingInformation sizeConfig, Zikr zikr) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: sizeConfig.blockSizeHorizontal * 2),
      height: sizeConfig.blockSizeVertical * 48,
      child: Stack(
        children: [
          Container(
              height: sizeConfig.blockSizeVertical * 45,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                  bottom: sizeConfig.blockSizeVertical * 6,
                  top: sizeConfig.blockSizeVertical * 2,
                  left: sizeConfig.blockSizeHorizontal * 4,
                  right: sizeConfig.blockSizeHorizontal * 4),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "${zikr.content}",
                    style: TextStyle(
                        height: 1.7,
                        fontSize: sizeConfig.blockSizeHorizontal * 5,
                        color: Constants.PRIMARY_COLOR,
                        fontWeight: FontWeight.bold),
                  ),
                  if (zikr.notes != null)
                    TextSpan(
                      text: "( ${zikr.notes} )",
                      style: TextStyle(
                        fontSize: sizeConfig.blockSizeHorizontal * 4,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    )
                ])),
                // child: Text(
                //   '${zikr.content}',
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: sizeConfig.blockSizeHorizontal * 10),
              child: Row(
                children: [
                  Card(
                    elevation: 5,
                    shape: StadiumBorder(),
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: sizeConfig.blockSizeHorizontal * 5,
                          vertical: sizeConfig.blockSizeVertical),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.translate("repet"),
                            style: TextStyle(
                                color: Constants.PRIMARY_DARK_COLOR,
                                fontSize: sizeConfig.blockSizeHorizontal * 5.5,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: sizeConfig.blockSizeHorizontal * 3,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color(0XFF347D53),
                                shape: BoxShape.circle),
                            child: Text(
                              "${zikr.counter}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      sizeConfig.blockSizeHorizontal * 5.5,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  FloatingActionButton(
                    heroTag: "6 ${zikr.content}",
                    onPressed: () {
                      Share.share(
                          "${zikr.content} \n ${zikr.notes} \n \n ${AppLocalizations.of(context)!.translate("invite_to_download_app")}");
                    },
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.share,
                      color: Constants.PRIMARY_COLOR,
                      size: sizeConfig.blockSizeHorizontal * 8,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void getAzkarContent() async {
    azkar = AzkarModel.fromJson(await rootBundle.loadString(
            'assets/databases/azkar_database/${widget.zikr["path"]}'))
        .azkar;
    currentZikr = azkar!.first;
    setState(() {});
  }

  Widget buildIncreaseButtonWidget(SizingInformation sizeConfig, Zikr zikr) {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 34,
      height: sizeConfig.blockSizeHorizontal * 34,
      child: FittedBox(
          child: FloatingActionButton(
        heroTag: "1 ${zikr.content}",
        onPressed: () async {
          if (zikr.counted < zikr.counter - 1) {
            setState(() {
              zikr.counted = zikr.counted + 1;
            });
          } else {
            controller.nextPage();
            if (currentIndex == azkar!.length - 1) {
              // _audioCache.play('allah_make_you_from_heaven.wav');
              // audioPlayer.play(
              //   'assets/audio/allah_make_you_from_heaven.wav',
              //   isLocal: true,
              // );
              await player.play(AssetSource('sounds/coin.wav'));
              Navigator.pop(context);
            }
          }
        },
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(sizeConfig.blockSizeHorizontal * 3),
          decoration: BoxDecoration(
              color: const Color(0XFF347D53), shape: BoxShape.circle),
          child: Text(
            "${zikr.counted}",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: sizeConfig.blockSizeHorizontal * 3),
          ),
        ),
      )),
    );
  }

// @override
// void dispose() {
//   super.dispose();
// }
}
