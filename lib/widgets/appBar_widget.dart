import 'package:muslim_book/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:responsive_builder/responsive_builder.dart';

PreferredSizeWidget appBar(
  context,
  SizingInformation sizeConfig,
  String title, {
  Color? backgroundColor,
  key,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: backgroundColor ?? Constants.CANVAS_COLOR,
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: sizeConfig.blockSizeHorizontal * 5,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ),
  );
}
