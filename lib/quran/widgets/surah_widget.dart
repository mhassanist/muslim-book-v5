import 'package:audio_service/audio_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_book/quran/models/quran_model.dart';
import 'package:muslim_book/quran/provider/quran_provider.dart';
import 'package:muslim_book/quran/utils/quran_audio_handler.dart';
import 'package:muslim_book/quran/views/ayat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:provider/provider.dart';

class SurahWidget extends StatelessWidget {
  final Surah sura;
  final int index;
  final Surah? translationSurah;
  final Surah? transliterationSurah;
  final bool isAudioPlaying;

  const SurahWidget({
    super.key,
    required this.sura,
    required this.index,
    this.translationSurah,
    this.transliterationSurah,
    required this.isAudioPlaying,
  });

  @override
  Widget build(BuildContext context) {
    QuranAudioHandler quranAudioHandler = QuranAudioHandler();

    if (index == 36)
      sura.englishNameTranslation = "The Rangers";
    else if (index == 59) sura.englishNameTranslation = "The Examined One";

    return StreamBuilder<MediaItem?>(
        stream: quranAudioHandler.audioHandler.mediaItem,
        builder: (context, snapshot) {
          bool isSurahPlaying = false;
          if (snapshot.data != null) {
            isSurahPlaying = snapshot.data!.title == sura.name && isAudioPlaying
                ? true
                : false;
          }
          return InkWell(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => AyatView(
                    translatedSurah: translationSurah,
                    transliterationSurah: transliterationSurah,
                    surah: sura,
                    index: index,
                    lastAyahPosition: sura.progress ?? 0,
                  ),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30),
                        ),
                        child: Text(
                          sura.name
                          // .replaceAll("سُورَةُ", "")
                          // .replaceAll("سورة", ""),
                          ,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(20),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(10),
                            horizontal: ScreenUtil().setWidth(20)),
                        child: Text(
                          sura.englishName,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: ScreenUtil().setSp(20),
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(20)),
                            child: FAProgressBar(
                              progressColor: Theme.of(context).primaryColor,
                              direction: Axis.horizontal,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              backgroundColor: const Color(0XFFE4EEE9),
                              maxValue: sura.ayahs.length + 0.0,
                              currentValue: sura.progress == null
                                  ? 0
                                  : (sura.progress!) + 1,
                              size: ScreenUtil().setHeight(15),
                              // displayText: " / ${widget.sura.ayahs.length}",
                            ),
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/quran_view/icon_background.png"))),
                            child: IconButton(
                                iconSize: ScreenUtil().setWidth(44),
                                icon: Icon(
                                  isSurahPlaying
                                      ? Icons.stop
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: ScreenUtil().setWidth(30),
                                ),
                                onPressed: () async {
                                  if (isSurahPlaying)
                                    quranAudioHandler.audioHandler.stop();
                                  else
                                    Provider.of<QuranProvider>(context,
                                            listen: false)
                                        .startListeningToAyah(
                                            surah: sura, ayah: sura.ayahs[0]);
                                }),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                              iconSize: ScreenUtil().setWidth(55),
                              icon: Image.asset(
                                "assets/images/quran_view/mushaf_icon.png",
                                fit: BoxFit.fill,
                              ),
                              onPressed: null),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        )
                      ],
                    )),
              ],
            ),
          );
        });
  }
}
