
import 'package:muslim_book/azkar_feature/screens/azkar_carousel_screen.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:muslim_book/widgets/share_dialog.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AzkarCategoriesGridItem extends StatefulWidget {
  AzkarCategoriesGridItem({
    super.key,
    required this.sizeConfig,
    required this.zikrDetails,
  });
  final SizingInformation sizeConfig;
  final Map<String, String> zikrDetails;

  @override
  _AzkarCategoriesGridItemState createState() =>
      _AzkarCategoriesGridItemState();
}

class _AzkarCategoriesGridItemState extends State<AzkarCategoriesGridItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Get.to(() => AzkarCarouselScreen(
              zikr: widget.zikrDetails,
            ));
        checkShareDialogHistory();
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
              shape: BoxShape.circle,
            ),
            child: ExtendedImage.asset(
              "assets/images/azkar_view/${widget.zikrDetails["image"]}",
              fit: BoxFit.cover,
              width: widget.sizeConfig.blockSizeHorizontal * 15,
              height: widget.sizeConfig.blockSizeHorizontal * 15,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${widget.zikrDetails["name"]}",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  void checkShareDialogHistory() async {
    String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String? lastUpdate = locator<Prefs>().lastUpdatedShowShareDialogTap;
    if (lastUpdate != null && lastUpdate != todayDate) {
      Get.dialog(ShareDialog());
    }
    locator<Prefs>().setLastUpdatedShowShareDialogTap(todayDate);
  }
}
