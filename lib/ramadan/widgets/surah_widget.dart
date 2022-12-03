// import 'package:audio_service/audio_service.dart';
// import 'package:base_app/quran/models/quran_model.dart';
// import 'package:base_app/quran/provider/quran_provider.dart';
// import 'package:base_app/quran/views/ayat_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
// import 'package:flutter_screenutil/screenutil.dart';
// import 'package:provider/provider.dart';
//
// class SurahWidget extends StatefulWidget {
//   final Surah sura;
//   final int index;
//   final Surah translationSurah;
//   final Surah transliterationSurah;
//   final AsyncSnapshot<PlaybackState> playerStatus;
//
//   const SurahWidget(
//       {Key key,
//       this.sura,
//       this.index,
//       this.translationSurah,
//       this.transliterationSurah,
//       this.playerStatus})
//       : super(key: key);
//
//   @override
//   _SurahWidgetState createState() => _SurahWidgetState();
// }
//
// class _SurahWidgetState extends State<SurahWidget> {
//   bool isAyahPlaying = false;
//   Color prymaryColor = const Color(0XFF347D53);
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.index == 36)
//       widget.sura.englishNameTranslation = "The Rangers";
//     else if (widget.index == 59)
//       widget.sura.englishNameTranslation = "The Examined One";
//     return StreamBuilder<MediaItem>(
//         stream: AudioService.currentMediaItemStream,
//         builder: (context, AsyncSnapshot<MediaItem> snapshot) {
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             if (mounted && widget.playerStatus != null) {
//               setState(() {
//                 isAyahPlaying = (widget.playerStatus.data != null &&
//                     widget.playerStatus.data.playing &&
//                     snapshot.data != null &&
//                     snapshot.data.title == widget.sura.name);
//               });
//             }
//           });
//           return FlatButton(
//             padding: EdgeInsets.zero,
//             onPressed: () async {
//               await Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (c) => AyatView(
//                     translatedSurah: widget.translationSurah,
//                     transliterationSurah: widget.transliterationSurah,
//                     surah: widget.sura,
//                     index: widget.index,
//                     lastAyahPosition: widget.sura.progress,
//                   ),
//                 ),
//               );
//               setState(() {});
//             },
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   flex: 3,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Container(
//                         padding:
//                             EdgeInsets.only(top: ScreenUtil().setHeight(30)),
//                         margin: EdgeInsets.symmetric(
//                           horizontal: ScreenUtil().setWidth(30),
//                         ),
//                         child: Text(
//                           widget.sura.name
//                           // .replaceAll("سُورَةُ", "")
//                           // .replaceAll("سورة", ""),
//                           ,
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: ScreenUtil().setSp(20),
//                               fontWeight: FontWeight.bold),
//                           textAlign: TextAlign.end,
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.symmetric(
//                             vertical: ScreenUtil().setHeight(10),
//                             horizontal: ScreenUtil().setWidth(20)),
//                         child: Text(
//                           widget.sura.englishName,
//                           style: TextStyle(
//                             color: Colors.black87,
//                             fontSize: ScreenUtil().setSp(20),
//                           ),
//                           textAlign: TextAlign.end,
//                         ),
//                       ),
//                       Container(
//                         margin:
//                             EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
//                         child: RotatedBox(
//                           quarterTurns: 2,
//                           child: Container(
//                             margin: EdgeInsets.symmetric(
//                                 horizontal: ScreenUtil().setWidth(20)),
//                             child: FAProgressBar(
//                               progressColor: Theme.of(context).primaryColor,
//                               direction: Axis.horizontal,
//                               borderRadius: 20,
//                               backgroundColor: const Color(0XFFE4EEE9),
//                               maxValue: widget.sura.ayahs.length,
//                               currentValue: widget.sura.progress == null
//                                   ? 0
//                                   : widget.sura.progress + 1,
//                               size: ScreenUtil().setHeight(15),
//                               // displayText: " / ${widget.sura.ayahs.length}",
//                             ),
//                           ),
//                         ),
//                       ),
//                       Divider()
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                     flex: 2,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Expanded(
//                           child: Container(
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: AssetImage(
//                                         "assets/images/quran_view/icon_background.png"))),
//                             child: IconButton(
//                                 iconSize: ScreenUtil().setWidth(44),
//                                 icon: Icon(
//                                   isAyahPlaying ? Icons.stop : Icons.play_arrow,
//                                   color: Colors.white,
//                                   size: ScreenUtil().setWidth(30),
//                                 ),
//                                 onPressed: () async {
//                                   if (isAyahPlaying)
//                                     AudioService.stop();
//                                   else
//                                     Provider.of<QuranProvider>(context,
//                                             listen: false)
//                                         .startListeningToAyah(
//                                             surah: widget.sura,
//                                             ayah: widget.sura.ayahs[0]);
//                                 }),
//                           ),
//                         ),
//                         Expanded(
//                           child: IconButton(
//                               iconSize: ScreenUtil().setWidth(55),
//                               icon: Image.asset(
//                                 "assets/images/quran_view/mushaf_icon.png",
//                                 fit: BoxFit.fill,
//                               ),
//                               onPressed: null),
//                         ),
//                         SizedBox(
//                           width: ScreenUtil().setWidth(10),
//                         )
//                       ],
//                     )),
//               ],
//             ),
//           );
//         });
//
//     return InkWell(
//       onTap: () async {
//         await Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (c) => AyatView(
//               translatedSurah: widget.translationSurah,
//               transliterationSurah: widget.transliterationSurah,
//               surah: widget.sura,
//               index: widget.index,
//               lastAyahPosition: widget.sura.progress,
//             ),
//           ),
//         );
//         setState(() {});
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
//         child: Row(
//           children: <Widget>[
//             Container(
//               width: ScreenUtil().setWidth(50),
//               child: Text(
//                 "${widget.sura.number}",
//                 style: TextStyle(
//                   fontSize: ScreenUtil().setSp(21),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     child: Text(
//                       widget.sura.englishName,
//                       style: TextStyle(
//                           color: Theme.of(context).primaryColor,
//                           fontSize: ScreenUtil().setSp(20)),
//                       textAlign: TextAlign.start,
//                     ),
//                     width: double.infinity,
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(
//                         horizontal: ScreenUtil().setWidth(5),
//                         vertical: ScreenUtil().setHeight(5)),
//                     child: Row(
//                       children: <Widget>[
//                         Container(
//                           child: Text(
//                             widget.sura.englishNameTranslation,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.symmetric(
//                               horizontal: ScreenUtil().setWidth(5)),
//                           padding: EdgeInsets.symmetric(
//                               horizontal: ScreenUtil().setWidth(5),
//                               vertical: ScreenUtil().setWidth(2)),
//                           decoration: BoxDecoration(
//                               border: Border.all(color: Colors.black, width: 0),
//                               color: Colors.white),
//                           child: Text("${widget.sura.ayahs.length}"),
//                         )
//                       ],
//                     ),
//                   ),
//                   FAProgressBar(
//                     progressColor: Theme.of(context).primaryColor,
//                     direction: Axis.horizontal,
//                     borderRadius: 0,
//                     maxValue: widget.sura.ayahs.length,
//                     currentValue: widget.sura.progress == null
//                         ? 0
//                         : widget.sura.progress + 1,
//                     size: ScreenUtil().setHeight(15),
//                     displayText: " / ${widget.sura.ayahs.length}",
//                   )
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Container(
//                 padding:
//                     EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
//                 child: Text(
//                   widget.sura.name
//                       .replaceAll("سُورَةُ", "")
//                       .replaceAll("سورة", ""),
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontFamily: "quran",
//                       fontSize: ScreenUtil().setSp(20)),
//                   textAlign: TextAlign.end,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
