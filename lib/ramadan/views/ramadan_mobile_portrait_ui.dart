import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/ramadan/models/ramadan_cannon_model.dart';
import 'package:muslim_book/ramadan/provider/ramadan_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:muslim_book/utils/time_ui/analog_time_picker.dart';
import 'package:muslim_book/views/edit_time_prayer_view/flutter_time_picker_spinner.dart';
import 'package:muslim_book/widgets/popover.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RamadanMobilePortraitUi {
  late final RamadanProvider provider;
  late final BuildContext context;
  Map<String, DateTime> _dateTime = Map();

  RamadanMobilePortraitUi(
      {required this.provider,  required this.context,});




  Widget drumMethodPart() {
    return Container(
      width:  MediaQuery.of(context).size.width ,
      margin: EdgeInsets.all(20),
      padding:
      EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(13),
          border: Border.all(color: Constants.ACCENT_COLOR, width: 1,),),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: provider.ramadanMashraatSelected,
          hint: Text(
            AppLocalizations.of(context)!.translate("sound_mashraat_chosen"),
            style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,),
            overflow: TextOverflow.ellipsis,
          ),
          items: provider.ramadanMashraatModel.map((f) {
            return DropdownMenuItem<RamadanSoundsModel>(
              child: Text(
                f.name??'',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              value: f,
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              provider.ramadanMashraatSelected = value as RamadanSoundsModel;
            }
          },
        ),
      ),
    );
  }
  Widget drumRepetitionsPart() {
    return Container(
      width:  MediaQuery.of(context).size.width ,
      margin: EdgeInsets.all(20),
      padding:
      EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(13),
          border: Border.all(color: Constants.ACCENT_COLOR, width: 1)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: provider.repetitionsSelected,
          hint: Text(
            AppLocalizations.of(context)!.translate("sound_repetitions_chosen"),
            style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          items: provider.repetitions.map((f) {
            return DropdownMenuItem<Repetitions>(
              child: Text(
                f.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              value: f,
            );
          }).toList(),
          onChanged: (value) {
            // if (value != null) {
            //   provider.ramadanCannonSelected = value.;
            // }
          },
        ),
      ),
    );
  }
  Widget drumaAlarmTimePart() {
    return  InkWell(
      onTap: (){
        _showModalSheet();
      },
      child:   Container(
        width:  MediaQuery.of(context).size.width ,
        margin: EdgeInsets.all(20),

        padding:
        EdgeInsets.symmetric(horizontal: 12 ,vertical: 19),
        decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(13),
            border: Border.all(color: Constants.ACCENT_COLOR, width: 1)),
        child: Text(
          AppLocalizations.of(context)!.translate("sound_mashraat_chosen"),
          style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
      ),

    );

  }










  void _showModalSheet() {
    showModalBottomSheet(context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: true,
//        useRootNavigator: true,
        builder: (builder) {
          return  Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: AnalogTimePicker(
                onChanged: getDayTime,
              )
          );
        }
    );
  }
  void getDayTime(Map value) {
    _dateTime = value as Map<String, DateTime>;
  }

  Widget titleContainer(
      BuildContext context, String text) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(20, 5, 10, 0),
      child: Text(
        text,
        style: TextStyle(
            // fontSize: sizeConfig.blockSizeHorizontal * 4,
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


  Widget alertItem(String title, bool value, Function function) {
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
                      // fontSize: sizeConfig.blockSizeHorizontal * 4,
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

  void listenToUpdate() {
  }
  void handleFABPressed() {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Popover(
          child: Container(
            height: 300,
            // color: Colors.lightBlue,
            child: _showCupertinoDatePicker(
                       provider.dateMshart ,
                  provider.ramadanMshartTimeChanged),
            ),
          //   child: hourMinute12HCustomStyle(
          //            provider.dateMshart ,
          //       provider.ramadanMshartTimeChanged),
          // ),
        );
      },
    );
  }
  Widget _showCupertinoDatePicker(DateTime dateTime , Function function){
    return CupertinoDatePicker(
      initialDateTime: dateTime,
      onDateTimeChanged: (DateTime newDate) {
        function(newDate);
      },
       mode: CupertinoDatePickerMode.time,
    );
  }
  Widget hourMinute12HCustomStyle(DateTime dateTime , Function function){
    return
      TimePickerSpinner(
        // is24HourMode: false,
        normalTextStyle: TextStyle(
            fontSize: 24,
            color: Colors.deepOrange
        ),
        highlightedTextStyle: TextStyle(
            fontSize: 24,
            color: Colors.yellow
        ),
        spacing: 50,
        itemHeight: 80,
        // isForce2Digits: true,
        minutesInterval: 15,
        onTimeChange: (time) {
          // setState(() {
          //   _dateTime = time;
          // });
        },
      );
    //   TimePickerSpinner(
    //   is24HourMode: false,
    //   normalTextStyle: TextStyle(
    //       fontSize: 24,
    //     color:Colors.grey,
    //
    //    ),
    //   highlightedTextStyle: TextStyle(
    //       fontSize: 24,
    //     fontWeight: FontWeight.bold,
    //     color: Theme.of(context).primaryColor,
    //
    //   ),
    //     itemHeight: 90,
    //   isForce2Digits: true,
    //   time: dateTime,
    //   minutesInterval: 1,
    //   onTimeChange: (time) {
    //     function(time);
    //
    //   },
    // );
  }
}
