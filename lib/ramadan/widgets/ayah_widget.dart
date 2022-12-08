import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/quran/models/quran_model.dart';
import 'package:muslim_book/quran/provider/quran_provider.dart';
import 'package:muslim_book/quran/views/ayat_view.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:scrollable_positioned_list/src/scrollable_positioned_list.dart';
import 'package:share_extend/share_extend.dart';

class BuildAyahWidget extends StatefulWidget {
  final Surah surah;
  final String translatedAyah;
  final String transliteratedAyah;
  final Ayah ayah;
  final surahIndex;
  final ayahIndex;
  final ItemScrollController listController;
  final AsyncSnapshot<PlaybackState> playerStatus;
  const BuildAyahWidget({
    super.key,
    required this.surah,
    required this.ayah,
    required this.surahIndex,
    required this.ayahIndex,
    required this.listController,
    required this.translatedAyah,
    required this.transliteratedAyah,
    required this.playerStatus,
  });

  @override
  _BuildAyahWidgetState createState() => _BuildAyahWidgetState();
}

class _BuildAyahWidgetState extends State<BuildAyahWidget> {
  ScreenshotController screenshotController = ScreenshotController();
  Color prymaryColor = const Color(0XFF347D53);
  bool showAyahSuraPosition = false;
  bool isAyahPlaying = false;
  @override
  Widget build(BuildContext context) {
    if (widget.surah.number != 1 && widget.ayah.numberInSurah == 1) {
      widget.ayah.text = widget.ayah.text.split("لرَّحِيمِ").last;
    }
    return StreamBuilder<MediaItem>(
        stream: AudioService.currentMediaItemStream,
        builder: (context, AsyncSnapshot<MediaItem> snapshot) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (widget.playerStatus.data != null &&
                widget.playerStatus.data!.playing &&
                snapshot.data != null) {
              if ((snapshot.data!.extras as Map)["surahIndex"] == widget.surahIndex) {
                jumpToNextAyah(snapshot);
              } else if ((snapshot.data!.extras as Map)["renewSurah"] == 1) {
                renewSurasView(context, snapshot);
              }
            }
            if (mounted && widget.playerStatus != null) {
              setState(() {
                isAyahPlaying = (widget.playerStatus.data != null &&
                    widget.playerStatus.data!.playing &&
                    snapshot.data != null &&
                    (int.parse(snapshot.data!.id) == widget.ayahIndex &&
                        snapshot.data!.title == widget.surah.name));
              });
            }
          });

          return Container(
            color: isAyahPlaying ? Colors.yellow[100] : Colors.white,
            child: Column(
              children: <Widget>[
                if ((isNewJuz(context)))
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(7),
                        horizontal: ScreenUtil().setWidth(20)),
                    width: double.infinity,
                    color: Theme.of(context).primaryColor.withOpacity(.9),
                    child: Text(

                      "${AppLocalizations.of(context)!.translate("part_no")} ${widget.ayah.juz}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(20)),
                    ),
                  ),
                Screenshot(
                  controller: screenshotController,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(13),
                        vertical: ScreenUtil().setHeight(5)),
                    child: Column(
                      children: <Widget>[
                        Container(
                          color:
                              isAyahPlaying ? Colors.yellow[100] : Colors.white,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(10)),
                          child: Text(
                            "${widget.ayah.text}",
                            style: TextStyle(
                              fontFamily: "quran",
                              color:
                                  isAyahPlaying ? prymaryColor : Colors.black,
                              height: 1.9,
                              fontWeight: FontWeight.normal,
                              fontSize: ScreenUtil().setSp(25),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        if (Provider.of<QuranProvider>(context)
                            .allowTransliteration)
                          Container(
                            color: isAyahPlaying
                                ? Colors.yellow[100]
                                : Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(18)),
                            width: double.infinity,
                            child: Text(
                              "${widget.transliteratedAyah}",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: ScreenUtil().setSp(16),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        if (Provider.of<QuranProvider>(context)
                            .allowTranslation)
                          Container(
                            color: isAyahPlaying
                                ? Colors.yellow[100]
                                : Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(18)),
                            width: double.infinity,
                            child: Text(
                              "${widget.translatedAyah}",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(16),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        if (showAyahSuraPosition)
                          Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(18),
                                horizontal: ScreenUtil().setWidth(18)),
                            width: double.infinity,
                            child: Text(
                              "القرآن الكريم ${widget.surahIndex + 1}:${widget.ayahIndex + 1} ",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                buildAyahHeader(widget.ayah, isAyahPlaying),
              ],
            ),
          );
        });
  }

  void jumpToNextAyah(AsyncSnapshot<MediaItem> snapshot) {
    widget.listController.jumpTo(
      index: widget.surah.number == 1
          ? int.parse("${snapshot.data!.id}")
          : int.parse(snapshot.data!.id) > 3
              ? int.parse("${snapshot.data!.id}") + 1
              : int.parse("${snapshot.data!.id}"),
    );
  }

  void renewSurasView(BuildContext context, AsyncSnapshot<MediaItem> snapshot) {
    Surah translatedNextSurah;
    Surah transliterationNextSurah;
    if (Provider.of<QuranProvider>(context, listen: false).allowTranslation) {
      translatedNextSurah = (Provider.of<QuranProvider>(context, listen: false)
                  .downloadedTranslation[
              Provider.of<QuranProvider>(context, listen: false)
                  .selectedTranslation] as QuranModel)
          .surahs[(snapshot.data!.extras as Map)["surahIndex"]];
    }
    if (Provider.of<QuranProvider>(context, listen: false).allowTransliteration)
      transliterationNextSurah =
          (Provider.of<QuranProvider>(context, listen: false)
                      .downloadedTranslation[
                  Provider.of<QuranProvider>(context, listen: false)
                      .selectedTransliteration] as QuranModel)
              .surahs[(snapshot.data!.extras as Map)["surahIndex"]];
    super.didChangeDependencies();

    Surah nextSurah = Provider.of<QuranProvider>(context, listen: false)
        .allSuras[(snapshot.data!.extras as Map)["surahIndex"]];
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => AyatView(
          translatedSurah: translatedNextSurah,
          transliterationSurah: transliterationNextSurah,
          surah: nextSurah,
          index: (snapshot.data!.extras as Map)["surahIndex"],
          lastAyahPosition: nextSurah.progress,
          openQuran: true,
        ),
      ),
    );
  }

  bool isNewJuz(BuildContext context) {
    if (widget.surah.number == 1 && widget.ayah.numberInSurah == 1) {
      return true;
    } else if (widget.ayah.numberInSurah == 1) {
      return widget.ayah.juz !=
          Provider.of<QuranProvider>(context, listen: false)
              .allSuras[widget.surahIndex - 1]
              .ayahs
              .last
              .juz;
    } else
      return widget.ayah.juz != widget.surah.ayahs[widget.ayahIndex - 1].juz;
  }

  Widget buildAyahHeader(Ayah ayah, bool isAyahPlaying) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0XFFF4F8F6),
          borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(5),
          vertical: ScreenUtil().setHeight(10)),
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(10),
          vertical: ScreenUtil().setHeight(10)),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(
                FontAwesomeIcons.share,
                size: ScreenUtil().setWidth(20),
                color: prymaryColor,
              ),
              onPressed: () async {
                await shareAyah();
              }),
          IconButton(
              icon: Icon(
                isAyahPlaying ? Icons.pause : Icons.play_circle_filled,
                size: ScreenUtil().setWidth(30),
                color: prymaryColor,
              ),
              onPressed: () {
                if (isAyahPlaying) {
                  AudioService.pause();
                } else
                  Provider.of<QuranProvider>(context, listen: false)
                      .startListeningToAyah(
                          surah: widget.surah, ayah: widget.ayah);
              }),
          Spacer(),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
            child: Text(
              "${widget.ayah.numberInSurah}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: prymaryColor,
                  fontSize: ScreenUtil().setSp(20),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future shareAyah() async {
    setState(() {
      showAyahSuraPosition = true;
    });
    File screenShot = await screenshotController.capture();
    ShareExtend.share(
      screenShot.path,
      "image",
    );

    setState(() {
      showAyahSuraPosition = false;
    });
  }
}
