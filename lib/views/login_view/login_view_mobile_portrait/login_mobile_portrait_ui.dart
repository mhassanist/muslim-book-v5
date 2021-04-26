import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/InputValidation.dart';
import 'package:base_app/utils/app_form_controller.dart';
import 'package:base_app/utils/loading_utils.dart';
import 'package:base_app/widgets/standardButton_widget.dart';
import 'package:base_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../utils/sizing_info_extension.dart';

class LoginMobilePortraitUi {
  SizingInformation sizeConfig;
  final BuildContext context;
  UserProvider userProvider;
  final AppFormControllers controller;
  LoginMobilePortraitUi(this.context, this.controller) {
    userProvider = Provider.of<UserProvider>(context);
  }

  Widget userImage() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: CircleAvatar(
        radius: sizeConfig.blockSizeHorizontal * 25,
        child: Icon(
          Icons.person,
          size: sizeConfig.blockSizeHorizontal * 30,
          color: Constants.CANVAS_COLOR,
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  Widget inputTextForm(c) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: <Widget>[
          AppTextField(
            formKey: controller.formKey,
            controller: controller.emailController,
            currentNode: controller.emailNode,
            nextNode: controller.passwordNode,
            inputType: TextInputType.emailAddress,
            hint: AppLocalizations.of(context).translate("enter_email"),
            icon: Icons.email,
            sizeConfig: sizeConfig,
            validator: (value) {
              print("arrived here $value");
              return InputValidation.emailValidation(
                  controller.emailController, context);
            },
          ),
          SizedBox(
            height: 10,
          ),
          AppTextField(
            formKey: controller.formKey,
            controller: controller.passwordController,
            currentNode: controller.passwordNode,
            nextNode: null,
            inputType: TextInputType.text,
            obscureText: true,
            hint: AppLocalizations.of(context).translate("enter_password"),
            icon: Icons.lock,
            sizeConfig: sizeConfig,
            validator: (value) {
              return InputValidation.passwordValidation(
                  controller.passwordController, context);
            },
            textInputAction: TextInputAction.done,
            onSubmit: (s) => setLogging(c),
          ),
        ],
      ),
    );
  }

  AnimatedCrossFade errorText() {
    return AnimatedCrossFade(
      crossFadeState: userProvider.errorMessage == ""
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: SizedBox(),
      duration: Duration(milliseconds: 100),
      secondChild: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 3),
        child: Text(
          userProvider.errorMessage,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget loginSignUpButtons(c) {
    return standardButton(
      isGo: true,
      context: context,
      sizeConfig: sizeConfig,
      color: Theme.of(context).primaryColor,
      title: AppLocalizations.of(context).translate("login"),
      onPressed: () async => await setLogging(c),
    );
  }

  void dispose() {
    controller.dispose();
  }

  Future setLogging(context) async {
    if (controller.formKey.currentState.validate()) {
      LoadingUtils loadingUtils = LoadingUtils();
      loadingUtils.setIsLoading(context, true);
      bool res = await userProvider.login(
          "${controller.emailController.text.trim()}",
          "${controller.passwordController.text.trim()}");
      loadingUtils.setIsLoading(context, false);
      if (res) {
        loadingUtils.setIsLoading(context, false);
//        Navigator.pop(context);
      }
    }
  }
}
