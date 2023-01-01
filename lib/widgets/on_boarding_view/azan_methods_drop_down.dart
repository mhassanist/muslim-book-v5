import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/pick_azan_methods_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MethodsDropDown extends StatelessWidget {
  const MethodsDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<PickAzanMethodsProvider>(context);
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
            isExpanded: true,
            value: model.pickedMethod,
            hint: Text(
              AppLocalizations.of(context)!.translate("calculating_pray_method"),
              style: textStyle(sizeConfig),
              overflow: TextOverflow.ellipsis,
            ),
            items: (AppLocalizations.of(context)!.isEnglish()
                ? Constants.EN_AZAN_METHODS
                : Constants.AR_AZAN_METHODS)
                .map((f) {
              return DropdownMenuItem<Map<String,dynamic>>(
                child: Text(
                  f["title"],
                  style: textStyle(sizeConfig),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                value: f,
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                model.pickedMethod = value;
              }
            },
          ),
        ),
      );
    });
  }

  TextStyle textStyle(SizingInformation sizeConfig) {
    return TextStyle(
      color: Colors.black,
      fontSize: sizeConfig.blockSizeHorizontal * 4,
      fontWeight: FontWeight.w600,
    );
  }
}

// class MethodsDropDown extends BaseModelWidget<PickAzanMethodsProvider> {
//
//   @override
//   Widget build(BuildContext context,model) {
//     return ResponsiveBuilder(builder: (context, sizeConfig) {
//       return Container(
//         margin: EdgeInsets.symmetric(vertical: sizeConfig.blockSizeVertical * 3),
//         padding: EdgeInsets.symmetric(
//             horizontal: sizeConfig.blockSizeHorizontal * 2),
//         decoration: BoxDecoration(
//             borderRadius:
//                 BorderRadius.circular(sizeConfig.blockSizeHorizontal * 2),
//             border: Border.all(color: Constants.ACCENT_COLOR, width: 1)),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton(
//             isExpanded: true,
//             value: model.pickedMethod,
//             hint: Text(
//               AppLocalizations.of(context)!.translate("calculating_pray_method"),
//               style: textStyle(sizeConfig),
//               overflow: TextOverflow.ellipsis,
//             ),
//             items: (AppLocalizations.of(context)!.isEnglish()
//                     ? Constants.EN_AZAN_METHODS
//                     : Constants.AR_AZAN_METHODS)
//                 .map((f) {
//               return DropdownMenuItem<Map<String,dynamic>>(
//                 child: Text(
//                   f["title"],
//                   style: textStyle(sizeConfig),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 value: f,
//               );
//             }).toList(),
//             onChanged: (value) {
//               if (value != null) {
//                 model.pickedMethod = value;
//               }
//             },
//           ),
//         ),
//       );
//     });
//   }
//
//   TextStyle textStyle(SizingInformation sizeConfig) {
//     return TextStyle(
//
//         color: Colors.black, fontSize: sizeConfig.blockSizeHorizontal * 4 , fontWeight: FontWeight.w600);
//   }
// }
