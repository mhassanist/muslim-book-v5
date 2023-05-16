import 'package:auto_size_text/auto_size_text.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/tasbeeh_top_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../utils/sizing_info_extension.dart';

class TasbeehScoreboardScreen {
  late TasbeehTopProvider provider;
  late final BuildContext context;
  late SizingInformation sizeConfig;

  TasbeehScoreboardScreen(this.context) {
    provider = Provider.of<TasbeehTopProvider>(context);
  }

  final Color prymaryColor = const Color(0XFF347D53);
  final _greenColor = const Color(0XFF86CF72);

  Widget topWinners() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
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
                    buildCircularProgress(sizeConfig),
                    Expanded(
                        child: Column(
                      children: [
                        buildDailyRankWidget(sizeConfig,
                            titel: AppLocalizations.of(context)!
                                .translate("Weekly_Achievement"),
                            number: "${provider.userScore.rank}",
                            image: "rank_medal.png"),
                        buildDailyRankWidget(sizeConfig,
                            titel: AppLocalizations.of(context)!
                                .translate("Weekly_Achievement"),
                            number: "${provider.userScore.points}",
                            image: "flag_medal.png"),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(sizeConfig.blockSizeHorizontal * 10),
                topRight: Radius.circular(sizeConfig.blockSizeHorizontal * 10),
              ),
              color: Constants.CANVAS_COLOR,
            ),
            width: double.infinity,
            margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 2),
            padding: EdgeInsets.symmetric(
                horizontal: sizeConfig.blockSizeHorizontal * 6,
                vertical: sizeConfig.blockSizeVertical * 2),
            child: Text(
              AppLocalizations.of(context)!.translate("rank_weekly"),
              style: TextStyle(
                  color: prymaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: sizeConfig.blockSizeHorizontal * 6),
              textAlign: TextAlign.start,
            ),
          ),
          ListView.builder(
            // padding:
            //     EdgeInsets.only(bottom: sizeConfig.blockSizeVertical * 15.5),
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.topList.length,
            itemBuilder: (context, index) {
              return topItem(
                  index,
                  Constants.CANVAS_COLOR,
                  Theme.of(context).colorScheme.secondary,
                  // provider.topList[index].id.toString(),
                  provider.topList[index].name,
                  provider.topList[index].country ?? '',
                  provider.topList[index].points.toString(),
                  provider.topList[index].image == null
                      ? provider.topList[index].flag!
                          .replaceAll("http://", "https://")
                      : provider.topList[index].image!
                          .replaceAll("http://", "https://"));
            },
          ),
        ],
      ),
    );
  }

  buildDailyRankWidget(
    SizingInformation sizeConfig, {
    String titel = '',
    String number = '',
    String image = '',
  }) {
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

  Widget buildCircularProgress(SizingInformation sizeConfig) {
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
          percent: provider.userScore.points / 10000 * 100 / 100 > 1
              ? 1
              : provider.userScore.points / 10000 * 100 / 100,
          backgroundColor: prymaryColor,
          center: Text(
            "${(provider.userScore.points / 10000 * 100).toStringAsFixed(0)} %",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          progressColor: Colors.white,
        ),
      ),
    );
  }

  Widget topItem(
    index,
    Color backgroundColor,
    Color textColor,
    String name,
    String countryName,
    String points, [
    String imageString = '',
  ]) {
    var smallFont = sizeConfig.blockSizeHorizontal * 3;
    var mediumFont = sizeConfig.blockSizeHorizontal * 4;

    return Card(
      margin: EdgeInsets.fromLTRB(1, 0.5, 1, 0.5),
      elevation: 2,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: sizeConfig.blockSizeVertical * 15,
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: sizeConfig.blockSizeHorizontal * 15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        (index + 1).toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: mediumFont,
                            color: Theme.of(context).primaryColor),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              imageString.replaceAll("http://", "https://"),
                            ),
                            onError: (_, __) =>
                                AssetImage('assets/images/general/person.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: sizeConfig.blockSizeHorizontal * 13,
                        width: sizeConfig.blockSizeHorizontal * 13,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: sizeConfig.blockSizeHorizontal * 2,
                    right: sizeConfig.blockSizeHorizontal * 2,
                  ),
                  width: sizeConfig.blockSizeHorizontal * 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        countryName.isNotEmpty
                            ? name + ' - ' + countryName
                            : name,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: sizeConfig.blockSizeHorizontal * 5,
                          color: textColor,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("numberPraises"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: smallFont,
                                      color: textColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  points,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: mediumFont,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                          // VerticalDivider(width: 2,color: Colors.green,),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
