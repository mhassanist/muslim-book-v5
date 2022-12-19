import 'dart:io';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/countries_model.dart';
import 'package:muslim_book/network_utils/api_service.dart';
import 'package:muslim_book/providers/edit_profile_provider.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/InputValidation.dart';
import 'package:muslim_book/utils/app_form_controller.dart';
import 'package:muslim_book/utils/loading_utils.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:muslim_book/widgets/standardButton_widget.dart';
import 'package:muslim_book/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../utils/sizing_info_extension.dart';

class EditProfileMobilePortraitUi {
  final EditProfileProvider provider;
  final SizingInformation sizeConfig;
  final BuildContext context;
  final AppFormControllers controllers;

  EditProfileMobilePortraitUi(
      this.sizeConfig, this.context, this.provider, this.controllers) {
    controllers.emailController.text =
        Provider.of<UserProvider>(context).user.email ?? '';

    controllers.nameController.text =
        Provider.of<UserProvider>(context).user.name ?? '';
  }

  Widget imageWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: Center(
        child: Stack(
          // overflow: Overflow.visible,
          fit: StackFit.passthrough,
          //fit: StackFit.loose,
          children: <Widget>[
            ClipRRect(
                child: provider.getUserProfileImage == null
                    ? userImageOrFlag()
                    : Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            shape: BoxShape.circle),
                        child: showImage(provider.getUserProfileImage),
                        height: sizeConfig.blockSizeHorizontal * 60,
                        width: sizeConfig.blockSizeHorizontal * 60,
                      )),
            Positioned(
              top: 0,
              bottom: 0,
              right: -sizeConfig.blockSizeHorizontal * 6,
              child: Container(
                height: sizeConfig.blockSizeHorizontal * 12,
                width: sizeConfig.blockSizeHorizontal * 12,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: Theme.of(context).accentColor),
                    color: Constants.CANVAS_COLOR,
                    shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {
                    _openChooseImagePopup();
                  },
                  icon: Icon(
                    Icons.edit,
                    size: sizeConfig.blockSizeHorizontal * 7,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container userImageOrFlag() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                Provider.of<UserProvider>(context).user.image ??
                    Provider.of<UserProvider>(context).user.flag ?? '',
              ),
              fit: BoxFit.cover),
          shape: BoxShape.circle),
      height: sizeConfig.blockSizeHorizontal * 40,
      width: sizeConfig.blockSizeHorizontal * 40,
    );
  }

  Widget showImage(Future<File>? _imageFile) {
    if (_imageFile == null) {
      return Offstage();
    }
    return FutureBuilder<File>(
      future: _imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return ClipOval(
            child: Image.file(snapshot.data!, fit: BoxFit.cover),
          );
        } else
          return userImageOrFlag();
      },
    );
  }

  _pickImage(ImageSource _imageSource) async {
    final file = ImagePicker().pickImage(source: _imageSource,);
    provider.setUserProfileImage = file!;
  }

  _openChooseImagePopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            AppLocalizations.of(context)!.translate("choose_photo"),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: sizeConfig.blockSizeHorizontal * 6,
                fontWeight: FontWeight.bold,
                color: Colors.green),
          ),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.photo,
                    color: Theme.of(context).primaryColor,
                    size: sizeConfig.blockSizeHorizontal * 8,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(AppLocalizations.of(context)!.translate("from_gallery"),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: sizeConfig.blockSizeHorizontal * 4)),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).accentColor,
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).primaryColor,
                    size: sizeConfig.blockSizeHorizontal * 8,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(AppLocalizations.of(context)!.translate("by_camera"),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: sizeConfig.blockSizeHorizontal * 4)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget inputTextForm() {
    return Form(
      key: controllers.formKey,
      child: Column(
        children: <Widget>[
          AppTextField(
            enabled: false,
            obscureText: false,
            controller: controllers.emailController,
            icon: Icons.email,
            sizeConfig: sizeConfig,
          ),
          AppTextField(
            formKey: controllers.formKey,
            controller: controllers.nameController,
            nextNode: null,
            validator: (s) => InputValidation.userNameValidation(
                controllers.nameController, context),
            currentNode: controllers.nameNode,
            obscureText: false,
            hint: AppLocalizations.of(context)!.translate("name"),
            icon: Icons.person,
            sizeConfig: sizeConfig,
            initialValue: provider.getName,
            onChanged: (value) {
              provider.setName = value;
            },
          ),
          IgnorePointer(
            ignoring: provider.viewState == ViewState.Idle ? false : true,
            child: Container(
              width: sizeConfig.blockSizeHorizontal * 80,
              height: sizeConfig.blockSizeVertical * 10,
              margin: EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: Constants.ACCENT_COLOR, width: 1),
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
                      AppLocalizations.of(context)!.translate("country_name"),
                      style: TextStyle(
                        fontSize: sizeConfig.blockSizeHorizontal * 4,
                      ),
                    ),
                  ],
                ),
                value: provider.selectedCountry,
                onChanged: (val) {
                  provider.selectedCountry = val;
                },
                isExpanded: true,
                items: provider.countries.map((f) {
                  return DropdownMenuItem<CountryModel>(
                    value: f,
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: sizeConfig.blockSizeHorizontal * 2),
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
                                  fontSize: sizeConfig.blockSizeHorizontal * 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget saveEditButton(GlobalKey<ScaffoldState> key) {
    return standardButton(
      isGo: true,
      context: context,
      sizeConfig: sizeConfig,
      color: Theme.of(context).primaryColor,
      title: AppLocalizations.of(context)!.translate("save_edit"),
      onPressed: () async{
       await saveEdit(key);
      },
    );
  }

  Future<void> saveEdit(GlobalKey<ScaffoldState> key) async{
    if (provider.selectedCountry == null) {
      key.currentState.showSnackBar(SnackBar(
          content: Text(
              AppLocalizations.of(context)!.translate("country_is_required"))));
    } else if (controllers.formKey.currentState.validate()) {
      LoadingUtils loadingUtils = LoadingUtils();
      loadingUtils.setIsLoading(key.currentContext, true);
     var res =await provider.checkEdit(controllers.nameController.text);
      loadingUtils.setIsLoading(key.currentContext, false);
      if (res) {
        Navigator.pop(context);
      }
    }

  }

  AnimatedCrossFade errorText() {
    return AnimatedCrossFade(
      crossFadeState: provider.errorMessage == ""
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: SizedBox(),
      duration: Duration(milliseconds: 100),
      secondChild: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 3),
        child: Text(
          provider.errorMessage,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

}
