import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DownloadingTranslationWidget extends StatefulWidget {
  @override
  _DownloadingTranslationWidgetState createState() =>
      _DownloadingTranslationWidgetState();
}

class _DownloadingTranslationWidgetState
    extends State<DownloadingTranslationWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(
            ScreenUtil().setWidth(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width / 100 * 70,
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ScreenUtil().setWidth(10),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SpinKitDoubleBounce(
                  color: Theme.of(context).primaryColor,
                  size: 35.0,
                  controller: AnimationController(
                    vsync: this,
                      duration: const Duration(milliseconds: 1200)),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Text(
                  "جاري التحميل",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
