import 'package:muslim_book/home_feature/const/color.dart';
import 'package:muslim_book/home_feature/controllers/home_controller.dart';
import 'package:muslim_book/home_feature/views/homePage.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/locals_utils/language_constants.dart';
import 'package:muslim_book/main.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

enum Language { english, france, Arabic }

class _HomeViewState extends State<HomeView> {
  late Language lang;

  @override
  void initState() {
    getLocale().then((locale) {
      if (locale.languageCode == 'ar') {
        lang = Language.Arabic;
      } else if (locale.languageCode == 'en') {
        lang = Language.english;
      } else {
        lang = Language.france;
      }
    });
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
            Get.find<HomeController>().scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          InkWell(
            onTap: () async {
              setState(() {
                MyApp.loading = true;
              });
              // Locale local = await getLocale();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => new AlertDialog(
                          contentPadding: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          content: Container(
                              height: 200,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(AppLocalizations.of(context)!.translate("Arabic")),
                                    leading: Radio<Language>(
                                      value: Language.Arabic,
                                      groupValue: lang,
                                      activeColor: darkish_green,
                                      onChanged: (Language? value) {
                                        if (value != null) {
                                          setState(() {
                                            lang = value;
                                            _changeLanguage("ar");
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(AppLocalizations.of(context)!
                                        .translate("English")),
                                    leading: Radio<Language>(
                                      value: Language.english,
                                      activeColor: darkish_green,
                                      groupValue: lang,
                                      onChanged: (Language? value) {
                                        if (value != null) {
                                          setState(() {
                                            lang = value;
                                            _changeLanguage("en");
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(AppLocalizations.of(context)!
                                        .translate("France")),
                                    leading: Radio<Language>(
                                      value: Language.france,
                                      groupValue: lang,
                                      activeColor: darkish_green,
                                      onChanged: (Language? value) {
                                        if (value != null) {
                                          setState(() {
                                            lang = value;
                                            _changeLanguage("fr");
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                    icon: Icon(Icons.language))
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
    setState(() {
      MyApp.loading = true;
    });
    Locale locale = await setLocale(language);
    MyApp.setLocale(context, locale);
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        MyApp.loading = false;
      });
    });
  }
}
