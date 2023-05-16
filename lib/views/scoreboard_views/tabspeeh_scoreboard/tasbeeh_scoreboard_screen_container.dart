import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/tasbeeh_top_provider.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/views/login_pop_up_view/login_pop_up_view.dart';
import 'package:muslim_book/views/scoreboard_views/tabspeeh_scoreboard/tasbeeh_scoreboard_screen.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:muslim_book/widgets/retry_view_widget.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TasbeehScoreboardScreenContainer extends StatefulWidget {
  @override
  _TasbeehScoreboardScreenContainerState createState() =>
      _TasbeehScoreboardScreenContainerState();
}

class _TasbeehScoreboardScreenContainerState
    extends State<TasbeehScoreboardScreenContainer> {
  late TasbeehScoreboardScreen ui;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ui = TasbeehScoreboardScreen(
      context,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TasbeehTopProvider>(builder: (context, model, _) {
      return AppScaffold(
        title: Text(AppLocalizations.of(context)!.translate("tasbehRank")),
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
                  model.getTasbeehTop();
                },
                provider: model,
                text: 'first',
              ),
              child: Provider.of<UserProvider>(context).isLoggedIn
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(top: 20),
                      child: Stack(
                        children: <Widget>[
                          ui.topWinners(),
                        ],
                      ),
                    )
                  : LoginPopUpView(),
            );
          },
        ),
      );
    });
  }
}
