import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/network_utils/api_service.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/sebha_feature/models/sebha_top_model.dart';
import 'package:muslim_book/sebha_feature/online_sebha/controllers/online_sebha_controller.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:muslim_book/widgets/app_scaffold_title.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';

class ArchieveView extends StatefulWidget {
  ArchieveView({Key key}) : super(key: key);

  @override
  _ArchieveViewState createState() => _ArchieveViewState();
}

class _ArchieveViewState extends State<ArchieveView> {
  final _backBackGroundColor = const Color(0XFFF6F9F7);
  final _greenColor = const Color(0XFF86CF72);
  final Color prymaryColor = const Color(0XFF347D53);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<OnlineSebhaProvider>(context, listen: false)
          .uploadLastSebhaCount();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, SizingInformation sizeConfig) {
        return AppScaffold(
          padding: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 4),
          title: AppScaffoldTitleWidget(title: AppLocalizations.of(context)!.translate("archiv")),
          centerTitle: true,
          child: ListView(
            children: [
              buildRankWidget(sizeConfig),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: sizeConfig.blockSizeVertical * 3.5),
                width: double.infinity,
                margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 2),
                decoration: BoxDecoration(
                  color: _backBackGroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(sizeConfig.blockSizeHorizontal * 10),
                    topRight:
                        Radius.circular(sizeConfig.blockSizeHorizontal * 10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: sizeConfig.blockSizeHorizontal * 6,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.translate("rank_weekly"),
                        style: TextStyle(
                            color: prymaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: sizeConfig.blockSizeHorizontal * 6),
                      ),
                    ),
                    SizedBox(
                      height: sizeConfig.blockSizeVertical * 4,
                    ),
                    FutureBuilder<List<SebhaTopModelData>>(
                      future: locator<ApiService>().getTopSebha(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Container(
                            height: sizeConfig.blockSizeVertical * 40,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            return buildUserRankWidget(
                                sizeConfig, snapshot.data[index], index);
                          },
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildRankWidget(SizingInformation sizeConfig) {
    return FutureBuilder<SebhaTopModelData>(
        future: locator<ApiService>().getSebhaProfile(),
        builder: (context, snapshot) {
          if (snapshot.data == null ||
              snapshot.connectionState == ConnectionState.waiting)
            return Container(
              height: sizeConfig.blockSizeVertical * 30,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: sizeConfig.blockSizeHorizontal * 6),
            child: Card(
              elevation: 7,
              color: _greenColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: EdgeInsets.all(sizeConfig.blockSizeHorizontal * 2),
                child: Row(
                  children: [
                    buildCircularProgress(sizeConfig, snapshot.data),
                    Expanded(
                        child: Column(
                      children: [
                        buildDailyRankWidget(sizeConfig,
                            titel:AppLocalizations.of(context)!.translate("rank_weekly"),
                            number: "${snapshot.data.rank}",
                            image: "rank_medal.png"),
                        buildDailyRankWidget(sizeConfig,
                            titel: AppLocalizations.of(context)!.translate("Weekly_Achievement"),
                            number: "${snapshot.data.total}",
                            image: "flag_medal.png"),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildCircularProgress(
      SizingInformation sizeConfig, SebhaTopModelData data) {
    return Container(
      padding: EdgeInsets.all(sizeConfig.blockSizeHorizontal * 6),
      height: sizeConfig.blockSizeHorizontal * 40,
      width: sizeConfig.blockSizeHorizontal * 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: AssetImage("assets/images/sebha_view/circular.png"),
            fit: BoxFit.fill),
      ),
      child: FittedBox(
        child: CircularPercentIndicator(
          radius: sizeConfig.blockSizeHorizontal * 16,
          lineWidth: sizeConfig.blockSizeHorizontal * 2,
          percent: data.total / 1000 * 100 / 100 > 1
              ? 1
              : data.total / 1000 * 100 / 100,
          backgroundColor: prymaryColor,
          center: Text(
            "${(data.total / 1000 * 100).toStringAsFixed(0)} %",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          progressColor: Colors.white,
        ),
      ),
    );
  }

  buildDailyRankWidget(SizingInformation sizeConfig,
      {String titel, String number, String image}) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: sizeConfig.blockSizeVertical,
          horizontal: sizeConfig.blockSizeHorizontal * 2),
      padding: EdgeInsets.symmetric(
          vertical: sizeConfig.blockSizeVertical * 2,
          horizontal: sizeConfig.blockSizeHorizontal * 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sizeConfig.blockSizeHorizontal * 4),
      ),
      child: Row(
        children: [
          Expanded(child: Image.asset("assets/images/sebha_view/$image")),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text("$titel",
                      style: TextStyle(color: _greenColor),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: sizeConfig.blockSizeVertical,
                  ),
                  Text(
                    "$number",
                    style: TextStyle(color: prymaryColor),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget buildUserRankWidget(
      SizingInformation sizeConfig, SebhaTopModelData model, int index) {
    bool itsMe =
        model.id == Provider.of<UserProvider>(context, listen: false).user.id;
    return Container(
      height: sizeConfig.blockSizeVertical * 8,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: sizeConfig.blockSizeVertical,
                horizontal: sizeConfig.blockSizeHorizontal * 4,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: sizeConfig.blockSizeHorizontal * 2,
              ),
              decoration: BoxDecoration(
                  color: itsMe ? _greenColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Container(
                    width: sizeConfig.blockSizeHorizontal * 7,
                    child: Text(
                      "${index + 1}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: sizeConfig.blockSizeHorizontal * 5,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: sizeConfig.blockSizeHorizontal * 2),
                    child: model.image == null
                        ? placeHolder(sizeConfig)
                        : ExtendedImage.network(
                            model.image.replaceAll("http://", "https://"),
                            height: sizeConfig.blockSizeVertical * 6,
                            fit: BoxFit.cover,
                            loadStateChanged: (state) {
                              if (state.extendedImageLoadState ==
                                  LoadState.failed) {
                                return placeHolder(sizeConfig);
                              }
                              return state.completedWidget;
                            },
                            shape: BoxShape.circle,
                            width: sizeConfig.blockSizeVertical * 6,
                          ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Text(
                      "${model.name}",
                      style: TextStyle(
                        color: itsMe ? Colors.white : prymaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: sizeConfig.blockSizeHorizontal * 4.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Text(
                        "${model.total}",
                        textAlign: TextAlign.end,
                      )),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.black87.withOpacity(.1),
          )
        ],
      ),
    );
  }

  Container placeHolder(SizingInformation sizeConfig) {
    return Container(
      child: Image.asset(
        "assets/images/sebha_view/profile.png",
        width: sizeConfig.blockSizeVertical * 6,
        height: sizeConfig.blockSizeVertical * 6,
      ),
    );
  }
}
