import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AyatViewBottomSheet extends StatelessWidget {
  final Function? saveProgress;

  const AyatViewBottomSheet({super.key, this.saveProgress});

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
              "إحفظها كآخر آية",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
