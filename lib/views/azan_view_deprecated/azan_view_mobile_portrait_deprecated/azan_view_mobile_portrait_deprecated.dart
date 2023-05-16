import 'package:muslim_book/providers/azan_provider.dart';
import 'package:muslim_book/providers/location_provider.dart';
import 'package:muslim_book/views/azan_view_deprecated/azan_view_mobile_portrait_deprecated/azan_mobile_portrait_ui_deprecated.dart';
import 'package:muslim_book/widgets/base_widget.dart';
import 'package:muslim_book/widgets/retry_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AzanViewMobilePortraitDeprecated extends StatefulWidget {
  @override
  _AzanViewMobilePortraitDeprecatedState createState() =>
      _AzanViewMobilePortraitDeprecatedState();
}

class _AzanViewMobilePortraitDeprecatedState
    extends State<AzanViewMobilePortraitDeprecated> {
  late AzanMobilePortraitUiDeprecated ui;
  late AzanProvider provider;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return BaseView<AzanProvider>(onModelReady: (model) async {
        provider = model;
        model.context = context;
        model.setNextSalah();
        ui = AzanMobilePortraitUiDeprecated(
          context: context,
          provider: model,
          sizeConfig: sizeConfig,
        );
        model.startRemainingStream();
      }, builder: (_, model, __) {
        var returnedData = model.getAzanList();
        if (returnedData.isNotEmpty) {
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
          () async {
            await context.read<LocationProvider>().getLocation(context);
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
