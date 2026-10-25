import 'package:muslim_book/providers/user_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.centerTitle = false,
    this.addImageProfile = true,
    this.transparentBackground = false,
    this.padding,
    this.backGroundColor,
    this.actions,
    this.floatingActionButton,
    this.onProfileTap,
    this.scaffoldKey,
    this.leading,
    this.resizeToAvoidBottomInset,
    this.backgroundImage,
  });

  final Widget title;
  final Widget? leading;
  final Color? backGroundColor;
  final Widget child;
  final bool centerTitle;
  final bool addImageProfile;
  final bool transparentBackground;
  final EdgeInsets? padding;
  final Function? onProfileTap;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Color primaryColor = const Color(0XFF347D53);
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool? resizeToAvoidBottomInset;
  final DecorationImage? backgroundImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        // A UniqueKey here remounted the whole page on every rebuild, which
        // reset carousels/counters and restarted FutureBuilders.
        key: scaffoldKey,
        appBar: AppBar(
            leading: leading,
            actions: [
              if (actions != null) ...actions!,
              if (addImageProfile) getProfilePicture(context),
            ],
            centerTitle: centerTitle,
            backgroundColor: primaryColor,
            elevation: 0,
            title: title),
        floatingActionButton: floatingActionButton,
        body: Container(
          color: primaryColor,
          child: Container(
            padding: padding,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: transparentBackground
                  ? Colors.transparent
                  : backGroundColor ?? Colors.white,
              image: backgroundImage,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget getProfilePicture(context) {
    if (Provider.of<UserProvider>(context).isLoggedIn) {
      return GestureDetector(
        onTap: onProfileTap != null
            ? () => onProfileTap?.call()
            : () => Navigator.pushNamed(context, "/myProfile_view"),
        child: Provider.of<UserProvider>(context).user.image == null
            ? placeHolder()
            : Container(
                margin: const EdgeInsets.only(
                  top: 12,
                  bottom: 2,
                  left: 10,
                ),
                child: ExtendedImage.network(
                  (Provider.of<UserProvider>(context).user.image ?? '')
                      .replaceAll("http://", "https://"),
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.failed) {
                      return placeHolder();
                    }
                    return state.completedWidget;
                  },
                  fit: BoxFit.cover,
                  shape: BoxShape.circle,
                  width: kToolbarHeight - 14,
                ),
              ),
      );
    } else {
      return const SizedBox();
    }
  }

  Container placeHolder() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 10),
      child: Image.asset("assets/images/sebha_view/profile.png"),
    );
  }
}
