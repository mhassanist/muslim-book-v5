import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../utils/sizing_info_extension.dart';

Widget logo(SizingInformation sizeConfig) {
    return Padding(
      padding:  EdgeInsets.all(sizeConfig.blockSizeVertical * 3),
      child: Container(
        width: sizeConfig.blockSizeHorizontal * 20,
        height: sizeConfig.blockSizeHorizontal * 40,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/general/logo.png'),
            fit: BoxFit.fitHeight,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }