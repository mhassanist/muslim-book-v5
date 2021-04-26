import 'package:base_app/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../utils/sizing_info_extension.dart';


Widget standardButton({
  BuildContext context,
  SizingInformation sizeConfig,
  bool isGo,
  //int widthPercent,
  Color color,
  String title,
  Function onPressed,
  EdgeInsets margin,
  
}) {
  return Column(
    children: <Widget>[
      Container(
        width: sizeConfig.blockSizeHorizontal * 80,
        height: sizeConfig.blockSizeVertical * 7,
        margin: margin??EdgeInsets.only( top: 20, bottom: 20),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10)),
        child: FlatButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: isGo ?MainAxisAlignment.spaceBetween :MainAxisAlignment.center,

            children: <Widget>[
              if(isGo)

                SizedBox(
                width: sizeConfig.blockSizeHorizontal * 5,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Constants.CANVAS_COLOR,
                    fontSize: sizeConfig.blockSizeHorizontal * 4,
                    fontWeight: FontWeight.bold),
              ),
              if(isGo)
              Icon(
                Icons.arrow_forward_ios,
                color: Constants.CANVAS_COLOR,
                size: sizeConfig.blockSizeHorizontal * 5,
              )
            ],
          ),
        ),
      ),
    ],
  );
}
