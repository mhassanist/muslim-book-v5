import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'azan_view_mobile_portrait/azan_view_mobile_portrait.dart';

class AzanView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        portrait: (context) => AzanViewMobilePortrait(),
      ),
    );
  }
}

