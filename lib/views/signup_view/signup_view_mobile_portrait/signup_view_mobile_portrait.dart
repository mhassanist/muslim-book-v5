import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/app_form_controller.dart';
import 'package:muslim_book/views/signup_view/signup_view_mobile_portrait/signup_mobile_portrait_ui.dart';
import 'package:muslim_book/widgets/appBar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignupViewMobilePortrait extends StatefulWidget {
  @override
  _SignupViewMobilePortraitState createState() =>
      _SignupViewMobilePortraitState();
}

class _SignupViewMobilePortraitState extends State<SignupViewMobilePortrait> {
  SignupMobilePortraitUi ui;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final AppFormControllers controllers = AppFormControllers();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ui.getCountries();
      Provider.of<UserProvider>(context,listen: false).errorMessage = "";

    });
  }

  @override
  void didChangeDependencies() {
    ui = SignupMobilePortraitUi( context,controllers);
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      ui.sizeConfig = sizeConfig;
      return SafeArea(
        child: Scaffold(
          key: key,
          appBar: appBar(context, sizeConfig,
              AppLocalizations.of(context)!.translate("create_account"),
              key: key),
          body: Container(
            color: Constants.CANVAS_COLOR,
            child: ListView(
              padding: EdgeInsets.only(bottom: 20),
              children: <Widget>[
                ui.imageWidget(),
                ui.inputTextForm(),
                ui.errorText(),
                ui.loginSignUpButtons(key),
              ],
            ),
          ),
        ),
      );
    });
  }
}
