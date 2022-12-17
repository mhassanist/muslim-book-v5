import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';

const String _kAsset0 = 'people/square/trevor.png';
// const String _kAsset1 = 'people/square/stella.png';
// const String _kAsset2 = 'people/square/sandra.png';
const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class DrawerDemo extends StatefulWidget {
  static const String routeName = '/material/drawer';

  @override
  _DrawerDemoState createState() => _DrawerDemoState();
}

class _DrawerDemoState extends State<DrawerDemo> with TickerProviderStateMixin {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  late AnimationController _controller;
  late Animation<double> _drawerContentsOpacity;
  late Animation<Offset> _drawerDetailsPosition;
  // bool _showDrawerContents = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = _controller.drive(_drawerDetailsTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // IconData _backIcon() {
  //   switch (Theme.of(context).platform) {
  //     case TargetPlatform.android:
  //     case TargetPlatform.fuchsia:
  //       return Icons.arrow_back;
  //     case TargetPlatform.iOS:
  //     case TargetPlatform.linux:
  //     case TargetPlatform.macOS:
  //     case TargetPlatform.windows:
  //       return Icons.arrow_back_ios;
  //   }
  // }

  void _showNotImplementedMessage() {
    Navigator.pop(context); // Dismiss the drawer.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
      content: Text("The drawer's items don't do anything"),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('Trevor Widget'),
            accountEmail: const Text('trevor.widget@example.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage(
                _kAsset0,
                package: _kGalleryAssetsPackage,
              ),
            ),
          ),
          MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: Expanded(
              child: ListView(
                dragStartBehavior: DragStartBehavior.down,
                padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      // The initial contents of the drawer.
                      FadeTransition(
                        opacity: _drawerContentsOpacity,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    // Navigator.of(context).push(
                                    //     CupertinoPageRoute(
                                    //         builder: (BuildContext context) =>
                                    //             MyAcountFragment()));
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: 44,
                                          minHeight: 40,
                                          maxWidth: 64,
                                          maxHeight: 64,
                                        ),
                                        child: Image.asset(
                                            "assets/icons/acount.png",
                                            fit: BoxFit.cover),
                                      ),
                                      SizedBox(width: 10),
                                      Text('الحساب الشخصي '),
                                    ],
                                  )),
                              SizedBox(height: 10),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    // Navigator.of(context).push(
                                    //     CupertinoPageRoute(
                                    //         builder: (BuildContext context) =>
                                    //             MassagesScreenView()));
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: 44,
                                          minHeight: 40,
                                          maxWidth: 64,
                                          maxHeight: 64,
                                        ),
                                        child: Image.asset(
                                            "assets/icons/massages_menu_icon.png",
                                            fit: BoxFit.cover),
                                      ),
                                      SizedBox(width: 10),
                                      Text('الرسائل'),
                                    ],
                                  )),
                              SizedBox(height: 10),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    // Navigator.of(context).push(
                                    //     CupertinoPageRoute(
                                    //         builder: (BuildContext context) =>
                                    //             NotesScreenView()));
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: 44,
                                          minHeight: 40,
                                          maxWidth: 64,
                                          maxHeight: 64,
                                        ),
                                        child: Image.asset(
                                            "assets/icons/notes_menu_icon.png",
                                            fit: BoxFit.cover),
                                      ),
                                      SizedBox(width: 10),
                                      Text("الملاحظات"),
                                    ],
                                  )),
                              SizedBox(height: 30),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    // showDialogLogout(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: 10),
                                      Text('خروج'),
                                    ],
                                  )),
                            ]),
                      ),
                      // The drawer's "details" view.
                      SlideTransition(
                        position: _drawerDetailsPosition,
                        child: FadeTransition(
                          opacity: ReverseAnimation(_drawerContentsOpacity),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.add),
                                title: const Text('Add account'),
                                onTap: _showNotImplementedMessage,
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings),
                                title: const Text('Manage accounts'),
                                onTap: _showNotImplementedMessage,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void showDialogLogout(BuildContext context) async {
  //   return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //             contentPadding: EdgeInsets.all(0),
  //             content: Container(
  //               width: 300,
  //               height: 350,
  //               color: Colors.transparent,
  //               child: LogOutView(),
  //             ));
  //       });
  // }

  // void _onOtherAccountsTap(BuildContext context) {
  //   showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Account switching not implemented.'),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
