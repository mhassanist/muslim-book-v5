import 'package:admob_flutter/admob_flutter.dart';
import 'package:base_app/ads/admob_rectangle.dart';
import 'package:base_app/ads/load_ui_with_add.dart';
import 'package:base_app/locals_utils/language_constants.dart';
import 'package:base_app/models/banner_names_enum.dart';
import 'package:base_app/providers/location_provider.dart';
import 'package:base_app/providers/settings_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/views/settings_view/settings_view_mobile_portrait/settings_mobile_portrait_ui.dart';
import 'package:base_app/widgets/base_widget.dart';
import 'package:base_app/widgets/custom_expansion_panel_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../locals_utils/app_localizations.dart';
import '../../../widgets/appBar_widget.dart';

class ExpansionpanelItem {
  bool isExpanded;
  final String title;
  final Widget content;
  final Icon leading;
  final String icon;

  ExpansionpanelItem(
      {this.isExpanded, this.title, this.content, this.leading, this.icon});
}

class SettingsViewMobilePortrait extends StatefulWidget {
  @override
  _SettingsViewMobilePortraitState createState() =>
      _SettingsViewMobilePortraitState();
}

class _SettingsViewMobilePortraitState
    extends State<SettingsViewMobilePortrait> {
  SettingsMobilePortraitUi ui;
  int itmeSelection;


  @override
  void initState() {
    
    super.initState();
  }


  List<ExpansionpanelItem> items = [
    ExpansionpanelItem(
      isExpanded: false,
      leading: Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/bell.svg",
    ),
    ExpansionpanelItem(
      isExpanded: false,
      leading: Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/world.svg",
    ),
    ExpansionpanelItem(
      isExpanded: false,
      leading: Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/eclipse.svg",
    ),
    ExpansionpanelItem(
      isExpanded: false,
      leading: Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/clock.svg",
    ),
    ExpansionpanelItem(
      isExpanded: false,
      leading: Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/shaikh.svg",
    ),
    ExpansionpanelItem(
      isExpanded: false,
      leading: Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/moon.svg",
    ),
    ExpansionpanelItem(
      isExpanded: false,
      leading: Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/gear.svg",
    ),
  ];
  List<ExpansionpanelItem> contents = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ResponsiveBuilder(builder: (context, sizeConfig) {
        return BaseView<SettingsProvider>(onModelReady: (model) async {
          model.context = context;
          ui = SettingsMobilePortraitUi(
            Provider.of<LocationProvider>(context),
            context: context,
            provider: model,
            sizeConfig: sizeConfig,
          );
        }, builder: (_, model, __) {
          model.fillTheSettingsData();
          contents = [
            ExpansionpanelItem(
                isExpanded: false,
                title: AppLocalizations.of(context).translate("alerts"),
                content: ui.alertsPart(),
                leading: Icon(Icons.arrow_back_ios)),
            ExpansionpanelItem(
                isExpanded: false,
                title:
                    AppLocalizations.of(context).translate("country_specify"),
                content: ui.countrySelectionPart(),
                leading: Icon(Icons.arrow_back_ios)),
            ExpansionpanelItem(
                isExpanded: false,
                title:
                    AppLocalizations.of(context).translate("calculation_type"),
                content: ui.azanMethodSelectionPart(),
                leading: Icon(Icons.arrow_back_ios)),
            ExpansionpanelItem(
                isExpanded: false,
                title: AppLocalizations.of(context)
                    .translate("edite_tieme_prayer"),
                content: ui.azanTime(),
                leading: Icon(Icons.arrow_back_ios)),
            ExpansionpanelItem(
                isExpanded: false,
                title: AppLocalizations.of(context).translate("azan_shiekh"),
                content: ui.azanShiekhPart(),
                leading: Icon(Icons.arrow_back_ios)),
            ExpansionpanelItem(
                isExpanded: false,
                content: ui.fajrAzanShiekhPart(),
                title:
                    AppLocalizations.of(context).translate("azan_shiekh_fajr"),
                leading: Icon(Icons.arrow_back_ios)),
            ExpansionpanelItem(
                isExpanded: false,
                title:
                AppLocalizations.of(context).translate("general_settings"),
                content: ui.generalSettingsPart(),
                leading: Icon(Icons.arrow_back_ios))
          ];
          return SafeArea(
            child: Scaffold(
              appBar: appBar(
                context,
                sizeConfig,
                AppLocalizations.of(context).translate("settings"),
              ),
              body
                  :
              Container(
                  color: Constants.CANVAS_COLOR,
                  child:
                  LoadUiWithAdd(
                    mainView: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child:  CustomExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                items[index].isExpanded =
                                    !items[index].isExpanded;
                              });
                            },
                            children: [
                              ...items.map((ExpansionpanelItem item) {
                                return ExpansionPanel(
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  item.icon,
                                                  height: 26.0,
                                                  color: Colors.white,
                                                  allowDrawingOutsideViewBox:
                                                      true,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  contents[items.indexOf(item)]
                                                      .title,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )
                                              ],
                                            ))
                                      ],
                                    );
                                  },
                                  isExpanded: item.isExpanded,
                                  body: Container(
                                    margin: EdgeInsets.only(
                                        right: 4, left: 4, bottom: 4, top: 4),
                                    width: MediaQuery.of(context).size.width,
                                    // height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          // topRight: Radius.circular(12),
                                          // topLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.white,
                                              Colors.white,
                                            ])),
                                    child: contents[items.indexOf(item)].content,
                                  ),
                                );
                              }).toList(),
                            ]),
                      ),
              SliverToBoxAdapter(
                    child:
                    SizedBox(
                        height: 10,
                      )),
              SliverToBoxAdapter(
                    child:
                    Container(
                          child:
                          AdMobRectangle(BannerName.BOSLA )
                        //   AdMobRectangle(BannerName.BOSLA)
              ),),
                          SliverToBoxAdapter(
                              child:
                              SizedBox(
                                height: 10,
                              )),
                    ]),
                  ),),

            ),
          );
        });
      }),
    );
  }
}
