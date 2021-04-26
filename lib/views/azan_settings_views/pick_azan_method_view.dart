import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/local_storage/local_storage_manager.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/models/azan_sound.dart';
import 'package:base_app/providers/pick_azan_methods_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/views/pick_azan_shiekh_view/pick_azan_shiekh_view.dart';
import 'package:base_app/views/pick_azan_shiekh_view/pick_fajr_azan_shiekh_view.dart';
import 'package:base_app/widgets/appBar_widget.dart';
import 'package:base_app/widgets/base_widget.dart';
import 'package:base_app/widgets/on_boarding_view/azan_methods_drop_down.dart';
import 'package:base_app/widgets/on_boarding_view/mazhab_drop_down.dart';
import 'package:base_app/widgets/on_boarding_view/save_settings_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../utils/sizing_info_extension.dart';

class PickAzanMethodView extends StatefulWidget {
  @override
  _PickAzanMethodViewState createState() => _PickAzanMethodViewState();
}

class _PickAzanMethodViewState extends State<PickAzanMethodView> {
  PickAzanMethodsProvider _provider;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return BaseView<PickAzanMethodsProvider>(onModelReady: (model) {
        _provider = model;
        _provider.provideDefaultValueToMazhab(context);
        _provider.provideDefaultValueToMethod(context);
      }, builder: (_, model, __) {
        return SafeArea(
          child: Scaffold(
            appBar: appBar(context, sizeConfig,
                AppLocalizations.of(context).translate("set_azan")),
            body: ResponsiveBuilder(builder: (context, sizeConfig) {
              return Container(
                child: ListView(
                  children: <Widget>[
                    // Container(
                    // height: sizeConfig.blockSizeVertical * 20,
                    // child: Image.asset(
                    // "assets/images/onboarding/country_picker.png")),
                    alertsPart(sizeConfig),
                    // Container(
                    //     margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                    //     child: divider(sizeConfig, context)),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: titleContainer(
                          AppLocalizations.of(context)
                              .translate("calculating_pray_method"),
                          sizeConfig,
                          context),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: MethodsDropDown()),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: divider(sizeConfig, context)),
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: titleContainer(
                          AppLocalizations.of(context)
                              .translate("almazhab_in_your_country"),
                          sizeConfig,
                          context),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: MazhabsDropDown()),
                    // Container(
                    //     margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                    //     child: divider(sizeConfig, context)),
                    azanShiekhPart(sizeConfig),
                    // fajrAzanShiekhPart(sizeConfig),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Center(child: saveCountryButton(sizeConfig, context))
                  ],
                ),
              );
            }),
          ),
        );
      });
    });
  }

  Widget alertsPart(SizingInformation sizeConfig) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          alertItem(
              sizeConfig,
              AppLocalizations.of(context).translate("allow_alfajr_ibtehal"),
              _provider.fajrIbtehal,
              _provider.fajrIbtehalFlagChanged),
          // alertItem(
          //     sizeConfig,
          //     AppLocalizations.of(context)
          //         .translate("mondays_and_thursdays_fasting_alert"),
          //     _provider.mondaysAndThursdaysFastingAlert,
          //     _provider.mondaysAndThursdaysFastingAlertFlagChanged),
          // alertItem(
          //     sizeConfig,
          //     AppLocalizations.of(context)
          //         .translate("white_days_fasting_alert"),
          //     _provider.whiteDaysFastingAlert,
          //     _provider.whiteDaysFastingAlertFlagChanged),
        ],
      ),
    );
  }

  Widget alertItem(SizingInformation sizeConfig, String title, bool value,
      Function function) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 35, right: 35, bottom: 5, top: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: sizeConfig.blockSizeHorizontal * 4,
                      fontWeight: FontWeight.w700,
                      color: Constants.MAIN_TEXT_COLOR),
                ),
              ),
              RotationTransition(
                turns: AlwaysStoppedAnimation(0.5),
                child: Switch(
                  value: value,
                  onChanged: (val) {
                    function(val);
                  },
                  activeThumbImage: AssetImage(
                      "assets/images/general/custom_switch_active.png"),
                  inactiveThumbImage: AssetImage(
                      "assets/images/general/custom_switch_inactive.png"),
                ),
              ),
            ],
          ),
        ),
        // innerDivider(sizeConfig, context)
      ],
    );
  }

  Widget azanShiekhPart(SizingInformation sizeConfig) {
    return Container(
        width: sizeConfig.blockSizeHorizontal * 50,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: Text(
                  AppLocalizations.of(context).translate("azan_shiekh"),
                  style: TextStyle(
                      fontSize: sizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor),
                ),
              ),
//              AnimatedCrossFade(
//                  firstChild: SizedBox(),
//                  secondChild: Container(
//                    margin:
//                    EdgeInsets.only(top: sizeConfig.blockSizeVertical * 2),
//                    child: Center(
//                      child: Text(
//                        "${_provider.pickedAzanShiekh != null ? _provider.pickedAzanShiekh["name"] : Constants.SHIEKH_NAMES[0]["name"]}",
//                        style: TextStyle(
//                            color: Constants.PRIMARY_DARK_COLOR,
//                            fontWeight: FontWeight.w700,
//                            fontSize: sizeConfig.blockSizeHorizontal * 4),
//                      ),
//                    ),
//                  ),
//                  crossFadeState: _provider.pickedAzanShiekh == null
//                      ? CrossFadeState.showFirst
//                      : CrossFadeState.showSecond,
//                  duration: Duration(milliseconds: 200)),
              Container(
                margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 2),
                child: Center(
                  child: Text(
                    "${_provider.pickedAzanShiekh != null ? _provider.pickedAzanShiekh["name"] : Constants.SHIEKH_NAMES[1]["name"]}",
                    style: TextStyle(
                        color: Constants.PRIMARY_DARK_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: sizeConfig.blockSizeHorizontal * 4),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  width: sizeConfig.blockSizeHorizontal * 80,
                  height: sizeConfig.blockSizeVertical * 7,
                  child: RaisedButton(
                    onPressed: () async {
                      int newShiekhIndex = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PickAzanShiekhView()));
                      List<AzanSound> sounds = await LocalStorageManager().loadAzanSoundsList();
                      if(sounds!=null && sounds[newShiekhIndex]!=null){
                        _provider.pickedAzanShiekh = sounds[newShiekhIndex].toJSON();
                      }
                      if (sounds == null && newShiekhIndex != null) {
                        _provider.pickedAzanShiekh =
                            Constants.SHIEKH_NAMES[newShiekhIndex];
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    color: Constants.CANVAS_COLOR,
                    child: Text(
                      AppLocalizations.of(context).translate("select_shiekh"),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: sizeConfig.blockSizeHorizontal * 4,
                      ),
                    ),
                  ),
                ),
              )
            ]));
  }

  Container divider(SizingInformation sizeConfig, BuildContext context) {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 80,
      color: Theme.of(context).primaryColorDark.withOpacity(.4),
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 5),
    );
  }

  Container innerDivider(SizingInformation sizeConfig, BuildContext context) {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 90,
      color: Theme.of(context).primaryColorDark.withOpacity(.4),
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    );
  }

  Widget titleContainer(
      String text, SizingInformation sizeConfig, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: sizeConfig.blockSizeHorizontal * 5,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor),
    );
  }

  Widget saveCountryButton(sizeConfig, context) {
    return Builder(builder: (context) {
      return SaveSettingsButton(
        text: "save_timing_settings",
        onTap: () {
          if (_provider.pickedMethod == null ||
              _provider.pickedMazhab == null) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                AppLocalizations.of(context).translate("mazhab_method_empty"),
              ),
            ));
          } else
            _provider.saveSettings(context);
        },
        state: _provider.viewState == ViewState.Loading
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
      );
    });
  }

  fajrAzanShiekhPart(SizingInformation sizeConfig) {
    return Container(
        width: sizeConfig.blockSizeHorizontal * 50,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: Text(
                  AppLocalizations.of(context).translate("azan_shiekh_fajr"),
                  style: TextStyle(
                      fontSize: sizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 2),
                child: Center(
                  child: Text(
                    "${_provider.pickedFajrAzanShiekh != null ?
                    _provider.pickedFajrAzanShiekh["name"] : Constants.FAJR_SHIEKH_NAMES[0]["name"]}",
                    style: TextStyle(
                        color: Constants.PRIMARY_DARK_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: sizeConfig.blockSizeHorizontal * 4),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  width: sizeConfig.blockSizeHorizontal * 80,
                  height: sizeConfig.blockSizeVertical * 7,
                  child: RaisedButton(
                    onPressed: () async {
                      int newShiekhIndex = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PickFajrAzanShiekhView()));
                      List<AzanSound> sounds = await LocalStorageManager().loadFajrAzanSoundsList();
                      if(sounds!=null && sounds[newShiekhIndex]!=null){
                        _provider.pickedFajrAzanShiekh = sounds[newShiekhIndex].toJSON();
                      }
                      if (sounds == null && newShiekhIndex != null) {
                        _provider.pickedFajrAzanShiekh =
                        Constants.FAJR_SHIEKH_NAMES[newShiekhIndex];
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    color: Constants.CANVAS_COLOR,
                    child: Text(
                      AppLocalizations.of(context).translate("select_shiekh"),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: sizeConfig.blockSizeHorizontal * 4,
                      ),
                    ),
                  ),
                ),
              )
            ]));

  }
}
