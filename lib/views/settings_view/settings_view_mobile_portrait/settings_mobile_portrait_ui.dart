import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/local_storage/local_storage_manager.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/azan_sound.dart';
import 'package:muslim_book/network_utils/azan_apis.dart';
import 'package:muslim_book/providers/location_provider.dart';
import 'package:muslim_book/providers/settings_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:muslim_book/views/edit_time_prayer_view/edit_time_prayer_view.dart';
import 'package:muslim_book/views/pick_azan_shiekh_view/pick_azan_shiekh_view.dart';
import 'package:muslim_book/views/pick_azan_shiekh_view/pick_fajr_azan_shiekh_view.dart';
import 'package:muslim_book/widgets/general_wigets/loading_button.dart';
import 'package:muslim_book/widgets/standardButton_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../utils/sizing_info_extension.dart';

class SettingsMobilePortraitUi {
  final SettingsProvider provider;
  final SizingInformation sizeConfig;
  final BuildContext context;
  final LocationProvider locationProvider;

  //because we are not selecting specific prayer time from this screen,
  //we will get Asr as a sample to display
  //we pass null to the sheikh picker, to apply the selection to all 5 prayer
  //times
  final randomAzanId_value3 = "3";

  SettingsMobilePortraitUi(
    this.locationProvider, {
    required this.provider,
    required this.sizeConfig,
    required this.context,
  });

  Widget alertsPart() {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   margin: EdgeInsets.only(top: 20, left: 30, right: 30),
          //   child: Text(
          //     AppLocalizations.of(context)!.translate("alerts"),
          //     style: TextStyle(
          //         fontSize: sizeConfig.blockSizeHorizontal * 5,
          //         fontWeight: FontWeight.w700,
          //         color: Theme.of(context).primaryColor),
          //   ),
          // ),
          alertItem(
              AppLocalizations.of(context)!
                  .translate("azan_on_pray_time_alert"),
              provider.azanAlert,
              provider.azanAlertFlagChanged),
          alertItem(
              AppLocalizations.of(context)!.translate("allow_alfajr_ibtehal"),
              provider.fajrIbtehal,
              provider.fajrIbtehalFlagChanged),
          alertItem(
              AppLocalizations.of(context)!
                  .translate("mondays_and_thursdays_fasting_alert"),
              provider.mondaysAndThursdaysFastingAlert,
              provider.mondaysAndThursdaysFastingAlertFlagChanged),
          alertItem(
              AppLocalizations.of(context)!
                  .translate("white_days_fasting_alert"),
              provider.whiteDaysFastingAlert,
              provider.whiteDaysFastingAlertFlagChanged),
        ],
      ),
    );
  }

  Widget azanMethodSelectionPart() {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Text(
              AppLocalizations.of(context)!.translate("calculation_type"),
              style: TextStyle(
                  fontSize: sizeConfig.blockSizeHorizontal * 5,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          titleContainer(
              sizeConfig,
              context,
              AppLocalizations.of(context)!
                  .translate("calculating_pray_method")),
          azanMethodPart(),
          divider(sizeConfig, context),
          Container(
            margin: EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Text(
              AppLocalizations.of(context)!.translate("mazhab"),
              style: TextStyle(
                  fontSize: sizeConfig.blockSizeHorizontal * 5,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          titleContainer(
            sizeConfig,
            context,
            AppLocalizations.of(context)!.translate("mazhab_depends"),
          ),
          mazhabPart(),
          Container(
            margin: EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Text(
              AppLocalizations.of(context)!.translate("high_altitudes"),
              style: TextStyle(
                  fontSize: sizeConfig.blockSizeHorizontal * 5,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor),
            ),
          ),

          titleContainer(
            sizeConfig,
            context,
            AppLocalizations.of(context)!.translate("settings_of_heights"),
          ),

          highAltitudesPart(),

          LoadingButton(
            firstWidget: Center(
              child: standardButton(
                  isGo: false,
                  context: context,
                  sizeConfig: sizeConfig,
                  color: Theme.of(context).primaryColorDark,
                  title:
                      AppLocalizations.of(context)!.translate("save_settings"),
                  onPressed: () async {
                    provider.setViewState(ViewState.Loading);

                    locator<Prefs>().setLatitudeAdjustmentMethod(
                        (AppLocalizations.of(context)!.isEnglish()
                                ? Constants.EN_Latitude_Adjustment_Method
                                : Constants.AR_Latitude_Adjustment_Method)
                            .indexOf(provider.latitudeAdjustmentMethod));

                    locator<Prefs>().setAzanMethod(
                        (AppLocalizations.of(context)!.isEnglish()
                                ? Constants.EN_AZAN_METHODS
                                : Constants.AR_AZAN_METHODS)
                            .indexOf(provider.pickedMethod));

                    locator<Prefs>().setAzanMazhab(
                        (AppLocalizations.of(context)!.isEnglish()
                                ? Constants.EN_AZAN_Mazhabs
                                : Constants.AR_AZAN_Mazhabs)
                            .indexOf(provider.pickedMazhab));

                    await AzanApis().getAzan();
                    provider.setViewState(ViewState.Idle);
                  }),
            ),
            state: provider.viewState == ViewState.Loading
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          )
          // divider(sizeConfig, context),
        ],
      ),
    );
  }

  Widget azanShiekhPart() {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedCrossFade(
            firstChild: SizedBox(),
            secondChild: Container(
              margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 2),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    provider.pickedAzanShiekhMain[randomAzanId_value3] != null
                        ? "${provider.pickedAzanShiekhMain[randomAzanId_value3]}"
                        : "اختر شيخاً",

                    //"${AppLocalizations.of(context)!.isEnglish() ? Constants.EN_SHIEKH_NAMES[0]["name"] : Constants.AR_SHIEKH_NAMES[0]["name"]}",
                    // "${provider.pickedAzanShiekhMain[randomAzanId]["name"]}",
                    style: TextStyle(
                        color: Constants.PRIMARY_DARK_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: sizeConfig.blockSizeHorizontal * 4),
                  ),
                ),
              ),
            ),
            crossFadeState: provider.pickedAzanShiekhMain.isNotEmpty
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 200),
          ),
          Center(
            child: standardButton(
                isGo: true,
                context: context,
                sizeConfig: sizeConfig,
                color: Theme.of(context).primaryColor,
                title: AppLocalizations.of(context)!.translate("select_shiekh"),
                onPressed: () {
                  chooseSheikh(randomAzanId_value3);
                }),
          ),
        ],
      ),
    );
  }

  Widget fajrAzanShiekhPart() {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedCrossFade(
            firstChild: SizedBox(),
            secondChild: Container(
              margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 2),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    provider.pickedFajrAzanShiekh.isNotEmpty
                        ? "${provider.pickedFajrAzanShiekh["name"]}"
                        : "شيخ اذان الفجر",
                    style: TextStyle(
                        color: Constants.PRIMARY_DARK_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: sizeConfig.blockSizeHorizontal * 4),
                  ),
                ),
              ),
            ),
            crossFadeState: provider.pickedFajrAzanShiekh.isNotEmpty
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 200),
          ),
          Center(
            child: standardButton(
                isGo: true,
                context: context,
                sizeConfig: sizeConfig,
                color: Theme.of(context).primaryColor,
                title: AppLocalizations.of(context)!.translate("select_shiekh"),
                onPressed: chooseFajrSheikh),
          ),
        ],
      ),
    );
  }

  Widget azanTime() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: sizeConfig.blockSizeHorizontal * 90,
      height: 570,
      child: EditTimePrayer(
        showAppBar: false,

        // azan: azanValue,
        // updateAzan: listenToUpdate,
      ),
    );
  }

  Widget generalSettingsPart(Widget show) {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          alertItem(
              AppLocalizations.of(context)!
                  .translate("voice_reminder_before_praying"),
              provider.isRemmberActive,
              provider.isRemmberActiveFlagChanged),
          alertItem(
              AppLocalizations.of(context)!
                  .translate("activating_al_shaarawi_voice"),
              provider.isActivatingShaarawiVoice,
              provider.isActivatingShaarawiVoiceFlagChanged),
          alertItem(
              AppLocalizations.of(context)!
                  .translate("Switch_to_silent_mode_after_residence"),
              provider.isSwitchSilentModeAfterResidence,
              provider.isSwitchSilentModeAfterResidenceChanged),
          alertItem(
              AppLocalizations.of(context)!
                  .translate("Turn_off_the_call_to_prayer_on_the_phone"),
              provider.isTurnOffPrayerPhone,
              provider.isTurnOffPrayerPhoneChanged),
          Center(
            child: standardButton(
              isGo: false,
              context: context,
              sizeConfig: sizeConfig,
              color: Theme.of(context).primaryColor,
              title: AppLocalizations.of(context)!
                  .translate("Change_the_language_application"),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                      contentPadding: EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      content: show),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future saveSettings() async {
    provider.setViewState(ViewState.Loading);
    locator<Prefs>().setAzanMethod((AppLocalizations.of(context)!.isEnglish()
            ? Constants.EN_AZAN_METHODS
            : Constants.AR_AZAN_METHODS)
        .indexOf(provider.pickedMethod));

    locator<Prefs>().setAzanMazhab((AppLocalizations.of(context)!.isEnglish()
            ? Constants.EN_AZAN_Mazhabs
            : Constants.AR_AZAN_Mazhabs)
        .indexOf(provider.pickedMazhab));

    await AzanApis().getAzan();
    provider.setViewState(ViewState.Idle);
  }

  //we are working with azan id 3 only in this screen
  //when we save from here, we should save to all ids
  void chooseSheikh(String azanId) async {
    int newShiekhIndex = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PickAzanShiekhView(
              azanId,
              true,
            )));

    List<AzanSound>? sounds =
        (await LocalStorageManager().loadAzanSoundsList());

    if (sounds != null && sounds.length > 0) {
      provider.pickedAzanShiekhMain = {
        randomAzanId_value3: sounds[newShiekhIndex].name
      };
    } else {
      provider.pickedAzanShiekhMain = {
        randomAzanId_value3: AppLocalizations.of(context)!.isEnglish()
            ? Constants.EN_SHIEKH_NAMES[newShiekhIndex]["name"]
            : Constants.AR_SHIEKH_NAMES[newShiekhIndex]["name"]
      };
    }
  }

  void chooseFajrSheikh() async {
    int newShiekhIndex = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PickFajrAzanShiekhView()));
    List<AzanSound>? sounds =
        (await LocalStorageManager().loadFajrAzanSoundsList());
    if (sounds != null && sounds.length > 0) {
      provider.pickedFajrAzanShiekh = sounds[newShiekhIndex].toJSON();
    } else {
      provider.pickedFajrAzanShiekh = Constants.FAJR_SHIEKH_NAMES[0];
    }
  }

  Widget azanMethodPart() {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 85,
      margin: EdgeInsets.all(20),
      padding:
          EdgeInsets.symmetric(horizontal: sizeConfig.blockSizeHorizontal * 2),
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(sizeConfig.blockSizeHorizontal * 2),
          border: Border.all(color: Constants.ACCENT_COLOR, width: 1)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: provider.pickedMethod,
          hint: Text(
            AppLocalizations.of(context)!.translate("calculating_pray_method"),
            style: TextStyle(
                color: Colors.black,
                fontSize: sizeConfig.blockSizeHorizontal * 4,
                fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          items: (AppLocalizations.of(context)!.isEnglish()
                  ? Constants.EN_AZAN_METHODS
                  : Constants.AR_AZAN_METHODS)
              .map((f) {
            return DropdownMenuItem<Map<String, dynamic>>(
              child: Text(
                f["title"],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeConfig.blockSizeHorizontal * 3.5,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              value: f,
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              provider.pickedMethod = value;
            }
          },
        ),
      ),
    );
  }

  Widget highAltitudesPart() {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 85,
      margin: EdgeInsets.all(20),
      padding:
          EdgeInsets.symmetric(horizontal: sizeConfig.blockSizeHorizontal * 2),
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(sizeConfig.blockSizeHorizontal * 2),
          border: Border.all(color: Constants.ACCENT_COLOR, width: 1)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: provider.latitudeAdjustmentMethod.isNotEmpty
              ? provider.latitudeAdjustmentMethod
              : null,
          hint: Text(
            AppLocalizations.of(context)!.translate("un_used"),
            style: TextStyle(
                color: Colors.black,
                fontSize: sizeConfig.blockSizeHorizontal * 4,
                fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          items: (AppLocalizations.of(context)!.isEnglish()
                  ? Constants.EN_Latitude_Adjustment_Method
                  : Constants.AR_Latitude_Adjustment_Method)
              .map((f) {
            return DropdownMenuItem<Map<String, dynamic>>(
              child: Text(
                f["title"],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeConfig.blockSizeHorizontal * 3.5,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              value: f,
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              provider.latitudeAdjustmentMethod = value;
            }
          },
        ),
      ),
    );
  }

  Widget mazhabPart() {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 85,
      margin: EdgeInsets.all(20),
      padding:
          EdgeInsets.symmetric(horizontal: sizeConfig.blockSizeHorizontal * 2),
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(sizeConfig.blockSizeHorizontal * 2),
          border: Border.all(color: Constants.ACCENT_COLOR, width: 1)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: provider.pickedMazhab,
          hint: Text(
            AppLocalizations.of(context)!.translate("almazhab_in_your_country"),
            style: TextStyle(
                color: Colors.black,
                fontSize: sizeConfig.blockSizeHorizontal * 4,
                fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          items: (AppLocalizations.of(context)!.isEnglish()
                  ? Constants.EN_AZAN_Mazhabs
                  : Constants.AR_AZAN_Mazhabs)
              .map((f) {
            return DropdownMenuItem<Map<String, dynamic>>(
              child: Text(
                f["title"],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeConfig.blockSizeHorizontal * 3.5,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              value: f,
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              provider.pickedMazhab = value;
            }
          },
        ),
      ),
    );
  }

  Widget countrySelectionPart() {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   margin: EdgeInsets.only(top: 20, left: 30, right: 30),
          //   child: Text(
          //     AppLocalizations.of(context)!.translate("country_specify"),
          //     style: TextStyle(
          //         fontSize: sizeConfig.blockSizeHorizontal * 5,
          //         fontWeight: FontWeight.w700,
          //         color: Theme.of(context).primaryColor),
          //   ),
          // ),
          titleContainer(sizeConfig, context,
              AppLocalizations.of(context)!.translate("pick_azan_country")),
          _countryNameWidget(sizeConfig),
          autoDetectButton(sizeConfig, context),
          // _buildCountryPickerActivator(sizeConfig),
          // divider(sizeConfig, context),
        ],
      ),
    );
  }

  Widget autoDetectButton(SizingInformation sizeConfig, BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(
              top: sizeConfig.blockSizeVertical * 2,
              bottom: sizeConfig.blockSizeVertical,
              left: sizeConfig.blockSizeVertical * 5,
              right: sizeConfig.blockSizeVertical * 5),
          width: sizeConfig.blockSizeHorizontal * 70,
          child: LoadingButton(
            firstWidget: RawMaterialButton(
              padding: EdgeInsets.symmetric(
                  vertical: sizeConfig.blockSizeVertical * 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      sizeConfig.blockSizeHorizontal * 2)),
              onPressed: () async {
                provider.saveLocation = true;
                await locationProvider.getLocation(context);
                provider.saveLocation = false;
              },
              fillColor: Theme.of(context).colorScheme.secondary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: Constants.CANVAS_COLOR,
                    size: sizeConfig.blockSizeHorizontal * 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.translate("auto_detect"),
                    style: TextStyle(
                      fontSize: sizeConfig.blockSizeHorizontal * 4.3,
                      color: Constants.CANVAS_COLOR,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            state: provider.saveLocation
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          )),
    );
  }

  Widget titleContainer(
      SizingInformation sizeConfig, BuildContext context, String text) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(60, 5, 10, 0),
      child: Text(
        text,
        style: TextStyle(
            fontSize: sizeConfig.blockSizeHorizontal * 4,
            fontWeight: FontWeight.w400,
            color: Constants.MAIN_TEXT_COLOR),
      ),
    );
  }

  // Widget _buildCountryPickerActivator(SizingInformation sizeConfig) {
  //   return Align(
  //       alignment: AlignmentDirectional.centerEnd,
  //       child: Container(
  //         margin: EdgeInsets.symmetric(
  //             vertical: sizeConfig.blockSizeVertical,
  //             horizontal: sizeConfig.blockSizeVertical * 5),
  //         width: sizeConfig.blockSizeHorizontal * 70,
  //         child: RawMaterialButton(
  //           padding: EdgeInsets.symmetric(
  //               vertical: sizeConfig.blockSizeVertical * 1.5),
  //           shape: RoundedRectangleBorder(
  //               borderRadius:
  //                   BorderRadius.circular(sizeConfig.blockSizeHorizontal * 2)),
  //           onPressed: () async {
  //             var result = await Navigator.of(context)
  //                 .pushNamed("/pick_location_via_map_view");
  //             if (result != null) {
  //               locationProvider.setPlace(result as Place);
  //             }
  //           },
  //           fillColor: Theme.of(context).primaryColor,
  //           child: Text(
  //             AppLocalizations.of(context)!.translate("or_choose_manual"),
  //             style: TextStyle(
  //               fontSize: sizeConfig.blockSizeHorizontal * 5,
  //               color: Constants.CANVAS_COLOR,
  //               fontWeight: FontWeight.w900,
  //             ),
  //           ),
  //         ),
  //       ));
  // }

  Widget _countryNameWidget(SizingInformation sizeConfig) {
    return AnimatedCrossFade(
        firstChild: SizedBox(),
        secondChild: Container(
          margin:
              EdgeInsets.symmetric(vertical: sizeConfig.blockSizeVertical * 2),
          child: Center(
            child: Text(
              "${locationProvider.countryName}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Constants.PRIMARY_DARK_COLOR,
                  fontWeight: FontWeight.w700,
                  fontSize: sizeConfig.blockSizeHorizontal * 4),
            ),
          ),
        ),
        crossFadeState: locationProvider.countryName.isEmpty
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 200));
  }

  Widget alertItem(String title, bool value, dynamic function) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 10),
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
                  onChanged: (value) {
                    function(value);
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
        // divider(sizeConfig, context)
      ],
    );
  }

  Container divider(SizingInformation sizeConfig, BuildContext context) {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 90,
      color: Theme.of(context).primaryColorDark.withOpacity(.4),
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    );
  }

  void listenToUpdate() {}
}
