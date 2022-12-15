import 'package:muslim_book/providers/azan_provider.dart';
import 'package:muslim_book/views/azan_view/azan_view_mobile_portrait/azan_mobile_portrait_ui.dart';
import 'package:muslim_book/widgets/base_widget.dart';
import 'package:muslim_book/widgets/retry_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AzanViewMobilePortrait extends StatefulWidget {
  @override
  _AzanViewMobilePortraitState createState() => _AzanViewMobilePortraitState();
}

class _AzanViewMobilePortraitState extends State<AzanViewMobilePortrait> {
  AzanMobilePortraitUi ui;
  AzanProvider provider;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return BaseView<AzanProvider>(onModelReady: (model) async {
        provider = model;
        model.context = context;
        model.setNextSalah();
        ui = AzanMobilePortraitUi(
          context: context,
          provider: model,
          sizeConfig: sizeConfig,
        );
        model.startRemainingStream();
      }, builder: (_, model, __) {
        var returnedData = model.getAzanList();
        if (returnedData != null) {
          return Scaffold(
            body: Column(
              children: <Widget>[ui.upperPart(), ui.azanTimesPart()],
            ),
          );
        }
        return modelNotPresentWidget(
          sizeConfig,
          context,
          model,
          () {
            model.getAzanModel(context);
          },
          'to_azan_times',
        );
      });
    });
  }

  @override
  void dispose() {
    provider.isMounted = false;
    super.dispose();
  }
}
