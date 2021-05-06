import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/providers/top_provider.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/views/login_pop_up_view/login_pop_up_view.dart';
import 'package:base_app/views/top_view/competition_top_view_mobile_portrait/competition_top_mobile_portrait_ui.dart';
import 'package:base_app/widgets/app_scaffold.dart';
import 'package:base_app/widgets/retry_view_widget.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CompetitionTopPage extends StatefulWidget {
  @override
  _CompetitionTopPageState createState() => _CompetitionTopPageState();
}

class _CompetitionTopPageState extends State<CompetitionTopPage> {
  TopUI ui;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ui = TopUI(
      context,
    );
  }


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TopProvider>(builder: (context, model, _) {
      return AppScaffold(
        title: Text("رتبة المسابقة الإسبوعية"),
        centerTitle: true,
        padding: EdgeInsets.zero,
        backGroundColor: Colors.white,
        child: ResponsiveBuilder(
          builder: (context, sizeConfig) {
            ui.sizeConfig = sizeConfig;
            if (model.viewState == ViewState.Loading) {
              return Container(
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Constants.PRIMARY_COLOR),
                  ),
                ),
              );
            }
            return ConnectivityWidgetWrapper(
              disableInteraction: true,
              offlineWidget: RetryViewWidget(
                function: () {
                  model.getTop();
                },
                provider: model,
                text: 'first',
              ),
              child: Container(
                child: Provider.of<UserProvider>(context).isLoggedIn
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.only(top: 20),
                        child: Stack(
                          children: <Widget>[
                            ui.topWinners(),
                            // Align(
                            //   alignment: Alignment.topCenter,
                            //   child: ui.firstTopItem(),
                            // ),
                            // Align(
                            //   alignment: Alignment.bottomCenter,
                            //   child: ui.myItem(),
                            // )
                          ],
                        ),
                      )
                    : LoginPopUpView(),
              ),
            );

//          return BaseView<TopProvider>(
//              onModelReady: (model) async {
//            model.getTop();
//            model.getScore();

//              },
//              builder: (_, model, __) {});
          },
        ),
      );
    });
  }
}
