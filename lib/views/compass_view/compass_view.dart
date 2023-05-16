import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'compass_view_mobile_portrait/compass_View_mobile_portrait.dart';

class CompassView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        portrait: (context) => CompassViewMobilePortrait(),
      ),
    );
  }
}
