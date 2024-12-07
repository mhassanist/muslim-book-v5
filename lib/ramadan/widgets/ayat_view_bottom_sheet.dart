import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AyatViewBottomSheet extends StatelessWidget {
  final VoidCallback? saveProgress;

  const AyatViewBottomSheet({super.key, this.saveProgress,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(100),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.history),
            onTap: saveProgress?.call,
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
