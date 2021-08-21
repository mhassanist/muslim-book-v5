import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/sizing_info_extension.dart';
import 'package:share/share.dart';

class ShareDialog extends StatefulWidget {
  ShareDialog({Key key}) : super(key: key);

  @override
  _ShareDialogState createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  AudioCache _audioCache;

  @override
  void initState() {
    _audioCache = AudioCache(
        prefix: "audio/",
        fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));

    _audioCache.play('share_app.wav');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(sizeConfig.blockSizeHorizontal * 5),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ClipRRect(
              borderRadius:
                  BorderRadius.circular(sizeConfig.blockSizeHorizontal * 5),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(),
                  height: sizeConfig.blockSizeHorizontal * 75,
                  width: sizeConfig.blockSizeHorizontal * 75,
                  padding: EdgeInsets.only(),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          constraints: BoxConstraints.expand(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                sizeConfig.blockSizeHorizontal * 5),
                            child: Image.asset(
                              "assets/images/onboarding/praying_man.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: sizeConfig.blockSizeVertical * 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                              AppLocalizations.of(context).translate("chairty"),
                                textAlign: TextAlign.center,
                                style: textStyle(
                                    const Color(0XFFFFAA3F),
                                    FontWeight.bold,
                                    sizeConfig.blockSizeHorizontal * 8),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: sizeConfig.blockSizeVertical * 5,
                                    horizontal:
                                        sizeConfig.blockSizeHorizontal * 15),
                                child: Text(
                                  AppLocalizations.of(context).translate("help_spearding"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          sizeConfig.blockSizeHorizontal * 4,
                                      height: 1.2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: RawMaterialButton(
                            onPressed: () async {
                              await Share.share(
                                  "ادعوكم للانضمام الي تطبيق الاذان ، القران ،الاذكار . مسلم بوك من هنا \n👇👇👇\nhttps://play.google.com/store/apps/details?id=com.muslim_book.muslim_book");
                              Navigator.pop(context);
                            },
                            padding: EdgeInsets.symmetric(
                                horizontal: sizeConfig.blockSizeHorizontal * 5,
                                vertical: sizeConfig.blockSizeVertical * 2),
                            shape: StadiumBorder(),
                            fillColor: Colors.white,
                            child: Text(
                              AppLocalizations.of(context).translate("spearding_app"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: sizeConfig.blockSizeHorizontal * 4,
                                  height: 1.2),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 32,
                          height: 32,
                          margin: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: FittedBox(
                            child: FloatingActionButton(
                              onPressed: () {
                                _audioCache.clearCache();
                                _audioCache.clear('share_app.wav');
                                Navigator.pop(context);


                                },
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.close,
                                color: Constants.PRIMARY_DARK_COLOR,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buttonsRow(SizingInformation sizeConfig, context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: RawMaterialButton(
            padding: EdgeInsets.symmetric(
                vertical: sizeConfig.blockSizeVertical * 1.5),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(sizeConfig.blockSizeVertical)),
            onPressed: () async {},
            fillColor: Theme.of(context).primaryColor,
            child: Text(
              AppLocalizations.of(context).translate("allow_for_edit_battery"),
              style: textStyle(Constants.CANVAS_COLOR, FontWeight.w700,
                  sizeConfig.blockSizeHorizontal * 4),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle textStyle(color, weight, double size) {
    return TextStyle(
        fontWeight: weight, color: color, fontFamily: "arabic", fontSize: size);
  }
}
