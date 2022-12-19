import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/edit_profile_provider.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/app_form_controller.dart';
import 'package:muslim_book/views/edit_profile_view/edit_profile_view_mobile_portrait/edit_profile_mobile_portrait_ui.dart';
import 'package:muslim_book/widgets/appBar_widget.dart';
import 'package:muslim_book/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditProfileViewMobilePortrait extends StatefulWidget {
  @override
  _EditProfileViewMobilePortraitState createState() =>
      _EditProfileViewMobilePortraitState();
}

class _EditProfileViewMobilePortraitState
    extends State<EditProfileViewMobilePortrait> {
  late EditProfileMobilePortraitUi ui;
  final AppFormControllers controllers = AppFormControllers();
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return BaseView<EditProfileProvider>(onModelReady: (model) async {
        ui = EditProfileMobilePortraitUi(
            sizeConfig, context, model, controllers);
        model.userProvider = Provider.of<UserProvider>(context);
      }, builder: (_, model, __) {
        return SafeArea(
          child: Scaffold(
            key: key,
            appBar: appBar(context, sizeConfig,
                AppLocalizations.of(context)!.translate("edit_my_profile"),
                key: key),
            body: model.viewState == ViewState.Loading
                ? Container(
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Constants.PRIMARY_COLOR),
                      ),
                    ),
                  )
                : Container(
                    color: Constants.CANVAS_COLOR,
                    child: ListView(
                      padding: EdgeInsets.only(bottom: 20),
                      children: <Widget>[
                        // ui.imageWidget(),
                        ui.imageWidget(),
                        ui.inputTextForm(),
                        ui.errorText(),
                        ui.saveEditButton(key),
                      ],
                    ),
                  ),
          ),
        );
      });
    });
  }
}
