import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/models/countries_model.dart';
import 'package:base_app/network_utils/api_service.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/InputValidation.dart';
import 'package:base_app/utils/app_form_controller.dart';
import 'package:base_app/utils/loading_utils.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/widgets/app_text_field.dart';
import 'package:base_app/widgets/standardButton_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../locals_utils/app_localizations.dart';
import '../../../utils/sizing_info_extension.dart';

class SignupMobilePortraitUi {
  UserProvider userProvider;
  SizingInformation sizeConfig;
  final BuildContext context;
  final AppFormControllers controllers;
  SignupMobilePortraitUi(this.context, this.controllers) {
    userProvider = Provider.of<UserProvider>(context);
  }

  Widget imageWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 15),
      child: Center(
        child: Stack(
          // overflow: Overflow.visible,
          fit: StackFit.passthrough,
          //fit: StackFit.loose,
          children: <Widget>[
            ClipRRect(
                // child: provider.getUserProfileImage == null
                //     ?
                child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor, shape: BoxShape.circle),
              child: Icon(
                Icons.person,
                size: sizeConfig.blockSizeHorizontal * 20,
                color: Constants.CANVAS_COLOR,
              ),
              height: sizeConfig.blockSizeHorizontal * 30,
              width: sizeConfig.blockSizeHorizontal * 30,
            )),
          ],
        ),
      ),
    );
  }

  Widget inputTextForm() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: controllers.formKey,
          child: Column(
            children: <Widget>[
              AppTextField(

                formKey: controllers.formKey,
                controller: controllers.nameController,
                currentNode: controllers.nameNode,
                nextNode: controllers.emailNode,
                hint: AppLocalizations.of(context)
                    .translate("enter_account_name"),
                icon: Icons.account_box,
                sizeConfig: sizeConfig,
                validator: (value) {
                  return   InputValidation.userNameValidation(
                      controllers.nameController, context);
                },
                inputType: TextInputType.text,
              ),
              SizedBox(
                height: 5,
              ),
              AppTextField(
                formKey: controllers.formKey,
                controller: controllers.emailController,
                currentNode: controllers.emailNode,
                nextNode: controllers.passwordNode,
                inputType: TextInputType.emailAddress,
                hint: AppLocalizations.of(context).translate("enter_email"),
                icon: Icons.email,
                sizeConfig: sizeConfig,
                validator: (value) {
                  return   InputValidation.emailValidation(
                      controllers.emailController, context);
                },
              ),
              SizedBox(
                height: 5,
              ),
              AppTextField(
                formKey: controllers.formKey,
                controller: controllers.passwordController,
                currentNode: controllers.passwordNode,
                nextNode: controllers.confirmPasswordNode,
                inputType: TextInputType.text,
                obscureText: true,
                hint: AppLocalizations.of(context).translate("enter_password"),
                icon: Icons.lock,
                sizeConfig: sizeConfig,
                validator: (value) {
                  return   InputValidation.passwordValidation(
                      controllers.passwordController, context);
                },
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 5,
              ),
              AppTextField(
                formKey: controllers.formKey,
                controller: controllers.confirmPasswordController,
                currentNode: controllers.confirmPasswordNode,
                nextNode: null,
                inputType: TextInputType.text,
                obscureText: true,
                hint:
                    AppLocalizations.of(context).translate("confirm_password"),
                icon: Icons.lock,
                sizeConfig: sizeConfig,
                validator: (value) {
                return  InputValidation.confirmPasswordValidation(
                      controllers.confirmPasswordController,
                      controllers.passwordController,
                      context);
                },
                textInputAction: TextInputAction.done,
                onSubmit: (s) => {},
              ),
              IgnorePointer(
                ignoring:
                    userProvider.viewState == ViewState.Idle ? false : true,
                child: Container(
                  width: sizeConfig.blockSizeHorizontal * 80,
                  height: sizeConfig.blockSizeVertical * 10,
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Constants.ACCENT_COLOR, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<CountryModel>(
                    iconSize: sizeConfig.blockSizeHorizontal * 7,
                    hint: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.flag,
                            color: Colors.grey,
                            size: sizeConfig.blockSizeHorizontal * 4,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate("country_name"),
                          style: TextStyle(
                            fontSize: sizeConfig.blockSizeHorizontal * 4,
                          ),
                        ),
                      ],
                    ),
                    value: userProvider.selectedCountry,
                    onChanged: (val) {
                      userProvider.selectedCountry = val;
                    },
                    isExpanded: true,
                    items: userProvider.countries.map((f) {
                      return DropdownMenuItem<CountryModel>(
                        value: f,
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      sizeConfig.blockSizeHorizontal * 2),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(f.flag),
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: sizeConfig.blockSizeVertical),
                              width: sizeConfig.blockSizeHorizontal * 13,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: sizeConfig.blockSizeHorizontal),
                                child: Text(
                                  f.name,
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          sizeConfig.blockSizeHorizontal * 4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )),
                ),
              )
            ],
          ),
        ),
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

  Widget loginSignUpButtons(GlobalKey<ScaffoldState> scaffoldKey) {
    return Column(
      children: <Widget>[
        standardButton(
          isGo: true,
          context: context,
          sizeConfig: sizeConfig,
          color: Theme.of(context).primaryColor,
          title: AppLocalizations.of(context).translate("create_account"),
          onPressed: () async => setRegister(scaffoldKey),
        ),
      ],
    );
  }

  Future setRegister(GlobalKey<ScaffoldState> key) async {
    if (userProvider.selectedCountry == null) {
      key.currentState.showSnackBar(SnackBar(
          content: Text(
              AppLocalizations.of(context).translate("country_is_required"))));
    } else if (controllers.formKey.currentState.validate()) {
      LoadingUtils loadingUtils = LoadingUtils();
      loadingUtils.setIsLoading(key.currentContext, true);
      bool res = await userProvider.register({
        "email": controllers.emailController.text.trim(),
        "name": controllers.nameController.text.trim(),
        "country_id": "${userProvider.selectedCountry.id}",
        "city_id": "1",
        "password": controllers.passwordController.text.trim(),
        "password_confirmation": controllers.confirmPasswordController.text.trim(),
      });
      loadingUtils.setIsLoading(key.currentContext, false);
      if (res) {
        Navigator.pop(context);
      }
    }
  }

  void getCountries() async {
    CountriesModel model = await locator<ApiService>().getCountries(AppLocalizations.of(context).locale.languageCode);
    userProvider.countries = model?.data;
  }

}
