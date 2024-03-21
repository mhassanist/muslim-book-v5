import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/more/view/banner_view.dart';
import 'package:muslim_book/text_styles.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

import 'package:responsive_builder/responsive_builder.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
      // allowFontScaling: true,
    );
    return ResponsiveBuilder(builder: (context, SizingInformation sizeConfig) {
      return AppScaffold(
        addImageProfile: false,
        leading: InkWell(
          child: Container(
            margin: const EdgeInsetsDirectional.only(start: 10),
            padding: const EdgeInsets.all(5),
            height: 28,
            width: 20,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate("more"),
          style: almaraiTextStyle?.copyWith(
            fontSize: ScreenUtil().setSp(20),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: BannersView(),
      );
    });
  }
}
