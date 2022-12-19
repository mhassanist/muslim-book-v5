import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/changePassword_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/appBar_widget.dart';
import 'package:muslim_book/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'changePassword_mobile_portrait_ui.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late ChangePasswordUI ui;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return BaseView<ChangePasswordProvider>(onModelReady: (model) async {
        ui = ChangePasswordUI(model, sizeConfig, context);
      }, builder: (_, model, __) {
        return SafeArea(
          child: Scaffold(
            appBar: appBar(context, sizeConfig,
                AppLocalizations.of(context)!.translate("change_password"),
                key: key),
            body: Container(
              color: Constants.CANVAS_COLOR,
              child: ListView(
                padding: EdgeInsets.only(bottom: 20),
                children: <Widget>[
                  // ui.screenHeader(),
                  ui.userImage(),
                  ui.textWidget(),
                  ui.inputTextForm(),
                  ui.sendDataButtons(),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
