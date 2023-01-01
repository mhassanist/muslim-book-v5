import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/general_wigets/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../utils/sizing_info_extension.dart';

class LoadMoreAzanSoundsButton extends StatelessWidget {
  final CrossFadeState state;
  final Function? onTap;
  final String text;

  const LoadMoreAzanSoundsButton({
    super.key,
    required this.state,
    this.onTap,
    this.text = "press_here",
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return LoadingButton(
        firstWidget: Container(
          margin: EdgeInsets.symmetric(
              vertical: sizeConfig.blockSizeVertical * 1.5,),
          width: sizeConfig.blockSizeHorizontal * 40,
          child: RawMaterialButton(
              padding: EdgeInsets.symmetric(
                  vertical: sizeConfig.blockSizeVertical * 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      sizeConfig.blockSizeHorizontal * 2)),
              onPressed: () => onTap?.call(),
              fillColor: Theme.of(context).primaryColor,
              child: Text(
                AppLocalizations.of(context)!.translate("$text"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: sizeConfig.blockSizeHorizontal * 5,
                  color: Constants.CANVAS_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              )),
        ),
        state: state,
      );
    });
  }
}
