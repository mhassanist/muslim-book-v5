import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AyatViewBottomSheet extends StatelessWidget {
  final Function saveProgress;

  const AyatViewBottomSheet({Key key, this.saveProgress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(100),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.history),
            onTap: saveProgress,
            title: Text(
              AppLocalizations.of(context)!.translate("saveAyah"),
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
