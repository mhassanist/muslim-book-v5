import 'package:flutter/material.dart';
import 'package:muslim_book/providers/location_provider.dart';
import 'package:muslim_book/views/azan_view_deprecated/azan_view_mobile_portrait_deprecated/azan_view_mobile_portrait_deprecated.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AzanViewDeprecated extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        portrait: (context) => Provider(
            create: (_) => LocationProvider(),
            child: AzanViewMobilePortraitDeprecated()),
      ),
    );
  }
}
