import 'package:base_app/views/edit_profile_view/edit_profile_view_mobile_portrait/edit_profile_view_mobile_portrait.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        portrait: (context) => EditProfileViewMobilePortrait(),
      ),
    );
  }
}

