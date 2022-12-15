// import 'package:audio_service/audio_service.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:muslim_book/ads/admob_rectangle.dart';
// import 'package:muslim_book/enums/view_state_enum.dart';
// import 'package:muslim_book/local_storage/local_storage_manager.dart';
// import 'package:muslim_book/locals_utils/app_localizations.dart';
// import 'package:muslim_book/models/banner_names_enum.dart';
// import 'package:muslim_book/network_utils/remote_config.dart';
// import 'package:muslim_book/ramadan/models/ramadan_cannon_model.dart';
// import 'package:muslim_book/ramadan/models/ramadan_data.dart';
// import 'package:muslim_book/ramadan/provider/ramadan_provider.dart';
// import 'package:muslim_book/ramadan/utils/helper_methods.dart';
// import 'package:muslim_book/ramadan/views/ramadan_mobile_portrait_ui.dart';
// import 'package:muslim_book/utils/Constants.dart';
// import 'package:muslim_book/utils/expand_widget/custom_expansion_tile.dart';
// import 'package:muslim_book/utils/expand_widget/custom_expansion_tile2.dart';
// import 'package:muslim_book/utils/locator.dart';
// import 'package:muslim_book/utils/prefs.dart';
// import 'package:muslim_book/utils/time_ui/analog_time_picker.dart';
// import 'package:muslim_book/widgets/base_widget.dart';
// import 'package:muslim_book/widgets/share_dialog.dart';
// import 'package:facebook_audience_network/ad/ad_interstitial.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:loading/indicator/ball_beat_indicator.dart';
// import 'package:loading/loading.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';
//
// class RamadanView extends StatefulWidget {
//   @override
//   _RamadanViewState createState() => _RamadanViewState();
// }
//
// class _RamadanViewState extends State<RamadanView>
//     with TickerProviderStateMixin {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   Map<String, DateTime> _dateTime = new Map();
//   final Color prymaryColor = const Color(0XFF347D53);
//   RamadanMobilePortraitUi ui;
//   bool _isSaveing = false;
//
//   RamadanProvider _ramadanProvider; //from web or local database
//   AudioPlayer audioPlayer = AudioPlayer();
//   List<AnimationController> animationList = [];
//   List<AnimationController> animationListWeb = [];
//   String currentPlayingItemId;
//   bool displayingFromAssets = false;
//   bool screenNoLongerActive = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     animationList.forEach((f) {
//       f.dispose();
//     });
//
//     animationListWeb.forEach((f) {
//       f.dispose();
//     });
//
//     try {
//       audioPlayer.stop();
//     } catch (e) {}
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _ramadanProvider = Provider.of<RamadanProvider>(context);
//
//     ScreenUtil.init(context,
//         allowFontScaling: true,
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height);
//     return WillPopScope(
//       onWillPop: () async {
//         screenNoLongerActive = true;
//         try {
//           audioPlayer.stop();
//         } catch (e) {}
//         Navigator.of(context).pop();
//         return false;
//       },
//       child: BaseView<RamadanProvider>(onModelReady: (model) {
//         ui = RamadanMobilePortraitUi(
//           context: context,
//           provider: _ramadanProvider,
//         );
//         ui.provider.context = context;
//         ui.provider.fillTheSettingsData();
//       }, builder: (_, model, __) {
//         return AudioServiceWidget(
//             child: Scaffold(
//           key: _scaffoldKey,
//           appBar: AppBar(
//               elevation: 0,
//               title: Text(
//                 "رمضان",
//                 style: GoogleFonts.almarai(
//                   fontSize: ScreenUtil().setSp(25),
//                   color: Constants.PRIMARY_DARK_COLOR,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               iconTheme: IconThemeData(
//                 color: Theme.of(context).primaryColor,
//               ),
//               actions: <Widget>[
//                 InkWell(
//                     onTap: () {
//                       Get.dialog(ShareDialog());
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 5),
//                       child: Icon(Icons.share),
//                     )),
//                 Container(
//                   width: 10,
//                 )
//               ],
//               backgroundColor: Colors.white),
//           body: ResponsiveBuilder(builder: (context, sizeConfig) {
//             return FutureBuilder(
//               future: LocalStorageManager.storage.ready,
//               builder: (BuildContext context, snapshot) {
//                 if (snapshot.data == true) {
//                   //local storage ready
//                   return ((model).viewState == ViewState.Loading)
//                       ? Container(
//                           width: double.infinity,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircularProgressIndicator(
//                                 valueColor: new AlwaysStoppedAnimation<Color>(
//                                     prymaryColor),
//                               ),
//                             ],
//                           ),
//                         )
//                       : Stack(children: <Widget>[
//                           Positioned.fill(child: getHomeBody(model, context)),
//                           Positioned.fill(
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Container(
//                                 // margin: EdgeInsets.only(top: 100),
//                                 child: Visibility(
//                                   visible: _isSaveing,
//                                   child: Loading(
//                                     indicator: BallBeatIndicator(),
//                                     size: 70.0,
//                                     color: Constants.PRIMARY_DARK_COLOR,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ]);
//                 } else {
//                   return Container();
//                 }
//               },
//             );
//           }),
//           backgroundColor: Colors.white,
//         ));
//       }),
//     );
//   }
//
//   _buildConnanList(
//       String azanId, RamadanProvider ramadanProvider, BuildContext context) {
//     screenNoLongerActive = false;
//
//     if (_ramadanProvider.loadedCannonState == DataLoadingState.notLoaded) {
//       _ramadanProvider.checkForCannonLocal(azanId);
//       return Container();
//     } else if (_ramadanProvider.loadedCannonState ==
//             DataLoadingState.localAvailable ||
//         _ramadanProvider.loadedCannonState ==
//             DataLoadingState.canBeLoadedFromLocal) {
//       if (_ramadanProvider.ramadanCannonModel == null ||
//           _ramadanProvider.ramadanCannonModel.length == 0) {
//         _ramadanProvider.loadConnanSounds();
//       }
//       displayingFromAssets = false;
//       _ramadanProvider.loadCannonSelection();
//       _ramadanProvider.ramadanCannonModel?.forEach((f) {
//         animationListWeb.add(AnimationController(
//             vsync: this, duration: Duration(milliseconds: 300)));
//       });
//
//       if (_ramadanProvider.ramadanCannonModel != null) {
//         return getConnan(ramadanProvider, context);
//       } else {
//         return Container();
//       }
//     }
//   }
//
//   _buildMashraatList(
//       String azanId, RamadanProvider ramadanProvider, BuildContext context) {
//     screenNoLongerActive = false;
//     if (_ramadanProvider.loadedMashraatState == DataLoadingState.notLoaded) {
//       _ramadanProvider.checkForMashraatLocal(azanId);
//       return Container();
//     } else if (_ramadanProvider.loadedMashraatState ==
//             DataLoadingState.localAvailable ||
//         _ramadanProvider.loadedMashraatState ==
//             DataLoadingState.canBeLoadedFromLocal) {
//       if (_ramadanProvider.ramadanMashraatModel == null ||
//           _ramadanProvider.ramadanMashraatModel.length == 0) {
//         _ramadanProvider.loadMashraatSounds();
//       }
//       displayingFromAssets = false;
//
//       _ramadanProvider.ramadanMashraatModel?.forEach((f) {
//         animationListWeb.add(AnimationController(
//             vsync: this, duration: Duration(milliseconds: 300)));
//       });
//       _ramadanProvider.loadMshartSelection();
//       if (_ramadanProvider.ramadanMashraatModel != null) {
//         return getMashraat(ramadanProvider, context);
//       } else {
//         return Container();
//       }
//     }
//   }
//
//   getMashraat(RamadanProvider ramadanProvider, BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       padding: EdgeInsets.only(top: 10, bottom: 8, right: 10, left: 10),
//       decoration: new BoxDecoration(
//           color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
//           borderRadius: BorderRadius.circular(8.0),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.grey[300],
//                 blurRadius: 10.0,
//                 // has the effect of softening the shadow
//                 spreadRadius: 2.0,
//                 // has the effect of extending the shadow
//                 offset: Offset(
//                   0, // horizontal, move right 10
//                   3, // vertical, move down 10
//                 )),
//           ]),
//       child: CustomExpansionTileTwo(
//         trailing: Container(
//             child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           //Center Column contents vertically,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           //Center Column contents horizontally,
//
//           children: [
//             SvgPicture.asset(
//               "assets/images/ramadan_view"
//               "/drum.svg",
//               width: 20,
//               // fit: BoxFit.cover,
//               color: Constants.PRIMARY_DARK_COLOR,
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Container(
//               margin: EdgeInsets.only(bottom: 2),
//               child: Text(
//                 "مسحراتي",
//                 style: TextStyle(
//                   color: Constants.PRIMARY_DARK_COLOR,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             )
//           ],
//         )),
//         subtitle: Icon(
//           Icons.expand_more,
//           color: Constants.PRIMARY_DARK_COLOR,
//         ),
//         title: null,
//         children: [alertsDrum(context)],
//       ),
//     );
//   }
//
//   getHomeBody(RamadanProvider ramadanProvider, BuildContext context) {
//     return SingleChildScrollView(
//         child: Column(children: <Widget>[
//       getFistItme(ramadanProvider),
//       _buildConnanList("", ramadanProvider, context),
//       _buildMashraatList("", ramadanProvider, context),
//       GestureDetector(
//         onTap: () async {
//           setState(() {
//             _isSaveing = true;
//           });
//           Future.delayed(Duration(seconds: 3), () {
//             setState(() {
//               _isSaveing = false;
//             });
//             Navigator.pop(context);
//           });
//         },
//         child: Container(
//           margin: EdgeInsets.only(top: 10, bottom: 8, right: 20, left: 20),
//           width: double.infinity,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Constants.PRIMARY_DARK_COLOR,
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 offset: Offset(5, 5),
//                 blurRadius: 10,
//               )
//             ],
//           ),
//           child: Center(
//             child: Text(
//               'حفظ',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ),
//     //  Container(height: 100, child: AdMobRectangle(BannerName.BOSLA)),
//       Container(
//         height: 50,
//       )
//     ]));
//   }
//
//   getConnan(RamadanProvider ramadanProvider, BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       padding: EdgeInsets.only(top: 10, bottom: 8, right: 10, left: 10),
//       decoration: new BoxDecoration(
//           color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
//           borderRadius: BorderRadius.circular(8.0),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.grey[300],
//                 blurRadius: 10.0,
//                 // has the effect of softening the shadow
//                 spreadRadius: 2.0,
//                 // has the effect of extending the shadow
//                 offset: Offset(
//                   0, // horizontal, move right 10
//                   3, // vertical, move down 10
//                 )),
//           ]),
//       child: CustomExpansionTileTwo(
//         trailing: Container(
//             child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           //Center Column contents vertically,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           //Center Column contents horizontally,
//
//           children: [
//             SvgPicture.asset(
//               "assets/images/ramadan_view/cannon.svg",
//               width: 20,
//               // fit: BoxFit.cover,
//               color: Constants.PRIMARY_DARK_COLOR,
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Container(
//               margin: EdgeInsets.only(bottom: 2),
//               child: Text(
//                 "مدفع الإفطار",
//                 style: TextStyle(
//                   color: Constants.PRIMARY_DARK_COLOR,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             )
//           ],
//         )),
//         subtitle: Icon(
//           Icons.expand_more,
//           color: Constants.PRIMARY_DARK_COLOR,
//         ),
//         title: null,
//         children: [alertsCannon(context)],
//       ),
//     );
//   }
//
//   Widget alertsCannon(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           ui.alertItem(
//               AppLocalizations.of(context)!.translate("activation"),
//               _ramadanProvider.ramadanCannon,
//               _ramadanProvider.ramadanCannonAlertFlagChanged),
//           ui.titleContainer(
//               // sizeConfig,
//               context,
//               AppLocalizations.of(context)!.translate("sound_cannon")),
//           ramadanCannonMethodPart(context),
//         ],
//       ),
//     );
//   }
//
//   getFistItme(RamadanProvider ramadanProvider) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//       decoration: new BoxDecoration(
//           color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
//           borderRadius: BorderRadius.circular(8.0),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.grey[300],
//                 blurRadius: 10.0,
//                 // has the effect of softening the shadow
//                 spreadRadius: 2.0,
//                 // has the effect of extending the shadow
//                 offset: Offset(
//                   0, // horizontal, move right 10
//                   3, // vertical, move down 10
//                 )),
//           ]),
//       child: Column(
//         children: [
//           Container(
//             margin: EdgeInsets.only(top: 5, bottom: 5),
//             width: double.maxFinite,
//             child: Row(
//               children: [
//                 SvgPicture.asset(
//                   "assets/images/slider_view/calendar_.svg",
//                   width: 20,
//                   height: 20,
//                   // width: sizeConfig.blockSizeHorizontal * 5,
//                   fit: BoxFit.cover,
//                   color: Constants.PRIMARY_DARK_COLOR,
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Text("امساكية شهر رمضان الكريم الكريم 1442")
//               ],
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 5, bottom: 13),
//             width: double.maxFinite,
//             height: 1,
//             color: Constants.PRIMARY_DARK_COLOR,
//           ),
//           (_ramadanProvider.ramadanAllData != null &&
//                   _ramadanProvider.ramadanAllData.isNotEmpty)
//               ? Column(children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 2,
//                     ),
//
//                     decoration: BoxDecoration(
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.circular(9.0)),
//                       color: Constants.PRIMARY_DARK_COLOR,
//                     ),
//                     // height: 100,
//                     child: Container(
//                         child: IntrinsicHeight(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: Container(
//                                 alignment: Alignment.center,
//                                 padding: EdgeInsets.symmetric(vertical: 10),
//                                 child: Text(
//                                   "اليوم",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10.5,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 )),
//                           ),
//                           Container(
//                             margin: EdgeInsets.symmetric(horizontal: 2),
//                             // constraints: BoxConstraints.expand(),
//                             // color: Colors.white,
//                             width: 1,
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Container(
//                                 alignment: Alignment.center,
//                                 padding: EdgeInsets.symmetric(vertical: 10),
//                                 child: Text(
//                                   "رمضان",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10.5,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 )),
//                           ),
//                           Container(
//                             margin: EdgeInsets.symmetric(horizontal: 2),
//                             // constraints: BoxConstraints.expand(),
//                             // color: Colors.white,
//                             width: 1,
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: Container(
//                                 alignment: Alignment.center,
//                                 padding: EdgeInsets.symmetric(vertical: 10),
//                                 child: Text(
//                                   "ميلادي",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10.5,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 )),
//                           ),
//                           Container(
//                             margin: EdgeInsets.symmetric(horizontal: 2),
//                             // constraints: BoxConstraints.expand(),
//                             // color: Colors.white,
//                             width: 1,
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Container(
//                                 alignment: Alignment.center,
//                                 padding: EdgeInsets.symmetric(vertical: 10),
//                                 child: Text(
//                                   "فجر",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10.5,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 )),
//                           ),
//                           Container(
//                             margin: EdgeInsets.symmetric(horizontal: 2),
//                             // constraints: BoxConstraints.expand(),
//                             // color: Colors.white,
//                             width: 1,
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Container(
//                                 alignment: Alignment.center,
//                                 padding: EdgeInsets.symmetric(vertical: 10),
//                                 child: Text(
//                                   "مغرب",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10.5,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 )),
//                           ),
//                         ],
//                       ),
//                     )),
//                   ),
//                   Container(
//                     child: Column(
//                       children: [
//                         ...List.generate(ramadanProvider.ramadanDataShow.length,
//                             (index) {
//                           RamadanData ramadan =
//                               ramadanProvider.ramadanDataShow[index];
//                           return Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 2,
//                             ),
//                             color: index % 2 == 0
//                                 ? Colors.grey[200]
//                                 : Colors.green[100],
//                             child: Container(
//                                 child: IntrinsicHeight(
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 children: [
//                                   Expanded(
//                                     flex: 1,
//                                     child: Container(
//                                         alignment: Alignment.center,
//                                         padding:
//                                             EdgeInsets.symmetric(vertical: 10),
//                                         child: Text(
//                                           ramadan.date.hijri.weekday.ar,
//                                           style: TextStyle(
//                                             // color: Colors.white,
//                                             fontSize: 9.5,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         )),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.symmetric(horizontal: 2),
//                                     color: Colors.white,
//                                     width: 1,
//                                   ),
//                                   Expanded(
//                                     flex: 1,
//                                     child: Container(
//                                         alignment: Alignment.center,
//                                         padding:
//                                             EdgeInsets.symmetric(vertical: 10),
//                                         child: Text(
//                                           int.parse(ramadan.date.hijri.day)
//                                               .toString(),
//                                           style: TextStyle(
//                                             fontSize: 9.5,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         )),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.symmetric(horizontal: 2),
//                                     color: Colors.white,
//                                     width: 1,
//                                   ),
//                                   Expanded(
//                                     flex: 2,
//                                     child: Container(
//                                         alignment: Alignment.center,
//                                         padding:
//                                             EdgeInsets.symmetric(vertical: 10),
//                                         child: Text(
//                                           getFormattedDate(
//                                               ramadan.date.gregorian.date),
//                                           style: TextStyle(
//                                             fontSize: 9.5,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         )),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.symmetric(horizontal: 2),
//                                     color: Colors.white,
//                                     width: 1,
//                                   ),
//                                   Expanded(
//                                     flex: 1,
//                                     child: Container(
//                                         alignment: Alignment.center,
//                                         padding:
//                                             EdgeInsets.symmetric(vertical: 10),
//                                         child: Text(
//                                           getFormattedTime(ramadan.timings.fajr
//                                               .split(" ")[0]),
//                                           style: TextStyle(
//                                             fontSize: 9.5,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         )),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.symmetric(horizontal: 2),
//                                     color: Colors.white,
//                                     width: 1,
//                                   ),
//                                   Expanded(
//                                     flex: 1,
//                                     child: Container(
//                                         alignment: Alignment.center,
//                                         padding:
//                                             EdgeInsets.symmetric(vertical: 10),
//                                         child: Text(
//                                           getFormattedTime(ramadan
//                                               .timings.maghrib
//                                               .split(" ")[0]),
//                                           style: TextStyle(
//                                             fontSize: 9.5,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         )),
//                                   ),
//                                 ],
//                               ),
//                             )),
//                           );
//                         })
//                       ],
//                     ),
//                   ),
//                   Container(
//                     child: CustomExpansionTile(
//                       unselectTitel: Text(
//                         "عرض أقل",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       trailing: Text(
//                         "عرض المزيد",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       subtitle: Icon(
//                         Icons.expand_more,
//                         color: Colors.white,
//                       ),
//                       children: [
//                         ...List.generate(
//                           _ramadanProvider.ramadanDataLast.length,
//                           (index) {
//                             RamadanData ramadan =
//                                 _ramadanProvider.ramadanDataLast[index];
//                             return Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 2,
//                               ),
//                               color: index % 2 != 0
//                                   ? Colors.grey[200]
//                                   : Colors.green[100],
//                               child: Container(
//                                   child: IntrinsicHeight(
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: [
//                                     Container(
//                                       margin:
//                                           EdgeInsets.only(top: 5, bottom: 13),
//                                       height: 1,
//                                       color: Constants.PRIMARY_DARK_COLOR,
//                                     ),
//                                     Expanded(
//                                       flex: 1,
//                                       child: Container(
//                                           alignment: Alignment.center,
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 10),
//                                           child: Text(
//                                             ramadan.date.hijri.weekday.ar,
//                                             style: TextStyle(
//                                               // color: Colors.white,
//                                               fontSize: 9.5,
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           )),
//                                     ),
//                                     Container(
//                                       margin:
//                                           EdgeInsets.symmetric(horizontal: 2),
//                                       // constraints: BoxConstraints.expand(),
//                                       color: Colors.white,
//                                       width: 1,
//                                     ),
//                                     Expanded(
//                                       flex: 1,
//                                       child: Container(
//                                           alignment: Alignment.center,
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 10),
//                                           child: Text(
//                                             int.parse(ramadan.date.hijri.day)
//                                                 .toString(),
//                                             style: TextStyle(
//                                               // color: Colors.white,
//                                               fontSize: 9.5,
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           )),
//                                     ),
//                                     Container(
//                                       margin:
//                                           EdgeInsets.symmetric(horizontal: 2),
//                                       color: Colors.white,
//                                       width: 1,
//                                     ),
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           alignment: Alignment.center,
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 10),
//                                           child: Text(
//                                             getFormattedDate(
//                                                 ramadan.date.gregorian.date),
//                                             style: TextStyle(
//                                               // color: Colors.white,
//                                               fontSize: 9.5,
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           )),
//                                     ),
//                                     Container(
//                                       margin:
//                                           EdgeInsets.symmetric(horizontal: 2),
//                                       // constraints: BoxConstraints.expand(),
//                                       color: Colors.white,
//                                       width: 1,
//                                     ),
//                                     Expanded(
//                                       flex: 1,
//                                       child: Container(
//                                           alignment: Alignment.center,
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 10),
//                                           child: Text(
//                                             getFormattedTime(ramadan
//                                                 .timings.fajr
//                                                 .split(" ")[0]),
//                                             style: TextStyle(
//                                               // color: Colors.white,
//                                               fontSize: 9.5,
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           )),
//                                     ),
//                                     Container(
//                                       margin:
//                                           EdgeInsets.symmetric(horizontal: 2),
//                                       color: Colors.white,
//                                       width: 1,
//                                     ),
//                                     Expanded(
//                                       flex: 1,
//                                       child: Container(
//                                           alignment: Alignment.center,
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 10),
//                                           child: Text(
//                                             getFormattedTime(ramadan
//                                                 .timings.maghrib
//                                                 .split(" ")[0]),
//                                             style: TextStyle(
//                                               // color: Colors.white,
//                                               fontSize: 9.5,
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           )),
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                             );
//                           },
//                         )
//                       ],
//                     ),
//                   ),
//                 ])
//               : InkWell(
//                   onTap: () {
//                     _ramadanProvider.getRamadanCalender();
//                   },
//                   child: Container(
//                       child: Center(
//                           child: Row(
//                     children: [
//                       Text(
//                         "لا توجد بيانات",
//                         style: TextStyle(
//                             color: Constants.PRIMARY_COLOR,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15),
//                       ),
//                       Expanded(child: Container()),
//                       Text(
//                         "إعادة تحميل",
//                         style: TextStyle(
//                             color: Constants.PRIMARY_COLOR,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15),
//                       ),
//                       Icon(
//                         Icons.refresh,
//                         color: Constants.PRIMARY_COLOR,
//                       ),
//                     ],
//                   ))))
//         ],
//       ),
//     );
//   }
//
//   Widget ramadanCannonMethodPart(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       margin: EdgeInsets.all(20),
//       padding: EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(color: Constants.ACCENT_COLOR, width: 1)),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton(
//           value: _ramadanProvider.ramadanCannonSelected,
//           hint: Text(
//             AppLocalizations.of(context)!.translate("sound_cannon_chosen"),
//             style: TextStyle(
//                 color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
//             overflow: TextOverflow.ellipsis,
//           ),
//           items: _ramadanProvider.ramadanCannonModel.map((f) {
//             return DropdownMenuItem<RamadanSoundsModel>(
//               child: Text(
//                 f.name,
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               value: f,
//             );
//           }).toList(),
//           onChanged: (value) async {
//             _ramadanProvider.ramadanCannonSelected = value;
//             _ramadanProvider.saveSelectedConnanJson(
//                 _ramadanProvider.ramadanCannonSelected.toJson(), "");
//             await _ramadanProvider.downloadConnanFile(
//                 _ramadanProvider.ramadanCannonModel.indexOf(value));
//             //AZAN  /data/user/0/com.muslim_book.muslim_book/app_flutter/azan_1.mp3
//             //ramadan  /data/user/0/com.muslim_book.muslim_book/app_flutter/ramadan_cannonModel_sounds2.mp3
//             playSound(_ramadanProvider.ramadanCannonSelected.file);
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   void deactivate() {
//     FacebookInterstitialAd.loadInterstitialAd(
//       placementId: locator<RemoteConfigService>().azanPopUpAdId,
//       listener: (result, value) {
//         if (result == InterstitialAdResult.LOADED)
//           FacebookInterstitialAd.showInterstitialAd();
//       },
//     );
//     super.deactivate();
//   }
//
//   Future playSound(file) async {
//     if (!screenNoLongerActive) await audioPlayer.play(file, isLocal: false);
//   }
//
//   Widget alertsDrum(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           ui.alertItem(
//               AppLocalizations.of(context)!.translate("activation"),
//               _ramadanProvider.ramadanMashraat,
//               _ramadanProvider.ramadanMashraaatAlertFlagChanged),
//           ui.titleContainer(
//               // sizeConfig,playAzan
//               context,
//               AppLocalizations.of(context)!.translate("sound_mashraat_chosen")),
//           drumMethodPart(context),
//           ui.titleContainer(
//               context, AppLocalizations.of(context)!.translate("alarm_time")),
//           InkWell(
//             onTap: () {
//               ui.handleFABPressed();
//             },
//             child: Container(
//               alignment: Alignment.center,
//               width: MediaQuery.of(context).size.width,
//               margin: EdgeInsets.all(20),
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(13),
//                   border: Border.all(color: Constants.ACCENT_COLOR, width: 1)),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     DateFormat("h:mma").format(_ramadanProvider.dateMshart),
//                     style: TextStyle(
//                         color: Theme.of(context).primaryColor,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "تعديل",
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           ui.titleContainer(
//               // sizeConfig,
//               context,
//               AppLocalizations.of(context)!.translate("number_repetitions")),
//           drumRepetitionsPart(context)
//         ],
//       ),
//     );
//   }
//
//   void getDayTime(Map value) {
//     _dateTime = value;
//   }
//
//   Widget drumRepetitionsPart(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       margin: EdgeInsets.all(20),
//       padding: EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(color: Constants.ACCENT_COLOR, width: 1)),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton(
//           value: _ramadanProvider.repetitionsSelected,
//           hint: Text(
//             AppLocalizations.of(context)!.translate("sound_repetitions_chosen"),
//             style: TextStyle(
//                 color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
//             overflow: TextOverflow.ellipsis,
//           ),
//           items: _ramadanProvider.repetitions.map((f) {
//             return DropdownMenuItem<Repetitions>(
//               child: Text(
//                 f.name,
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               value: f,
//             );
//           }).toList(),
//           onChanged: (value) {
//             _ramadanProvider.repetitionsSelected = value;
//             _ramadanProvider.saveSelectedMashraatRepetitionsJson(
//                 _ramadanProvider.repetitionsSelected.id.toString(), context);
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget drumMethodPart(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       margin: EdgeInsets.all(20),
//       padding: EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(color: Constants.ACCENT_COLOR, width: 1)),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton(
//           value: _ramadanProvider.ramadanMashraatSelected,
//           hint: Text(
//             AppLocalizations.of(context)!.translate("sound_mashraat_chosen"),
//             style: TextStyle(
//                 color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
//             overflow: TextOverflow.ellipsis,
//           ),
//           items: _ramadanProvider.ramadanMashraatModel.map((f) {
//             return DropdownMenuItem<RamadanSoundsModel>(
//               child: Text(
//                 f.name,
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               value: f,
//             );
//           }).toList(),
//           onChanged: (value) async {
//             _ramadanProvider.ramadanMashraatSelected = value;
//             playSound(_ramadanProvider.ramadanMashraatSelected.file);
//             _ramadanProvider.saveSelectedMashraatJson(
//                 _ramadanProvider.ramadanMashraatSelected.toJson(), "");
//             await _ramadanProvider.downloadMashraatFile(
//                 _ramadanProvider.ramadanMashraatModel.indexOf(value));
//           },
//         ),
//       ),
//     );
//   }
// }
