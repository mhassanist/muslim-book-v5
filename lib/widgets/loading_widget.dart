import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/widgets/progress_dialog_pkg/progress_dialog.dart';

setIsLoading(BuildContext context, bool condition) {
  final pr = ProgressDialog(
    context,
    isDismissible: true,
    type: ProgressDialogType.Normal,
  );
  if (condition) {
    pr.style(
        message: AppLocalizations.of(context)!.translate("please_wait"),
        borderRadius: 10.0,
        backgroundColor: Constants.CANVAS_COLOR,
        progressWidget: CircularProgressIndicator(),
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
