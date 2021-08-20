import 'package:base_app/azan_feature/controllers/azan_controller.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/sizing_info_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
//import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BannerItem extends StatelessWidget {
  final String icon;
  final String title;
  final String sub;
  final bool selected;
  final String title_button;

  const BannerItem(
      {Key key,
      this.icon,
      this.title,
      this.sub,
      this.selected,
      this.title_button})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AzanController controller = Get.find<AzanController>();

    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
              color: Colors.black12,
              margin: EdgeInsets.symmetric(vertical: 5),
              height: sizeConfig.blockSizeVertical * 18,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      icon,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate(title),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: sizeConfig.blockSizeHorizontal * 4),
                          ),
                          SizedBox(
                            height: sizeConfig.blockSizeVertical,
                          ),
                          Text(
                            AppLocalizations.of(context).translate(sub),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: sizeConfig.blockSizeHorizontal * 2.9),
                          ),
                          SizedBox(
                            height: sizeConfig.blockSizeVertical,
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: sizeConfig.blockSizeHorizontal * 4,
                                vertical: sizeConfig.blockSizeVertical),
                            child: RawMaterialButton(
                              onPressed: () {},
                              elevation: 5,
                              padding: EdgeInsets.symmetric(
                                  vertical: sizeConfig.blockSizeVertical * .5),
                              shape: StadiumBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate(title_button),
                                    style: TextStyle(
                                        color: Constants.PRIMARY_DARK_COLOR,
                                        fontSize:
                                            sizeConfig.blockSizeHorizontal * 3),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Constants.PRIMARY_DARK_COLOR,
                                    size: 20,
                                  ),
                                ],
                              ),
                              fillColor: Colors.white,
                            ),
                          ),
                        ],
                      )),
                      Expanded(child: Container()),
                    ],
                  ),
                ],
              )));
    });
  }
}
