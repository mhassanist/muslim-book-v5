import 'package:muslim_book/ads/admob_banner.dart';
import 'package:muslim_book/ads/load_ui_with_add.dart';
import 'package:muslim_book/azan_feature/controllers/azan_controller.dart';
import 'package:muslim_book/azan_feature/models/azan_model.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/providers/pick_azan_methods_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:muslim_book/widgets/base_widget.dart';
import 'package:muslim_book/widgets/loading_pkg/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditTimePrayer extends StatefulWidget {
  final void Function()? updateAzan;
  final Azan? azan;
  final bool showAppBar;

  const EditTimePrayer({
    super.key,
    this.azan,
    required this.showAppBar,
    this.updateAzan,
  });

  @override
  _EditTimePrayerState createState() => _EditTimePrayerState();
}

class _EditTimePrayerState extends State<EditTimePrayer> {
  final AzanController controller = Get.find<AzanController>();
  late PickAzanMethodsProvider _provider;
  List<Azan> azanValue = [];
  bool _isSaveing = false;

  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    azanValue = controller.getAzanList(context) ?? [];
    final size = MediaQuery.of(context).size;
    final isSmall = size.width <= 450;
    return new WillPopScope(
        onWillPop: () {
          if (widget.showAppBar) widget.updateAzan?.call();
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
            appBar: widget.showAppBar ? _buildAppBar(context) : null,
            body: ResponsiveBuilder(builder: (context, sizeConfig) {
              return azanValue.isEmpty
                  ? Container()
                  : BaseView<PickAzanMethodsProvider>(onModelReady: (model) {
                      _provider = model;
                      _provider.provideDefaultValueToMazhab(context);
                      _provider.provideDefaultValueToMethod(context);
                    }, builder: (_, model, __) {
                      return GetBuilder<AzanController>(builder: (controller) {
                        return Container(
                            child: LoadUiWithAd(
                          mainView: CustomScrollView(slivers: <Widget>[
                            SliverToBoxAdapter(
                              child: Container(
                                height: 400,
                                child: Stack(
                                    //alignment:new Alignment(x, y)
                                    children: <Widget>[
                                      Positioned.fill(
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: azanValue.length,
                                          itemBuilder: (context, index) {
                                            return _buildSingleAzan(
                                                azanValue[index],
                                                sizeConfig,
                                                index,
                                                isSmall);
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        top: 160,
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            // margin: EdgeInsets.only(top: 100),
                                            child: Visibility(
                                              visible: _isSaveing,
                                              child: Loading(
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                            SliverToBoxAdapter(
                                child: Visibility(
                              visible: widget.showAppBar,
                              child: AdmobBanner(bannerName: BannerName.TOP),
                            )),
                            SliverToBoxAdapter(
                                child: SizedBox(
                              height: 10,
                            )),
                            SliverToBoxAdapter(
                                child: Container(
                                    padding: widget.showAppBar
                                        ? EdgeInsets.symmetric(horizontal: 35)
                                        : EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                _isSaveing = true;
                                              });
                                              await saveAllData()
                                                  .whenComplete(() {
                                                Future.delayed(
                                                    Duration(seconds: 5), () {
                                                  setState(() {
                                                    _isSaveing = false;
                                                  });
                                                  widget.updateAzan?.call();
                                                  Navigator.pop(context);
                                                });
                                              });
                                            },
                                            child: Container(
                                              width: !isSmall ? 150 : 130,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Constants
                                                    .PRIMARY_DARK_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(5, 5),
                                                    blurRadius: 10,
                                                  )
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'حفظ',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: !isSmall ? 150 : 130,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 2.5,
                                                  color: Constants
                                                      .PRIMARY_DARK_COLOR,
                                                ),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(5, 5),
                                                    blurRadius: 7,
                                                  )
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "إلغاء",
                                                  style: TextStyle(
                                                    color: Constants
                                                        .PRIMARY_DARK_COLOR,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]))),
                            SliverToBoxAdapter(
                                child: SizedBox(
                              height: 20,
                            ))
                          ]),
                        ));
                      });
                    });
            })));
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: const Color(0XFF347D53),
        title: Text(
          AppLocalizations.of(context)!.translate("edite_tieme_prayer"),
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text(
              AppLocalizations.of(context)!.translate("save"),
              style: TextStyle(color: Constants.CANVAS_COLOR),
            ),
            onPressed: () async {
              setState(() {
                _isSaveing = true;
              });
              await saveAllData().whenComplete(() {
                Future.delayed(Duration(seconds: 5), () {
                  controller.enableWeeklyFastingAlerts();
                  setState(() {
                    _isSaveing = false;
                  });
                  widget.updateAzan?.call();
                  Navigator.pop(context);
                });
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildSingleAzan(
      Azan azan, SizingInformation sizeConfig, int index, bool isSmall) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: sizeConfig.blockSizeHorizontal * 4.5,
          vertical: sizeConfig.blockSizeVertical),
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: widget.azan != null
            ? azan.id == widget.azan!.id
                ? Border.all(
                    width: .5,
                    color: Constants.PRIMARY_DARK_COLOR,
                  )
                : null
            : azan.id == "1"
                ? Border.all(
                    width: .5,
                    color: Constants.PRIMARY_DARK_COLOR,
                  )
                : null,
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(3, 3),
            blurRadius: 7,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: sizeConfig.blockSizeHorizontal * 5,
          ),
          Expanded(
              child: Text(
            "تصحيح" + " " + azanValue[index].title + " " + "بالدقائق",
            style: TextStyle(
                color: Constants.PRIMARY_DARK_COLOR,
                fontWeight: FontWeight.bold,
                fontSize: sizeConfig.blockSizeHorizontal * 3),
          )),
          !isSmall
              ? SizedBox(
                  width: sizeConfig.blockSizeHorizontal,
                )
              : Container(),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: sizeConfig.blockSizeHorizontal,
                ),
                Text(
                  controller.getFormattedTime(
                      azanValue[index].time.split(":")[0] +
                          ":" +
                          ((int.parse(azanValue[index].minute) +
                                  azanValue[index].count))
                              .toString()),
                  // azanValue[index].time,

                  style: TextStyle(
                      color: Constants.PRIMARY_DARK_COLOR,
                      fontSize: sizeConfig.blockSizeHorizontal * 4),
                ),
                SizedBox(
                  width: sizeConfig.blockSizeHorizontal,
                ),
                Text(
                  "${int.parse(azanValue[index].hours) >= 12 ? "م" : "ص"}",
                  style: TextStyle(
                      color: Constants.PRIMARY_DARK_COLOR,
                      fontSize: sizeConfig.blockSizeHorizontal * 4),
                  textAlign: TextAlign.center,
                ),
              ]),
          SizedBox(
            width: sizeConfig.blockSizeHorizontal,
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (azanValue[index].count > -60) {
                          azanValue[index].count--;
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Constants.PRIMARY_DARK_COLOR,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(2, 2),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Center(
                        child: Container(
                            child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sizeConfig.blockSizeHorizontal * 4,
                  ),
                  new Text(azanValue[index].count.toString()),
                  SizedBox(
                    width: sizeConfig.blockSizeHorizontal * 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (azanValue[index].count < 60) {
                          ++azanValue[index].count;
                          // azanValue[index].time =
                          //     azanValue[index].time.split(":")[0] +":"
                          //         + ( (int.parse(azanValue[index].minute)
                          //         +azanValue[index].count)).toString();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Constants.PRIMARY_DARK_COLOR,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(2, 2),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Center(
                        child: new Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sizeConfig.blockSizeHorizontal * 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> saveAllData() async {
    setState(() {
      for (var i = 0; i < azanValue.length; i++) {
        var minute = ((int.parse(azanValue[i].minute) + azanValue[i].count));
        String timeUpdate = "${azanValue[i].hours}:${minute}";
        updateDate(azanValue[i].id, timeUpdate, azanValue[i].count);
      }
    });

    return "done";
  }

  updateDate(String key, time, mints) async {
    // await locator<Prefs>().updateString(key, time);
    await locator<Prefs>().updateString("update$key", mints.toString());
  }

  String _getFormattedTime(time) {
    var timeOfDay = TimeOfDay(
      hour: int.parse(time.split(":")[0]),
      minute: int.parse(time.split(":")[1]),
    );
    // print(DateFormat('hh:mm').format(DateTime.now()));
    return DateFormat('hh:mm').format(DateTime(
        _now.year, _now.month, _now.day, timeOfDay.hour, timeOfDay.minute));
    // return "asd";
  }
}

