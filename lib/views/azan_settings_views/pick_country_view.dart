import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/location_provider.dart';
import 'package:muslim_book/providers/pick_azan_methods_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/appBar_widget.dart';
import 'package:muslim_book/widgets/base_widget.dart';
import 'package:muslim_book/widgets/general_wigets/loading_button.dart';
import 'package:muslim_book/widgets/on_boarding_view/azan_methods_drop_down.dart';
import 'package:muslim_book/widgets/on_boarding_view/save_settings_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../utils/sizing_info_extension.dart';

class PickCountryView extends StatefulWidget {
  @override
  _PickCountryViewState createState() => _PickCountryViewState();
}

class _PickCountryViewState extends State<PickCountryView> {
  late LocationProvider _provider;
  late PickAzanMethodsProvider pickAzanMethodsProvider;

  late SizingInformation sizeConfig;

  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return BaseView<PickAzanMethodsProvider>(onModelReady: (model) {
        pickAzanMethodsProvider = model;
        pickAzanMethodsProvider.provideDefaultValueToMazhab(context);
        pickAzanMethodsProvider.provideDefaultValueToMethod(context);
      }, builder: (_, model, __) {
        return BaseView<LocationProvider>(
            onModelReady: (model) => _provider = model,
            builder: (_, model, __) {
              return SafeArea(
                child: Scaffold(
                  appBar: appBar(context, sizeConfig,
                      AppLocalizations.of(context)!.translate("set_location")),
                  body: ResponsiveBuilder(builder: (context, sizeConfig) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: sizeConfig.blockSizeVertical * 87),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Image.asset(
                                  "assets/images/onboarding/country_picker.png"),
                            ),

                            titleContainer(sizeConfig, context),
                            // divider(sizeConfig, context),
                            _countryNameWidget(sizeConfig),
                            autoDetectButton(sizeConfig, context),

//                            manuallyChooseTitleContainer(sizeConfig, context),
                            // _buildCountryPickerActivator(sizeConfig),
                            divider(sizeConfig, context),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 30, right: 30),
                              child: titleContainer2(
                                AppLocalizations.of(context)!
                                    .translate("calculating_pray_method"),
                                sizeConfig,
                                context,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: const MethodsDropDown(),
                            ),
                            saveCountryButton(sizeConfig, context)
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              );
            });
      });
    });
  }

  Container divider(SizingInformation sizeConfig, BuildContext context) {
    return Container(
      width: sizeConfig.blockSizeHorizontal * 80,
      color: Theme.of(context).primaryColorDark.withOpacity(.4),
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 20),
    );
  }

  Widget autoDetectButton(SizingInformation sizeConfig, BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: sizeConfig.blockSizeVertical),
        width: sizeConfig.blockSizeHorizontal * 75,
        child: LoadingButton(
          firstWidget: RawMaterialButton(
            padding: EdgeInsets.symmetric(
                vertical: sizeConfig.blockSizeVertical * 1.5),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(sizeConfig.blockSizeHorizontal * 2)),
            onPressed: () async {
              _provider.setViewState(ViewState.Loading);
              // Provider.of<PickAzanMethodsProvider>(context , listen: false).saveSettings(context);
              await _provider.getLocation(context);
              _provider.setViewState(ViewState.Idle);
            },
            fillColor: Theme.of(context).primaryColor,
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
                    fontSize: sizeConfig.blockSizeHorizontal * 5,
                    color: Constants.CANVAS_COLOR,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          state: _provider.viewState == ViewState.Loading
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ));
  }

  Widget titleContainer(SizingInformation sizeConfig, BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.translate("pick_azan_country"),
      style: TextStyle(
          fontSize: sizeConfig.blockSizeHorizontal * 5,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor),
    );
  }

  Widget titleContainer2(
      String text, SizingInformation sizeConfig, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: sizeConfig.blockSizeHorizontal * 5,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor),
    );
  }

  // Widget manuallyChooseTitleContainer(
  //     SizingInformation sizeConfig, BuildContext context) {
  //   return Text(
  //     AppLocalizations.of(context)!.translate("or_choose_manual"),
  //     style: TextStyle(
  //         fontSize: sizeConfig.blockSizeHorizontal * 5,
  //         fontWeight: FontWeight.w700,
  //         color: Theme.of(context).primaryColor),
  //   );
  // }

  Widget saveCountryButton(sizeConfig, context) {
    return SaveSettingsButton(
      onTap: () => _provider.saveCountry(context),
      state: _provider.viewState == ViewState.Loading
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      text: "save_timing_settings",
    );
  }

  // Widget _buildCountryPickerActivator(SizingInformation sizeConfig) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: sizeConfig.blockSizeVertical * 3),
  //     width: sizeConfig.blockSizeHorizontal * 75,
  //     child: RawMaterialButton(
  //       padding:
  //           EdgeInsets.symmetric(vertical: sizeConfig.blockSizeVertical * 1.5),
  //       shape: RoundedRectangleBorder(
  //           borderRadius:
  //               BorderRadius.circular(sizeConfig.blockSizeHorizontal * 2)),
  //       onPressed: () async {
  //         _provider.enablePicker = true;
  //         var result = await Navigator.of(context)
  //             .pushNamed("/pick_location_via_map_view");
  //         if (result != null) {
  //           print(result.toString());
  //           _provider.setPlace(result as Place);
  //           if (_provider.viewState == ViewState.Loading) {
  //             _provider.setViewState(ViewState.Idle);
  //           }
  //         }
  //       },
  //       fillColor: Theme.of(context).primaryColor,
  //       child: Text(
  //         AppLocalizations.of(context)!.translate("or_choose_manual"),
  //         style: TextStyle(
  //           fontSize: sizeConfig.blockSizeHorizontal * 5,
  //           color: Constants.CANVAS_COLOR,
  //           fontWeight: FontWeight.w900,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _countryNameWidget(SizingInformation sizeConfig) {
    return AnimatedCrossFade(
        firstChild: const SizedBox(),
        secondChild: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: sizeConfig.blockSizeVertical),
          margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 2),
          child: Text(
            "${_provider.countryName}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Constants.PRIMARY_DARK_COLOR,
                fontWeight: FontWeight.w700,
                fontSize: sizeConfig.blockSizeHorizontal * 4),
          ),
        ),
        crossFadeState: _provider.countryName == null
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 200));
  }
}
