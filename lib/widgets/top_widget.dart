import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../utils/sizing_info_extension.dart';

Widget topWidget(
    key, context, SizingInformation sizeConfig, String title, bool iconVisible,
    {Color? color}) {
  return Container(
    height: sizeConfig.blockSizeVertical * 10,
    child: Row(
      children: <Widget>[
        SizedBox(),
        Text(
          title,
          style: TextStyle(
            fontSize: sizeConfig.blockSizeHorizontal * 5,
          ),
        ),
      ],
    ),
  );
}
