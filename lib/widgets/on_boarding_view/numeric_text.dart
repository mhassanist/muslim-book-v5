import 'package:base_app/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../utils/sizing_info_extension.dart';

class OnBoardingNumericText extends StatelessWidget {

  OnBoardingNumericText(this.firstText,this.number , {this.secondText});
  final String firstText;
  final String number;
  final String secondText;
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizeConfig) {
        return Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(sizeConfig.blockSizeHorizontal * 2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Constants.ACCENT_SECONDARY_COLOR,
                    width: sizeConfig.blockSizeHorizontal / 2),
              ),
              child: Text(
                number,
                style: textStyle(Constants.ACCENT_SECONDARY_COLOR,
                    FontWeight.w900, sizeConfig.blockSizeHorizontal * 2.5),
              ),
            ),
            SizedBox(
              width: sizeConfig.blockSizeHorizontal * 2,
            ),
            RichText(
              text: TextSpan(
                style: textStyle(Constants.CANVAS_COLOR, FontWeight.w400,
                    sizeConfig.blockSizeHorizontal * 4),
                children: [
                  TextSpan(text: firstText),
                  TextSpan(
                    text: secondText,
                    style: textStyle(Constants.CANVAS_COLOR, FontWeight.w700,
                        sizeConfig.blockSizeHorizontal * 4),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );

  }

  TextStyle textStyle(color, weight, double size) {
    return TextStyle(
        fontWeight: weight, color: color, fontFamily: "arabic", fontSize: size);
  }

}
