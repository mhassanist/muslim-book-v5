// import 'package:audio_service/audio_service.dart';
// import 'package:muslim_book/locals_utils/app_localizations.dart';
// import 'package:muslim_book/quran/models/quran_model.dart';
// import 'package:muslim_book/quran/provider/quran_provider.dart';
// import 'package:muslim_book/quran/widgets/surah_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// import 'ayat_view.dart';
//
// class SurasView extends StatefulWidget {
//   @override
//   _SurasViewState createState() => _SurasViewState();
// }
//
// class _SurasViewState extends State<SurasView> {
//   List<Surah> translationList;
//   List<Surah> transliterationList;
//
//   @override
//   void didChangeDependencies() {
//     translationList =
//         (Provider.of<QuranProvider>(context).downloadedTranslation[
//                     Provider.of<QuranProvider>(context).selectedTranslation]
//                 as QuranModel)
//             .surahs;
//     transliterationList = (Provider.of<QuranProvider>(
//       context,
//     ).downloadedTranslation[Provider.of<QuranProvider>(
//       context,
//     ).selectedTransliteration] as QuranModel)
//         .surahs;
//     super.didChangeDependencies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: AudioService.playbackStateStream,
//         builder: (context, audioSnapshot) {
//           return CustomScrollView(
//             physics: BouncingScrollPhysics(),
//             slivers: <Widget>[
//               SliverToBoxAdapter(
//                 child: StreamBuilder<QuranUserModel>(
//                     initialData:
//                         Provider.of<QuranProvider>(context).quranUserModel,
//                     stream: Provider.of<QuranProvider>(context)
//                         .quranUserModelStream,
//                     builder: (context, snapshot) {
//                       if (snapshot.data.lastReadSurahId != null &&
//                           snapshot.data.lastReadAyahId != null) {
//                         return RawMaterialButton(
//                           onPressed: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (c) => AyatView(
//                                   transliterationSurah: transliterationList ==
//                                           null
//                                       ? null
//                                       : transliterationList[
//                                           snapshot.data.lastReadSurahId - 1],
//                                   translatedSurah: translationList == null
//                                       ? null
//                                       : translationList[
//                                           snapshot.data.lastReadSurahId - 1],
//                                   index: snapshot.data.lastReadSurahId - 1,
//                                   lastAyahPosition:
//                                       snapshot.data.lastReadAyahId - 1,
//                                   surah: Provider.of<QuranProvider>(context,
//                                               listen: false)
//                                           .allSuras[
//                                       snapshot.data.lastReadSurahId - 1],
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             height: ScreenUtil().setHeight(150),
//                             decoration: BoxDecoration(
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.5),
//                                     spreadRadius: 0,
//                                     blurRadius: 5,
//                                     offset: Offset(
//                                         0, 6), // changes position of shadow
//                                   ),
//                                 ],
//                                 borderRadius: BorderRadius.circular(20),
//                                 gradient: LinearGradient(
//                                     begin: Alignment.topRight,
//                                     end: Alignment.bottomLeft,
//                                     colors: [
//                                       const Color(0XFF347D53),
//                                       const Color(0XFF6BCF96),
//                                     ])),
//                             margin: EdgeInsets.symmetric(
//                                 horizontal: ScreenUtil().setWidth(20)),
//                             child: Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Container(
//                                         margin: EdgeInsets.symmetric(
//                                             horizontal:
//                                                 ScreenUtil().setWidth(15)),
//                                         child: Text("${AppLocalizations.of(context)!.translate("last_read")}",
//                                           style:
//                                               TextStyle(color: Colors.white60),
//                                           textAlign: TextAlign.start,
//                                         ),
//                                       ),
//                                       Container(
//                                         margin: EdgeInsets.symmetric(
//                                             vertical:
//                                                 ScreenUtil().setHeight(15),
//                                             horizontal:
//                                                 ScreenUtil().setWidth(25)),
//                                         child: Text(
//                                           '${Provider.of<QuranProvider>(context).allSuras.singleWhere((element) => element.number == snapshot.data.lastReadSurahId).name}',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: ScreenUtil().setSp(23)),
//                                         ),
//                                       ),
//                                       Container(
//                                         margin: EdgeInsets.symmetric(
//                                             horizontal:
//                                                 ScreenUtil().setWidth(25)),
//                                         child: Text(
//                                           'رقم الآية : ${snapshot.data.lastReadSurahId == 1 ? snapshot.data.lastReadAyahId + 1 : snapshot.data.lastReadAyahId}',
//                                           style: TextStyle(
//                                               color: Colors.white60,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: ScreenUtil().setSp(23)),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(20),
//                                     child: Stack(
//                                       children: <Widget>[
//                                         Positioned(
//                                           right: 0,
//                                           child: Image.asset(
//                                             "assets/images/quran_view/mushaf_background.png",
//                                             fit: BoxFit.fill,
//                                           ),
//                                         ),
//                                         Positioned(
//                                           left: 0,
//                                           bottom: 0,
//                                           child: Container(
//                                             margin: EdgeInsets.only(left: 10),
//                                             child: Image.asset(
//                                               "assets/images/quran_view/mushaf.png",
//                                               fit: BoxFit.contain,
//                                               width: ScreenUtil().setWidth(150),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       } else
//                         return Container();
//                     }),
//               ),
//               SliverToBoxAdapter(
//                 child: Container(
//                   margin: EdgeInsets.symmetric(
//                       horizontal: ScreenUtil().setWidth(20),
//                       vertical: ScreenUtil().setHeight(20)),
//                   child: Text(
//                     "أسماء السور",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: ScreenUtil().setSp(25)),
//                   ),
//                 ),
//               ),
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (c, index) {
//                     return SurahWidget(
//                       playerStatus: audioSnapshot,
//                       index: index,
//                       sura: Provider.of<QuranProvider>(context).allSuras[index],
//                       translationSurah: translationList != null
//                           ? translationList[index]
//                           : null,
//                       transliterationSurah: transliterationList != null
//                           ? transliterationList[index]
//                           : null,
//                     );
//                   },
//                   childCount:
//                       Provider.of<QuranProvider>(context).allSuras.length,
//                 ),
//               ),
//             ],
//           );
//         });
//   }
//
//   Widget buildPlayerWidget(AsyncSnapshot audioSnapshot) {
//     return AnimatedPositioned(
//         duration: Duration(milliseconds: 200),
//         bottom: -200,
//         child: Container(
//           height: ScreenUtil().setHeight(50),
//           color: Theme.of(context).primaryColor,
//         ));
//   }
// }
