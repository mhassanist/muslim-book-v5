import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/myProfile_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:screenshot/screenshot.dart';

import 'package:share_extend/share_extend.dart';
import 'package:share_plus/share_plus.dart';
import '../../../utils/sizing_info_extension.dart';

class MyProfileUI {
  final MyProfileProvider provider;
  final SizingInformation sizeConfig;
  final BuildContext context;
  final ScreenshotController screenshotController;

  MyProfileUI(
      this.sizeConfig, this.context, this.provider, this.screenshotController);

  Widget personalData() {
    return Column(
      children: <Widget>[
        SizedBox(height: sizeConfig.blockSizeVertical * 2),
        Padding(
          padding: EdgeInsets.only(bottom: sizeConfig.blockSizeVertical),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (provider.scoreModelData!.flag != null)
                Container(
                  width: sizeConfig.blockSizeHorizontal * 7.5,
                  height: sizeConfig.blockSizeHorizontal * 7.5,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(provider.scoreModelData!.flag!
                              .replaceAll("http://", "https://")),
                          fit: BoxFit.cover)),
                ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: sizeConfig.blockSizeHorizontal * 2),
                child: AutoSizeText(
                  provider.scoreModelData!.name ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: sizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        if (provider.scoreModelData!.email != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.email,
                    size: sizeConfig.blockSizeHorizontal * 6,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      "${provider.scoreModelData!.email}",
                      style: TextStyle(
                        fontSize: sizeConfig.blockSizeHorizontal * 4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget points() {
    return Column(
      children: <Widget>[
        profileDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            pointsDetailsColumn(
                "total_points", "${provider.scoreModelData!.points}"),
            betweenPointsDetailsDivider(),
            pointsDetailsColumn(
                "competition_rank", "${provider.scoreModelData!.rank}"),
            //betweenPointsDetailsDivider(),
            /*pointsDetailsColumn("answered_questions",
                "${provider.scoreModelData.correctAnswer + provider.scoreModelData.wrongAnswer}"),
            //betweenPointsDetailsDivider(),
            pointsDetailsColumn(
                "correct_answers", "${provider.scoreModelData.correctAnswer}"),*/
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            pointsDetailsColumn(
                "remind_points", "${provider.scoreModelData!.reminds}"),
            betweenPointsDetailsDivider(),
            pointsDetailsColumn(
                "remind_rank", "${provider.scoreModelData!.remindsRank}"),

            //betweenPointsDetailsDivider(),
          ],
        ),
        profileDivider(),
      ],
    );
  }

  Container betweenPointsDetailsDivider() {
    return Container(
      width: 2,
      height: sizeConfig.blockSizeVertical * 5,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget pointsDetailsColumn(title, number) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate(title),
          style: TextStyle(
            fontSize: sizeConfig.blockSizeHorizontal * 4,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical),
          height: sizeConfig.blockSizeVertical * 5,
          alignment: Alignment.center,
          width: sizeConfig.blockSizeHorizontal * 20,
          child: AutoSizeText(
            "$number",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: sizeConfig.blockSizeHorizontal * 8,
                fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        )
      ],
    );
  }

  Padding profileDivider() {
    return Padding(
      padding: EdgeInsets.all(sizeConfig.blockSizeHorizontal * 5),
      child: Container(
        height: 2,
        width: sizeConfig.blockSizeHorizontal * 90,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Widget textShare() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Text(
        AppLocalizations.of(context)!.translate("share_your_profile"),
        style: TextStyle(fontSize: sizeConfig.blockSizeHorizontal * 4),
        textAlign: TextAlign.center,
        maxLines: 2,
      ),
    );
  }

  Widget socialmedia() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: sizeConfig.blockSizeHorizontal * 15,
          height: sizeConfig.blockSizeHorizontal * 15,
          child: ElevatedButton(
              child: Icon(FontAwesomeIcons.facebookF),
              onPressed: () async => faceBookShare(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFF4266b2),
                  shape: CircleBorder(side: BorderSide.none))),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: sizeConfig.blockSizeHorizontal * 15,
          height: sizeConfig.blockSizeHorizontal * 15,
          child: ElevatedButton(
              child: Icon(FontAwesomeIcons.twitter),
              onPressed: () async => shareApp(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: CircleBorder(side: BorderSide.none))),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: sizeConfig.blockSizeHorizontal * 15,
          height: sizeConfig.blockSizeHorizontal * 15,
          child: ElevatedButton(
              child: Icon(
                FontAwesomeIcons.whatsapp,
                size: sizeConfig.blockSizeHorizontal * 7,
              ),
              onPressed: () async => shareApp(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF4FCE5D),
                  shape: CircleBorder(side: BorderSide.none))),
        )
      ],
    );
  }

  Future shareApp() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    String fileName = DateTime.now().microsecondsSinceEpoch.toString() + '.png';
    final path = '$directory';

    String? fullPath =
        await screenshotController.captureAndSave(path, fileName: fileName);

    if (fullPath != null) {
      await ShareExtend.share(fullPath, "image",
          extraText: AppLocalizations.of(context)!.translate(
            "invite_to_download_app",
          ));
    }
  }

  Widget imageWidget() {
    return Container(
      child: Center(
        child: Stack(
          // overflow: Overflow.visible,
          fit: StackFit.passthrough,
          //fit: StackFit.loose,
          children: <Widget>[
            ClipRRect(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      provider.scoreModelData!.image!
                          .replaceAll("http://", "https://"),
                    ),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) =>
                        AssetImage('assets/images/profile_image.png'),
                  ),

                  // image: DecorationImage(
                  //     image: provider.scoreModelData!.image != null
                  //         ? NetworkImage(
                  //             provider.scoreModelData!.image!.replaceAll("http://", "https://"),
                  //           )
                  //         : AssetImage("assets/images/profile_image.png"),
                  //     fit: BoxFit.cover),
                ),
                height: sizeConfig.blockSizeHorizontal * 30,
                width: sizeConfig.blockSizeHorizontal * 30,
              ),
            ),
            // Positioned(
            //   top: 0,
            //   bottom: 0,
            //   right: -sizeConfig.blockSizeHorizontal * 7.5,
            //   child: Container(
            //     height: sizeConfig.blockSizeHorizontal * 15,
            //     width: sizeConfig.blockSizeHorizontal * 15,
            //     decoration: BoxDecoration(
            //         border: Border.all(
            //             width: 2, color: Theme.of(context).accentColor),
            //         color: Constants.CANVAS_COLOR,
            //         shape: BoxShape.circle),
            //     child: IconButton(
            //       onPressed: () {
            //         _openChooseImagePopup();
            //       },
            //       icon: Icon(
            //         Icons.edit,
            //         size: 40,
            //         color: Theme.of(context).accentColor,
            //       ),
            //     ),
            //   ),
            // ),
            /*Positioned(
              bottom: -sizeConfig.blockSizeHorizontal * 10,
              right: 0,
              left: 0,
              child: Container(
                height: sizeConfig.blockSizeHorizontal * 15,
                width: sizeConfig.blockSizeHorizontal * 15,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate("rank"),
                      style: TextStyle(
                        color: Constants.CANVAS_COLOR,
                        fontSize: sizeConfig.blockSizeHorizontal * 4,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: sizeConfig.blockSizeHorizontal * 20,
                      child: AutoSizeText(
                        provider.scoreModelData.rank.toString(),
                        style: TextStyle(
                            color: Constants.CANVAS_COLOR,
                            fontSize: sizeConfig.blockSizeHorizontal * 7,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Future faceBookShare() async {
    Share.share(
      AppLocalizations.of(context)!.translate(
        "invite_to_download_app",
      ),
    );
  }
}
