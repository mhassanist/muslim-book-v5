import 'package:base_app/providers/competition_provider.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/views/login_pop_up_view/login_pop_up_view.dart';
import 'package:base_app/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'competition_view_mobile_portrait/competition_view_mobile_portrait.dart';

class CompetitionView extends StatefulWidget {
  @override
  _CompetitionViewState createState() => _CompetitionViewState();
}

class _CompetitionViewState extends State<CompetitionView> {
  @override
  void initState() {
    super.initState();
    print("arrived to competition initstates");
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CompetitionProvider>(
        viewModel: CompetitionProvider(Provider.of<UserProvider>(context)),
        onModelReady: (model) {
          model.getQuestions();
          print("shaimaaaaaaaaaaaa");
        },
        builder: (context, _, __) {
          return ScreenTypeLayout(
            mobile: OrientationLayoutBuilder(
              portrait: (context) => CompetitionViewMobilePortrait(),
            ),
          );
        });
  }

  @override
  void dispose() {
    print("competition view disposed");
    super.dispose();
  }
}