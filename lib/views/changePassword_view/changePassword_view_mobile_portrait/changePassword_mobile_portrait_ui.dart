import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/providers/changePassword_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/app_form_controller.dart';
import 'package:base_app/widgets/standardButton_widget.dart';
import 'package:base_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../utils/sizing_info_extension.dart';

class ChangePasswordUI {
  final ChangePasswordProvider provider;
  final SizingInformation sizeConfig;
  final BuildContext context;
  final AppFormControllers controllers = AppFormControllers();
  ChangePasswordUI(this.provider, this.sizeConfig, this.context);

  Widget screenHeader() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 50, bottom: 20),
        child: Text(
          AppLocalizations.of(context).translate("change_password"),
          style: TextStyle(
              color: Constants.SCREEN_TITLE_COLOR,
              fontSize: sizeConfig.blockSizeHorizontal * 5,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget userImage() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
          height: sizeConfig.blockSizeVertical * 30,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/images/onboarding/country_picker.png')))),
    );
  }

  Widget textWidget() {
    return Text(
      AppLocalizations.of(context).translate("please_enter_data"),
      style: TextStyle(fontSize: sizeConfig.blockSizeHorizontal * 5),
      maxLines: 2,
      textAlign: TextAlign.center,
    );
  }

  Widget inputTextForm() {
    return Form(
      key: controllers.formKey,
      child: Column(
        children: <Widget>[
          AppTextField(
              controller: controllers.emailController,
              hint:
                  AppLocalizations.of(context).translate("enter_account_name"),
              icon: Icons.email,
              sizeConfig: sizeConfig),
          SizedBox(
            height: 10,
          ),
          AppTextField(
              controller: controllers.passwordController,
              obscureText: false,
              hint: AppLocalizations.of(context).translate("enter_email"),
              icon: Icons.lock,
              sizeConfig: sizeConfig),
        ],
      ),
    );
  }

  Widget sendDataButtons() {
    return standardButton(
      isGo: true,
      context: context,
      sizeConfig:sizeConfig,
     color: Theme.of(context).primaryColor,
        title:          AppLocalizations.of(context).translate("send_data"),
      onPressed:(){},
    );
  }

}
