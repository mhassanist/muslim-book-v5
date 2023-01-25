import 'package:muslim_book/azkar_feature/views/azkar_view.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:muslim_book/widgets/share_dialog.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ZikrListWidget extends StatefulWidget {
  ZikrListWidget({
    super.key,
    required this.sizeConfig,
    required this.zikrDetails,
  });
  final SizingInformation sizeConfig;
  final Map<String, String> zikrDetails;

  @override
  _ZikrListWidgetState createState() => _ZikrListWidgetState();
}

class _ZikrListWidgetState extends State<ZikrListWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Get.to(AzkarView(
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

      // child: Container(
      //   margin: EdgeInsets.all(10),
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //       color: const Color(0XFFF1F6F3),
      //       borderRadius: BorderRadius.circular(20)),
      //   child: Stack(
      //     children: [
      //       Align(
      //         alignment: Alignment.topLeft,
      //         child: Container(
      //           margin: EdgeInsets.all(15),
      //           padding: EdgeInsets.all(5),
      //           decoration: BoxDecoration(
      //             color: const Color(0XFF347D53),
      //             shape: BoxShape.circle,
      //           ),
      //           child: Icon(
      //             Icons.arrow_forward,
      //             color: Colors.white,
      //           ),
      //         ),
      //       ),
      //       Align(
      //         alignment: Alignment.bottomLeft,
      //         child: Image.asset("assets/images/azkar_view/book.png"),
      //       ),
      //       Container(
      //         margin: EdgeInsets.all(widget.sizeConfig.blockSizeHorizontal * 4),
      //         alignment: Alignment.bottomLeft,
      //         child: Container(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.end,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 "أذكار",
      //                 style: TextStyle(
      //                   color: const Color(0XFF347D53),
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: widget.sizeConfig.blockSizeVertical / 2,
      //               ),
      //               Row(
      //                 children: [
      //                   Expanded(
      //                     child: Text(
      //                       widget.zikrDetails["name"],
      //                       style: TextStyle(
      //                           color: const Color(0XFF347D53),
      //                           fontSize:
      //                               widget.sizeConfig.blockSizeHorizontal * 5,
      //                           fontWeight: FontWeight.bold),
      //                     ),
      //                   ),
      //                 ],
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
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
