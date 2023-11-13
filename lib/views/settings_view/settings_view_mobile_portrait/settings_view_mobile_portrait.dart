import 'package:muslim_book/ads/admob_banner.dart';
import 'package:muslim_book/ads/load_ui_with_add.dart';
import 'package:muslim_book/home_feature/const/color.dart';
import 'package:muslim_book/home_feature/views/home_view.dart';
import 'package:muslim_book/locals_utils/language_constants.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/providers/location_provider.dart';
import 'package:muslim_book/providers/settings_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/views/settings_view/settings_view_mobile_portrait/settings_mobile_portrait_ui.dart';
import 'package:muslim_book/widgets/base_widget.dart';
import 'package:muslim_book/widgets/custom_expansion_panel_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../locals_utils/app_localizations.dart';
import '../../../main.dart';
import '../../../widgets/appBar_widget.dart';

class ExpansionPanelItem {
  bool isExpanded;
  final String? title;
  final Widget? content;
  final Icon leading;
  final String? icon;

  ExpansionPanelItem({
    required this.isExpanded,
    this.title,
    this.content,
    required this.leading,
    this.icon,
  });
}

class SettingsViewMobilePortrait extends StatefulWidget {
  const SettingsViewMobilePortrait({super.key});

  @override
  State<SettingsViewMobilePortrait> createState() => _SettingsViewMobilePortraitState();
}

class _SettingsViewMobilePortraitState extends State<SettingsViewMobilePortrait> {
  late SettingsMobilePortraitUi ui;
  Language? lang;

  @override
  void initState() {
    super.initState();
  }

  List<ExpansionPanelItem> items = [
    ExpansionPanelItem(
      isExpanded: false,
      leading: const Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/bell.svg",
    ),
    ExpansionPanelItem(
      isExpanded: false,
      leading: const Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/world.svg",
    ),
    ExpansionPanelItem(
      isExpanded: false,
      leading: const Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/eclipse.svg",
    ),
    ExpansionPanelItem(
      isExpanded: false,
      leading: const Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/clock.svg",
    ),
    ExpansionPanelItem(
      isExpanded: false,
      leading: const Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/shaikh.svg",
    ),
    ExpansionPanelItem(
      isExpanded: false,
      leading: const Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/moon.svg",
    ),
    ExpansionPanelItem(
      isExpanded: false,
      leading: const Icon(Icons.arrow_back_ios),
      icon: "assets/images/setting_view/gear.svg",
    ),
  ];
  List<ExpansionPanelItem> contents = [];

  Widget show() {
    getLocale().then((locale) {
      if (locale.languageCode == 'ar') {
        lang = Language.Arabic;
      } else if (locale.languageCode == 'en') {
        lang = Language.english;
      } else {
        lang = Language.france;
      }
    });
    return SizedBox(
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
                  _changeLanguage("ar");
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.translate("English")),
              leading: Radio<Language>(
                value: Language.english,
                activeColor: darkish_green,
                groupValue: lang,
                onChanged: (Language? value) {
                  _changeLanguage("en");
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.translate("France")),
              leading: Radio<Language>(
                value: Language.france,
                groupValue: lang,
                activeColor: darkish_green,
                onChanged: (Language? value) {
                  _changeLanguage("fr");
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ));
  }

  void _changeLanguage(String language) async {
    Locale locale = await setLocale(language);
    if (context.mounted) {
      MyApp.setLocale(context, locale);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizeConfig) {
        return BaseView<SettingsProvider>(
          onModelReady: (model) async {
            model.context = context;
            ui = SettingsMobilePortraitUi(
              Provider.of<LocationProvider>(context),
              context: context,
              provider: model,
              sizeConfig: sizeConfig,
            );
          },
          builder: (_, model, __) {
            model.fillTheSettingsData();
            // return Scaffold(
            //   body: Center(
            //     child: Text('${model.alreadyFilledData}'),
            //   ),
            // );
            contents = [
              ExpansionPanelItem(
                  isExpanded: false,
                  title: AppLocalizations.of(context)!.translate("alerts"),
                  content: ui.alertsPart(),
                  leading: const Icon(Icons.arrow_back_ios)),
              ExpansionPanelItem(
                  isExpanded: false,
                  title: AppLocalizations.of(context)!
                      .translate("country_specify"),
                  content: ui.countrySelectionPart(),
                  leading: const Icon(Icons.arrow_back_ios)),
              ExpansionPanelItem(
                  isExpanded: false,
                  title: AppLocalizations.of(context)!
                      .translate("calculation_type"),
                  content: ui.azanMethodSelectionPart(),
                  leading: const Icon(Icons.arrow_back_ios)),
              ExpansionPanelItem(
                  isExpanded: false,
                  title: AppLocalizations.of(context)!
                      .translate("edite_tieme_prayer"),
                  content: ui.azanTime(),
                  leading: const Icon(Icons.arrow_back_ios)),
              ExpansionPanelItem(
                  isExpanded: false,
                  title: AppLocalizations.of(context)!.translate("azan_shiekh"),
                  content: ui.azanShiekhPart(),
                  leading: const Icon(Icons.arrow_back_ios)),
              ExpansionPanelItem(
                  isExpanded: false,
                  content: ui.fajrAzanShiekhPart(),
                  title: AppLocalizations.of(context)!
                      .translate("azan_shiekh_fajr"),
                  leading: const Icon(Icons.arrow_back_ios)),
              ExpansionPanelItem(
                  isExpanded: false,
                  title: AppLocalizations.of(context)!
                      .translate("general_settings"),
                  content: ui.generalSettingsPart(show()),
                  leading: const Icon(Icons.arrow_back_ios))
            ];
            return SafeArea(
              child: Scaffold(
                appBar: appBar(
                  context,
                  sizeConfig,
                  AppLocalizations.of(context)!.translate("settings"),
                ),
                body: Container(
                  color: Constants.CANVAS_COLOR,
                  child: LoadUiWithAd(
                    mainView: CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: CustomExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                items[index].isExpanded = !items[index].isExpanded;
                              });
                            },
                            children: [
                              ...items.map((ExpansionPanelItem item) {
                                return ExpansionPanel(
                                  headerBuilder: (context, isExpanded) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                item.icon ?? '',
                                                height: 26.0,
                                                color: Colors.white,
                                                allowDrawingOutsideViewBox:
                                                    true,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                contents[items.indexOf(item)]
                                                        .title ??
                                                    '',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  isExpanded: item.isExpanded,
                                  body: Container(
                                    margin: const EdgeInsets.all(4),
                                    width: MediaQuery.of(context).size.width,
                                    // height: MediaQuery.of(context).size.height,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        // topRight: Radius.circular(12),
                                        // topLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white,
                                          Colors.white,
                                        ],
                                      ),
                                    ),
                                    child:
                                        contents[items.indexOf(item)].content,
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 10,
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: AdmobBanner(bannerName: BannerName.BOSLA),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
