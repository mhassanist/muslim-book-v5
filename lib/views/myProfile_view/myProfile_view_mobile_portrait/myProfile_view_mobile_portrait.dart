import 'package:muslim_book/widgets/retry_view_widget.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/myProfile_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/appBar_widget.dart';
import 'package:muslim_book/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:screenshot/screenshot.dart';
import 'myProfile_mobile_portrait_ui.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late MyProfileUI ui;
  late MyProfileProvider provider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return BaseView<MyProfileProvider>(onModelReady: (model) async {
        //provider = model;
        ui = MyProfileUI(sizeConfig, context, model,screenshotController);
      }, builder: (_, model, __) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Constants.CANVAS_COLOR,
            appBar: appBar(context, sizeConfig,
                AppLocalizations.of(context)!.translate("my_profile"),
                key: key),
            // Checked first so the retry view stays mounted while retrying;
            // it refetches when disposed.
            body: model.loadFailed
                ? RetryViewWidget(
                    provider: model,
                    function: model.getScore,
                    text: "my_profile",
                  )
                : model.viewState == ViewState.Loading
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Constants.PRIMARY_COLOR),
                      ),
                    ),
                  )
                : Screenshot(
              controller: screenshotController,
                  child: Container(
                    color: Theme.of(context).canvasColor,
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 20),
                        children: <Widget>[
                          ui.imageWidget(),
                          ui.personalData(),
                          ui.points(),
                          ui.textShare(),
                          ui.socialMedia()
                        ],
                      ),
                    ),
                ),
          ),
        );
      });
    });
  }
}
