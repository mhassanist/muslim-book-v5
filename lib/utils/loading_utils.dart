import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'Constants.dart';

class LoadingUtils {
  setIsLoading(BuildContext context, bool condition) {
    ProgressDialog pr = new ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal);
    if (condition) {
      pr.style(
          message: AppLocalizations.of(context).translate("please_wait"),
          borderRadius: 10.0,
          backgroundColor: Constants.CANVAS_COLOR,
          progressWidget: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator()),
            ],
          ),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(color: Colors.black, fontSize: 8.0),
          messageTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
          ));
      pr.show();
    } else {
      Navigator.pop(context);
    }
  }
}
