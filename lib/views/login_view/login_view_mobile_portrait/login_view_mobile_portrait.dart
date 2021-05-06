import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/app_form_controller.dart';
import 'package:base_app/views/login_view/login_view_mobile_portrait/login_mobile_portrait_ui.dart';
import 'package:base_app/widgets/appBar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginViewMobilePortrait extends StatefulWidget {
  @override
  _LoginViewMobilePortraitState createState() =>
      _LoginViewMobilePortraitState();
}

class _LoginViewMobilePortraitState extends State<LoginViewMobilePortrait> {
  LoginMobilePortraitUi ui;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final AppFormControllers controller = AppFormControllers();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context,listen: false).errorMessage = "";
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ui = LoginMobilePortraitUi( context,controller);

  }
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (_, sizeConfig) {
      ui.sizeConfig = sizeConfig;
      return SafeArea(
        key: key,
        child: Scaffold(
          appBar: appBar(
            context,
            sizeConfig,
            AppLocalizations.of(context).translate("login"),
          ),
          body: Container(
            color: Constants.CANVAS_COLOR,
            child: ListView(
              padding: EdgeInsets.only(bottom: 20),
              children: <Widget>[
                ui.userImage(),
                ui.inputTextForm(key.currentContext),
                ui.errorText(),
                ui.loginSignUpButtons(key.currentContext),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    ui.dispose();
    super.dispose();
  }
}
