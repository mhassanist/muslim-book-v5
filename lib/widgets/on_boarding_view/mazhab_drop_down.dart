import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/providers/pick_azan_methods_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/widgets/base_model_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../utils/sizing_info_extension.dart';

class MazhabsDropDown extends BaseModelWidget<PickAzanMethodsProvider> {
  @override
  Widget build(BuildContext context,model) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: sizeConfig.blockSizeVertical * 3),
        padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.blockSizeHorizontal * 2),
        decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(sizeConfig.blockSizeHorizontal * 2),
            border: Border.all(color: Constants.ACCENT_COLOR, width: 1)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: model.pickedMazhab,
            hint: Text(
              AppLocalizations.of(context).translate("almazhab_in_your_country"),
              style: textStyle(sizeConfig),
              overflow: TextOverflow.ellipsis,
            ),
            items: (AppLocalizations.of(context).isEnglish()
                ? Constants.EN_AZAN_Mazhabs
                : Constants.AR_AZAN_Mazhabs)
                .map((f) {
              return DropdownMenuItem<Map<String,dynamic>>(
                child: Text(
                  f["title"],
                  style: textStyle(sizeConfig),
                  overflow: TextOverflow.ellipsis,
                ),
                value: f,
              );
            }).toList(),
            onChanged: (value) {
              model.pickedMazhab = value;
            },
          ),
        ),
      );
    });
  }

  TextStyle textStyle(SizingInformation sizeConfig) {
    return TextStyle(
        color: Colors.black, fontSize: sizeConfig.blockSizeHorizontal * 4 , fontWeight: FontWeight.w600);
  }
}
