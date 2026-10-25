import 'dart:ui';

// import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:muslim_book/ads/ad_manager.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/network_utils/remote_config.dart';
import 'package:muslim_book/providers/competition_provider.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/widgets/standardButton_widget.dart';
// import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share/share.dart';

import '../../../models/competitions_model.dart';
import '../../../utils/sizing_info_extension.dart';

class CompetitionUI {
  late CompetitionProvider provider;
  late SizingInformation sizeConfig;
  BuildContext context;
  late String facebookAdsId;

  CompetitionUI(
    this.context,
  ) {
    provider = Provider.of<CompetitionProvider>(context);
  }

  String formatHHMMSS(int seconds) {
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  Widget questions() {
    int totalQuestions = provider.totalQuestions;
    int answeredQuestions = provider.questionIndex + 1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: sizeConfig.blockSizeVertical * 5,
          width: sizeConfig.blockSizeHorizontal * 70,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '$answeredQuestions / $totalQuestions ' +
                        AppLocalizations.of(context)!.translate("questions"),
                    style: TextStyle(
                        fontSize: sizeConfig.blockSizeHorizontal * 4,
                        color: Constants.CANVAS_COLOR),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.comment,
                    size: sizeConfig.blockSizeHorizontal * 4,
                    color: Constants.CANVAS_COLOR,
                  )
                ],
              ),
              Container(
                height: sizeConfig.blockSizeVertical * 4,
                width: 2,
                color: Constants.CANVAS_COLOR,
              ),
              Row(
                children: <Widget>[
                  Text(
                    formatHHMMSS(provider.current),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: sizeConfig.blockSizeHorizontal * 6,
                        color: Constants.CANVAS_COLOR),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.timer,
                    size: sizeConfig.blockSizeHorizontal * 6,
                    color: Constants.CANVAS_COLOR,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget questionText() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.all(10),
      width: sizeConfig.blockSizeHorizontal * 80,
      height: sizeConfig.blockSizeVertical * 15,
      // margin: EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              provider.questions[provider.questionIndex].question ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: sizeConfig.blockSizeHorizontal * 5,
                  color: Constants.CANVAS_COLOR),
              maxLines: 4,
              textAlign: TextAlign.center,
            ),
          ),
          SvgPicture.asset(
            "assets/images/start_view/quizes_icon.svg",
            width: sizeConfig.blockSizeHorizontal * 15,
            color: Constants.CANVAS_COLOR,
          ),
        ],
      ),
    );
  }

  Widget answers() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: provider.questions[provider.questionIndex].answers.length,
        itemBuilder: (context, index) {
          AnswerModel answerModel =
              provider.questions[provider.questionIndex].answers[index];
          return answer(answerModel, index, () async {
            if (provider.current != 0) {
              provider.disablePickingAnswers = true;
              provider.isAnsweredClicked = true;
              provider.chosenPosition = index;
              provider.stopTimer();
              provider.setAnswerId = provider
                      .questions[provider.questionIndex].answers[index].id ??
                  -1;
              provider.postAnswer();
            }
          });
        });
  }

  Color? getColor(position, result) {
    if (provider.chosenPosition == null) {
      return Colors.grey[300];
    } else if (result == 1) {
      return Colors.green;
    } else if (provider.chosenPosition != null &&
        provider.chosenPosition == position &&
        result == 0) {
      return Colors.red;
    }

    return Colors.grey[300];
  }

  Widget answer(AnswerModel answer, int index, Function? onPressed) {
    if (answer.result == 1) {
      provider.correctAnswerPosition = index;
    }
    return Container(
      margin: EdgeInsets.only(
        top: sizeConfig.blockSizeHorizontal * 2,
        left: sizeConfig.blockSizeHorizontal * 10,
        right: sizeConfig.blockSizeHorizontal * 10,
      ),
      height: sizeConfig.blockSizeVertical * 6,
      //width: sizeConfig.blockSizeHorizontal * 60,
      child: IgnorePointer(
        ignoring: provider.disablePickingAnswers,
        child: MaterialButton(
          elevation: 4,
          color: getColor(index, answer.result),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () => onPressed?.call(),
          child: Text(
            "${answer.answers}",
            style: TextStyle(
                color: Colors.black,
                fontSize: sizeConfig.blockSizeHorizontal * 4,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget continueButton() {
    int answeredQuestions = provider.questionIndex + 1;
    if (answeredQuestions == provider.questions.length &&
        provider.current == 0) {
      return standardButton(
          isGo: true,
          context: context,
          sizeConfig: sizeConfig,
          color: Theme.of(context).primaryColor,
          title: AppLocalizations.of(context)!.translate("done"),
          onPressed: () async {
            await endPopUp();
            provider.playAllQuestionsEndVoice();
          });
    } else {
      return Container(
        alignment: Alignment.center,
        child: AnimatedCrossFade(
            firstChild: standardButton(
                isGo: true,
                context: context,
                sizeConfig: sizeConfig,
                color: provider.disablePickingAnswers || provider.current == 0
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                title: provider.disablePickingAnswers || provider.current == 0
                    ? AppLocalizations.of(context)!.translate("next_question")
                    : AppLocalizations.of(context)!
                        .translate("choose_correct_answer"),
                onPressed: provider.disablePickingAnswers ||
                        provider.current == 0
                    ? () async {
                        provider.startTimer();
                        await provider.changeIndex();
                        // }
                      }
                    : null),
            secondChild: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: sizeConfig.blockSizeVertical * 4),
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Constants.PRIMARY_DARK_COLOR),
              ),
            ),
            crossFadeState: provider.viewState == ViewState.Loading
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: kThemeChangeDuration),
      );
    }
  }

  startPopUp() {
    String totalQuestions = provider.totalQuestions.toString();
    Get.dialog(PopScope(
        canPop: false,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: sizeConfig.blockSizeHorizontal * 2),
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => goToStart(context),
                  child: Text(
                    AppLocalizations.of(context)!.translate("skip"),
                    style: TextStyle(
                      fontSize: sizeConfig.blockSizeHorizontal * 4,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset(
                  "assets/images/general/logo.png",
                  height: sizeConfig.blockSizeVertical * 20,
                  //color: Theme.of(context).primaryColor,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: sizeConfig.blockSizeHorizontal * 2),
                  child: Text(
                    "${AppLocalizations.of(context)!.translate("you_have")} $totalQuestions ${AppLocalizations.of(context)!.translate("questions_to_answer")}",
                    style: TextStyle(
                      fontSize: sizeConfig.blockSizeHorizontal * 6,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    textAlign: TextAlign.center,
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    AppLocalizations.of(context)!.translate("you_will_start"),
                    style:
                        TextStyle(fontSize: sizeConfig.blockSizeHorizontal * 4),
                    textAlign: TextAlign.center,
                  )),
              // Expanded(
              //   flex: 1,
              //   child: Container(
              //     height: 200,
              //        child: AdMobRectangle(BannerName.DownStartCompetition)),
              // ),

              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20, top: 5),
                child: Container(
                  width: sizeConfig.blockSizeHorizontal * 30,
                  height: sizeConfig.blockSizeVertical * 6,
                  margin: EdgeInsets.only(bottom: 5),
                  child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(sizeConfig.blockSizeVertical),
                    ),
                    onPressed: () {
                      provider.startTimer();
                      Navigator.pop(context);
                    },
                    fillColor: Theme.of(context).primaryColor,
                    child: Text(
                      AppLocalizations.of(context)!.translate("start_now"),
                      style: TextStyle(
                        fontSize: sizeConfig.blockSizeHorizontal * 6,
                        color: Constants.CANVAS_COLOR,
                      ),
                      // textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              /// TODO: Aslan change ad to gms ads
              faceBookAdsWidget(
                  locator<RemoteConfigService>().underStartCompetitionAdsId),
            ],
          ),
        )));
  }

  endPopUp() async {
    Get.dialog(PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 8),
              child: Text(
                "أحسنت",
                style: TextStyle(
                    fontSize: sizeConfig.blockSizeHorizontal * 8,
                    color: Constants.PRIMARY_COLOR,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: sizeConfig.blockSizeVertical * 4),
              child: GestureDetector(
                onTap: () => goToStart(context),
                child: Text(
                  "لقد إجتزت المسابقة بنجاح",
                  style: TextStyle(
                    fontSize: sizeConfig.blockSizeHorizontal * 5,
                    color: Constants.PRIMARY_COLOR,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: sizeConfig.blockSizeHorizontal * 60,
              alignment: Alignment.center,
              child: RawMaterialButton(
                onPressed: () {
                  Share.share(
                      /*AppLocalizations.of(context)!.translate("i_have_won") +
                          '${provider.scoreModelData.points} ' +
                          AppLocalizations.of(context)
                              .translate("points_in_Muslim-Book_competition") +
                          ' ' +*/
                      AppLocalizations.of(context)!.translate("i_have_won") +
                          AppLocalizations.of(context)!
                              .translate("in_Muslim-Book_competition") +
                          ' ' +
                          AppLocalizations.of(context)!
                              .translate("invite_to_download_app"));
                },
                padding: EdgeInsets.symmetric(
                    vertical: sizeConfig.blockSizeVertical * 2,
                    horizontal: sizeConfig.blockSizeHorizontal * 6),
                shape: StadiumBorder(),
                fillColor: const Color(0XFF2E6E49),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "شارك النتيجة",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: sizeConfig.blockSizeHorizontal * 6),
                    ),
                    SizedBox(
                      width: sizeConfig.blockSizeHorizontal * 4,
                    ),
                    Icon(
                      Icons.share,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Image.asset(
                "assets/images/competition_view/prize.png",
                fit: BoxFit.fill,

                // color: Theme.of(context).primaryColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: sizeConfig.blockSizeVertical * 10,
                  left: sizeConfig.blockSizeHorizontal * 5,
                  right: sizeConfig.blockSizeHorizontal * 5),
              child: Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      padding: EdgeInsets.symmetric(
                        vertical: sizeConfig.blockSizeVertical * 2,
                      ),
                      shape: StadiumBorder(),
                      fillColor: Colors.white,
                      onPressed: () async {
                        provider.showInterstitialAd();
                        goToStart(context, pageNumber: 3);
                      },
                      child: Text(
                        "إعادة المسابقة",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constants.PRIMARY_DARK_COLOR,
                            fontSize: sizeConfig.blockSizeHorizontal * 5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sizeConfig.blockSizeHorizontal * 2,
                  ),
                  Expanded(
                    child: MaterialButton(
                      padding: EdgeInsets.symmetric(
                        vertical: sizeConfig.blockSizeVertical * 2,
                      ),
                      onPressed: () {
                        provider.showInterstitialAd();
                        goToStart(context);
                      },
                      child: Text(
                        "العودة للرئيسية",
                        style: TextStyle(
                            color: Constants.PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                            fontSize: sizeConfig.blockSizeHorizontal * 5),
                      ),
                    ),
                  )
                ],
              ),
            )
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            //   child: Text(
            //     AppLocalizations.of(context)!.translate("you_have_won"),
            //     style: TextStyle(
            //       fontSize: sizeConfig.blockSizeHorizontal * 5,
            //       color: Theme.of(context).primaryColorDark,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            //   child: Text(
            //     "asdsad",
            //     // '${provider.scoreModelData.points}  ${AppLocalizations.of(context)!.translate("points")}',
            //     style: TextStyle(
            //       fontSize: sizeConfig.blockSizeHorizontal * 5,
            //       color: Theme.of(context).primaryColor,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            //   child: Text(
            //     'asd',

            //     // '${AppLocalizations.of(context)!.translate("right_answers_are")} : ${provider.scoreModelData.correctAnswer} \n ${AppLocalizations.of(context)!.translate("wrong_answers_are")} : ${provider.scoreModelData.wrongAnswer}',
            //     style: TextStyle(fontSize: sizeConfig.blockSizeHorizontal * 4),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            //   child: Text(
            //     'asds',

            //     // '${AppLocalizations.of(context)!.translate("your_rank_is")} \n ${provider.scoreModelData.rank}',
            //     style: TextStyle(
            //       fontSize: sizeConfig.blockSizeHorizontal * 5,
            //       color: Theme.of(context).primaryColor,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            //   child: Text(
            //     '${AppLocalizations.of(context)!.translate("share_your_rank")}',
            //     style: TextStyle(fontSize: sizeConfig.blockSizeHorizontal * 4),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Container(
            //       width: sizeConfig.blockSizeHorizontal * 30,
            //       height: sizeConfig.blockSizeVertical * 6,
            //       margin: EdgeInsets.only(top: 20, bottom: 20),
            //       decoration:
            //           BoxDecoration(borderRadius: BorderRadius.circular(10)),
            //       child: RawMaterialButton(
            //         shape: RoundedRectangleBorder(
            //           borderRadius:
            //               BorderRadius.circular(sizeConfig.blockSizeVertical),
            //         ),
            //         onPressed: () {
            //           Share.share(AppLocalizations.of(context)
            //                   .translate("i_have_won") +
            //               '${provider.scoreModelData.points} ' +
            //               AppLocalizations.of(context)
            //                   .translate("points_in_Muslim-Book_competition") +
            //               ' ' +
            //               AppLocalizations.of(context)
            //                   .translate("invite_to_download_app"));
            //         },
            //         fillColor: Theme.of(context).primaryColor,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
            //           children: <Widget>[
            //             Text(
            //               AppLocalizations.of(context)!.translate("share"),
            //               style: TextStyle(
            //                 fontSize: sizeConfig.blockSizeHorizontal * 6,
            //                 color: Constants.CANVAS_COLOR,
            //               ),
            //             ),
            //             Icon(
            //               Icons.share,
            //               color: Constants.CANVAS_COLOR,
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    ));
  }

  void goToStart(BuildContext context, {int pageNumber = 2}) {
    Navigator.pop(context);
    Provider.of<UserProvider>(context, listen: false).selectedPage = pageNumber;
    Navigator.pushReplacementNamed(context, "/start_view");
  }

  Widget faceBookAdsWidget(id) {
    return Container();
    // if (locator<RemoteConfigService>().showFacebookInterstitial) {
    //   return BannerAd(
    //     // placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047",
    //     placementId: id,
    //     bannerSize: BannerSize.MEDIUM_RECTANGLE,
    //     // listener: (result, value) {
    //     //   switch (result) {
    //     //     case BannerAdResult.ERROR:
    //     //       print("FaceBookError: $value");
    //     //       break;
    //     //     case BannerAdResult.LOADED:
    //     //       break;
    //     //     case BannerAdResult.CLICKED:
    //     //       break;
    //     //     case BannerAdResult.LOGGING_IMPRESSION:
    //     //       break;
    //     //   }
    //     // },
    //   );
    // } else {
    //   return Container();
    // }
  }

  Widget buildNoMoreQuestions() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            "assets/images/start_view/quizes_icon.svg",
            width: sizeConfig.blockSizeVertical * 40,
            color: Theme.of(context).primaryColorDark,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: sizeConfig.blockSizeVertical * 2,
                bottom: sizeConfig.blockSizeVertical * 10,
                left: sizeConfig.blockSizeVertical * 2,
                right: sizeConfig.blockSizeVertical * 2),
            child: Text(
              AppLocalizations.of(context)!
                  .translate("no_more_questions_come_back_later"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: sizeConfig.blockSizeHorizontal * 5.5),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.translate("share_competition"),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: sizeConfig.blockSizeHorizontal * 5.5),
          ),
          Container(
            margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 2),
            width: sizeConfig.blockSizeHorizontal * 50,
            child: RawMaterialButton(
              padding: EdgeInsets.symmetric(
                  vertical: sizeConfig.blockSizeVertical,
                  horizontal: sizeConfig.blockSizeHorizontal * 2),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(sizeConfig.blockSizeVertical),
              ),
              onPressed: () {
                Share.share(AppLocalizations.of(context)!
                    .translate("invite_to_download_app"));
              },
              fillColor: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.translate("share"),
                    style: TextStyle(
                      fontSize: sizeConfig.blockSizeHorizontal * 6,
                      color: Constants.CANVAS_COLOR,
                    ),
                  ),
                  Icon(
                    Icons.share,
                    color: Constants.CANVAS_COLOR,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
