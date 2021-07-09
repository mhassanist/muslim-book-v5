import 'package:base_app/home_feature/controllers/home_controller.dart';
import 'package:base_app/home_feature/views/homePage.dart';
import 'package:base_app/language_constants.dart';
import 'package:base_app/main.dart';
import 'package:base_app/utils/sizing_info_extension.dart';
import 'package:base_app/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Locale _locale;
  @override
  void initState() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    print("hosssssssssam ");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, SizingInformation sizeConfig) {
      return AppScaffold(
        leading: InkWell(
          child: Container(
            margin: EdgeInsetsDirectional.only(start: 10),
            padding: EdgeInsets.all(5),
            height: 20,
            width: 20,
            child: SvgPicture.asset(
              "assets/icons/iconappbar.svg",
              color: Colors.white,
            ),
          ),
          onTap: () {
            Get.find<HomeController>().scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: [
          // InkWell(
          //   onTap: () {
          //     Get.dialog(ShareDialog());
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 5),
          //     child: Icon(Icons.share),
          //   ),
          // ),
          // SizedBox(
          //   width: 5,
          // ),
          InkWell(
            onTap: () async {
              setState(() {
                MyApp.loading = true;
              });
              Locale local = await getLocale();
              _changeLanguage(local.languageCode == 'ar' ? 'en' : 'ar');
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (Localizations.localeOf(context).languageCode == 'en'
                          ? 'ar'
                          : 'en')
                      .toUpperCase(),
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.settings),
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(top: sizeConfig.blockSizeVertical / 2),
          child: Container(
            height: sizeConfig.blockSizeVertical * 6.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter:
                    new ColorFilter.mode(Colors.white, BlendMode.srcIn),
                image: AssetImage(
                  "assets/images/splash_view/decoration.png",
                ),
              ),
            ),
            child: Center(
              child: Image.asset(
                "assets/images/splash_view/logo.png",
                height: sizeConfig.blockSizeVertical * 5,
              ),
            ),
          ),
        ),
        child: HomePage(),
      );
    });
  }

  void _changeLanguage(String language) async {
    Locale locale = await setLocale(language);
    MyApp.setLocale(context, locale);
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        MyApp.loading = false;
      });
    });
  }
}
