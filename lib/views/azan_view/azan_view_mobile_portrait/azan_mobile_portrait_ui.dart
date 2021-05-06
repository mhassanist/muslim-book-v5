import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/providers/azan_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../utils/sizing_info_extension.dart';
class AzanMobilePortraitUi {
    final AzanProvider provider;
    final SizingInformation sizeConfig;
    final BuildContext context;
    final DateFormat minuteFormat = DateFormat("mm");
    final DateFormat secondsFormat = DateFormat("ss");

    AzanMobilePortraitUi({this.provider, this.sizeConfig, this.context});


    Widget upperPart() {
        return Container(
            height: sizeConfig.blockSizeVertical * 40,
            child: Stack(
                children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/azan_view/fajr_pic.png"),
                                fit: BoxFit.cover)),
                    ),
                    Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.symmetric(
                            vertical: sizeConfig.blockSizeVertical,
                            horizontal: sizeConfig.blockSizeHorizontal * 4),
                        color: Colors.black45,
                        child: SizedBox(
                            height: sizeConfig.blockSizeVertical * 15,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                    lastForColumn(),
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: sizeConfig.blockSizeHorizontal * 5),
                                        width: 1.5,
                                        height: sizeConfig.blockSizeVertical * 7,
                                        color: Constants.CANVAS_COLOR,
                                    ),
                                    lastForTime()
                                ],
                            ),
                        )),
                ],
            ),
        );
    }

    Widget azanTimesPart() {
        return Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: sizeConfig.blockSizeHorizontal * 4),
                child: locator<Prefs>().getAssalahTime("1") == null
                    ? Container()
                    : ListView(
                    shrinkWrap: true,
                    children: provider.getAzanList().map((f) {
                        return azanItem(f);
                    }).toList(),
                ),
            ),
        );
    }

    Widget azanItem(Map<String, String> map) {
        return Column(
            children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 400),
                childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 100,
                    child: widget,
                ),
                children: <Widget>[
                    Row(
                        children: <Widget>[
                            SvgPicture.asset(
                                "${map["icon"]}",
                                width: map["isha"] == null
                                    ? sizeConfig.blockSizeHorizontal * 6
                                    : sizeConfig.blockSizeHorizontal * 4,
                            ),
                            Expanded(
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: map["isha"] == null
                                            ? sizeConfig.blockSizeHorizontal * 3
                                            : sizeConfig.blockSizeHorizontal * 5),
                                    child: Text(
                                        "${map["title"]}",
                                        style: textStyle(),
                                    ),
                                )),
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: sizeConfig.blockSizeHorizontal * 2),
                                    child: Text(
                                        "${map["time"]}",
                                        textAlign: TextAlign.end,
                                        style: textStyle(),
                                    ),
                                ),
                            ),
                            Expanded(
                                child: Text(
                                    "${int.parse(map["hours"]) >= 12 ? AppLocalizations.of(context).translate("evening") : AppLocalizations.of(context).translate("morning")}",
                                    style: textStyle(),
                                    textAlign: TextAlign.center,
                                ),
                            )
                        ],
                    ),
                    Container(
                        height: map["isha"] == null ? .7 : 0,
                        margin: EdgeInsets.symmetric(
                            vertical: sizeConfig.blockSizeVertical * 2),
                        color: Constants.ACCENT_COLOR,
                    )
                ]),
        );
    }

    TextStyle textStyle() {
        return TextStyle(
            fontSize: sizeConfig.blockSizeHorizontal * 5,
            fontWeight: FontWeight.w700,
            color: Colors.black87);
    }

    Widget lastForColumn() {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Text(
                    AppLocalizations.of(context).translate("last_for"),
                    style: upperTextStyle(
                        sizeConfig.blockSizeHorizontal * 5, FontWeight.w700),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: sizeConfig.blockSizeVertical),
                    child: Text(
                        provider.getAzanByIndex(context)[provider.nextAzanKey],
                        style: upperTextStyle(
                            sizeConfig.blockSizeHorizontal * 7, FontWeight.w900),
                    ),
                )
            ],
        );
    }

    TextStyle upperTextStyle(double size, FontWeight fontWeight) {
        return TextStyle(
            fontWeight: fontWeight, fontSize: size, color: Constants.CANVAS_COLOR);
    }

    Widget lastForTime() {
        return Row(
            children: <Widget>[
                timeColumn(
                    AppLocalizations.of(context).translate("seconds"),
                    secondsFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(
                            provider.remaining.inMilliseconds),
                    ),
                ),
                timeColumn(
                    AppLocalizations.of(context).translate("minutes"),
                    minuteFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(
                            provider.remaining.inMilliseconds),
                    ),
                ),
                timeColumn(
                    AppLocalizations.of(context).translate("hours"),
                    provider.remaining.inHours < 10
                        ? "0${provider.remaining.inHours}"
                        : "${provider.remaining.inHours}"),
            ],
        );
    }

    Widget timeColumn(String title, String time) {
        return Container(
            margin:
            EdgeInsets.symmetric(horizontal: sizeConfig.blockSizeHorizontal * 2),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Text(
                        title,
                        style: upperTextStyle(
                            sizeConfig.blockSizeHorizontal * 5, FontWeight.w700),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 3),
                        child: Text("$time",
                            style: upperTextStyle(
                                sizeConfig.blockSizeHorizontal * 8, FontWeight.w900)),
                    ),
                ],
            ),
        );
    }
}

// "