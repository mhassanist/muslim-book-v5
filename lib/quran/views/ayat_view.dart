import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/quran/models/quran_model.dart';
import 'package:muslim_book/quran/provider/quran_provider.dart';
import 'package:muslim_book/quran/utils/quran_audio_handler.dart';
import 'package:muslim_book/quran/widgets/ayah_widget.dart';
import 'package:muslim_book/quran/widgets/ayat_view_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AyatView extends StatefulWidget {
  final Surah surah;
  final int? index;
  final int lastAyahPosition;
  final bool? openQuran;
  final Surah? translatedSurah;
  final Surah? transliterationSurah;

  const AyatView({
    super.key,
    required this.surah,
    this.index,
    this.lastAyahPosition = 0,
    this.openQuran = false,
    this.translatedSurah,
    this.transliterationSurah,
  });

  @override
  _AyatViewState createState() => _AyatViewState();
}

class _AyatViewState extends State<AyatView> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionListener =
      ItemPositionsListener.create();
  Ayah? selectedAyah;
  DateTime startTime = DateTime.now();
  DateTime? endTime;
  // late AudioCache _audioCache;
  final player = AudioPlayer();
  QuranAudioHandler quranAudioHandler = QuranAudioHandler();

  @override
  void initState() {
    super.initState();
    player.setSource(AssetSource('audio/allah_make_you_from_heaven.wav'));
    // _audioCache = AudioCache(
    //     prefix: "audio/",
    //     fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await listenToPosition();
    // });
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     allowFontScaling: true,
    //     width: MediaQuery.of(context).size.width,
    //     height: MediaQuery.of(context).size.height);
    ScreenUtil.init(
      context,
      designSize: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
    );

    return StreamBuilder<PlaybackState>(
      stream: quranAudioHandler.audioHandler.playbackState,
      builder: (c, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        AudioProcessingState processingState =
            snapshot.data?.processingState ?? AudioProcessingState.idle;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(10)),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  constraints: BoxConstraints.expand(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            title: Row(
              children: <Widget>[
                Text(
                  "${widget.surah.name.replaceAll("سُورَةُ", "").replaceAll("سورة", "")}",
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(25)),
                ),
                Spacer(),
                Container(
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                    iconEnabledColor: Colors.white,
                    hint: Text(
                      AppLocalizations.of(context)!.translate("go_to_ayah"),
                      style: TextStyle(color: Colors.white),
                    ),
                    onChanged: (Ayah? val) async {
                      if (val != null) {
                        itemScrollController.jumpTo(
                            index: widget.surah.number == 1
                                ? val.numberInSurah - 1
                                : val.numberInSurah);
                      }
                    },
                    items: widget.surah.ayahs
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text("${e.numberInSurah}")))
                        .toList(),
                  )),
                )
              ],
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: const Color(0XFF347D53),
            actions: <Widget>[
              if (processingState != AudioProcessingState.idle &&
                  processingState != AudioProcessingState.error)
                IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () {
                      quranAudioHandler.audioHandler.stop();
                    }),
              IconButton(
                  icon: Icon(processingState == AudioProcessingState.idle ||
                          processingState == AudioProcessingState.error
                      ? Icons.headset
                      : playing
                          ? Icons.pause
                          : Icons.play_arrow),
                  onPressed: () {
                    if (processingState == AudioProcessingState.idle ||
                        processingState == AudioProcessingState.error) {
                      Provider.of<QuranProvider>(context, listen: false)
                          .startListeningToAyah(
                              surah: widget.surah, ayah: widget.surah.ayahs[0]);
                    } else {
                      if (playing) {
                        quranAudioHandler.audioHandler.pause();
                      } else
                        quranAudioHandler.audioHandler.play();
                    }
                  }),

              // PopupMenuButton<String>(
              //   onSelected: onMenuSelect,
              //   itemBuilder: (BuildContext context) {
              //     return {
              //       'Save Progress',
              //     }.map((String choice) {
              //       return PopupMenuItem<String>(
              //         value: choice,
              //         child: Text(choice),
              //       );
              //     }).toList();
              //   },
              // ),
            ],
          ),
          body: buildBody(context, snapshot),
        );
      },
    );
  }

  void onMenuSelect(String value) async {
    switch (value) {
      case 'Save Progress':
        await saveUserProgressManually();
        break;
    }
  }

  Widget buildBody(
      BuildContext context, AsyncSnapshot<PlaybackState> snapshot) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          saveLastUserProgress();
        }
        return true;
      },
      child: ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          initialScrollIndex: widget.lastAyahPosition + 1,
          itemPositionsListener: itemPositionListener,
          physics: BouncingScrollPhysics(),
          itemBuilder: (c, index) {
            if (index == 0 && widget.surah.number != 1) {
              return Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                width: double.infinity,
                child: Text(
                  "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                  style: TextStyle(
                    fontFamily: "quran",
                    fontSize: ScreenUtil().setSp(25),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (widget.index != 0) {
              index -= 1;
            }
            return InkWell(
              onLongPress: () async {
                Get.bottomSheet(AyatViewBottomSheet(
                  saveProgress: saveUserProgressManually,
                ));
              },
              child: AyahWidget(
                  transliteratedAyah: widget.transliterationSurah == null
                      ? ''
                      : widget.transliterationSurah!.ayahs[index].text,
                  translatedAyah: widget.translatedSurah == null
                      ? ''
                      : widget.translatedSurah!.ayahs[index].text,
                  listController: itemScrollController,
                  ayah: widget.surah.ayahs[index],
                  surah: widget.surah,
                  surahIndex: widget.index,
                  ayahIndex: index,
                  playerStatus: snapshot),
            );
          },
          itemCount: widget.index == 0
              ? widget.surah.ayahs.length
              : widget.surah.ayahs.length + 1),
    );
  }

  Future saveUserProgressManually() async {
    await saveLastUserProgress(override: true);
    Navigator.pop(context);
  }

  void showSnackBar(title, message) {
    Get.snackbar("$title", "$message",
        backgroundColor: Theme.of(context).primaryColor,
        maxWidth: double.infinity,
        colorText: Colors.white,
        borderRadius: 0,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(16),
        snackPosition: SnackPosition.BOTTOM);
  }

  Widget buildAyahHeader(Ayah ayatOfSura) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.reply), onPressed: () {}),
            IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
            IconButton(icon: Icon(Icons.play_circle_filled), onPressed: () {}),
            Expanded(
              child: Container(
                margin:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                child: Text(
                  "${ayatOfSura.numberInSurah}",
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future listenToPosition() async {
    itemPositionListener.itemPositions.addListener(() async {
      if (itemPositionListener.itemPositions.value.last.index > 0) {
        await Provider.of<QuranProvider>(context, listen: false)
            .changeUserProgress(widget.surah.number,
                itemPositionListener.itemPositions.value.last.index);
      }
    });
  }

  Future saveLastUserProgress({bool override = false}) async {
    if (widget.surah.progress == null ||
        override ||
        widget.surah.progress! <
            itemPositionListener.itemPositions.value.last.index) {
      await Provider.of<QuranProvider>(context, listen: false)
          .saveSurahProgress(
              widget.index,
              widget.surah.number == 1
                  ? itemPositionListener.itemPositions.value.last.index
                  : itemPositionListener.itemPositions.value.last.index - 1);
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    endTime = DateTime.now();
    if (endTime!.difference(startTime).inMinutes.abs() >= 1) {
      player.resume();
    }
  }
}
