import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/widgets/standardButton_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../utils/sizing_info_extension.dart';

Widget loginButton(BuildContext context, SizingInformation sizeConfig) {
  return standardButton(
      isGo: true,
      margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical),
      context: context,
      sizeConfig: sizeConfig,
      color: Theme.of(context).primaryColorDark,
      title: AppLocalizations.of(context)!.translate("login"),
      onPressed: () async {
        await Navigator.pushNamed(context, "/login");
        Provider.of<UserProvider>(context, listen: false).errorMessage = "";
      });
}

Widget signupButton(BuildContext context, SizingInformation sizeConfig) {
  return standardButton(
      isGo: true,
      margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical),
      context: context,
      sizeConfig: sizeConfig,
      color: Theme.of(context).primaryColorDark,
      title: AppLocalizations.of(context)!.translate("create_account"),
      onPressed: () async {
        await Navigator.pushNamed(context, "/signup_view");
        Provider.of<UserProvider>(context, listen: false).errorMessage = "";
      });
}

Widget pleaseLoginOrSignUp(BuildContext context, SizingInformation sizeConfig) {
  return Padding(
    padding: EdgeInsets.all(sizeConfig.blockSizeVertical * 2),
    child: Text(
      AppLocalizations.of(context)!.translate("please_login_signup"),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: sizeConfig.blockSizeHorizontal * 5,
        color: Theme.of(context).primaryColorDark,
      ),
      maxLines: 3,
      textAlign: TextAlign.center,
    ),
  );
}
