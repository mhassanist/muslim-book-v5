import 'package:base_app/ads/admob_rectangle.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/models/banner_names_enum.dart';
import 'package:base_app/widgets/app_scaffold.dart';
import 'package:base_app/widgets/app_scaffold_title.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'islamics_screen.dart';

class IslamicsView extends StatefulWidget {
  const IslamicsView({Key key}) : super(key: key);

  @override
  _IslamicsViewState createState() => _IslamicsViewState();
}

class _IslamicsViewState extends State<IslamicsView> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, SizingInformation sizeConfig){
          return AppScaffold(
            title: AppScaffoldTitleWidget(title: AppLocalizations.of(context).translate("more")),
            centerTitle: true,
            child: Container(
                child:Container(
                  child: Column(
                    children: <Widget>[
                      IslamicsScreen(),
                      Container(
                          height: 200,
                          child: AdMobRectangle(BannerName.AZKAR)),
                    ],
                  ),
                )
            ),
          );
        }
    );
  }
}
