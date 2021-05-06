import 'package:base_app/quran/provider/quran_provider.dart';
import 'package:base_app/quran/views/quran_settings_generated_list.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuranSettingsDrawer extends StatefulWidget {
  @override
  _QuranSettingsDrawerState createState() => _QuranSettingsDrawerState();
}

class _QuranSettingsDrawerState extends State<QuranSettingsDrawer> {
  var _recitersGroupValue;
  var _translationGroupValue;
  var _transliterationGroupValue;
  TextEditingController controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recitersGroupValue =
        Provider.of<QuranProvider>(context, listen: false).selectedReciter;
    _translationGroupValue =
        Provider.of<QuranProvider>(context, listen: false).selectedTranslation;
    _transliterationGroupValue =
        Provider.of<QuranProvider>(context, listen: false)
            .selectedTransliteration;
    controller.text = "${locator<Prefs>().ayahRepeatCount}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(ScreenUtil().setWidth(30)),
              topStart: Radius.circular(ScreenUtil().setWidth(30)))),
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(20),
        horizontal: ScreenUtil().setWidth(20),
      ),
      width: MediaQuery.of(context).size.width / 100 * 70,
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                width: double.infinity,
                child: Text(
                  "إعدادات القرآن",
                  style: GoogleFonts.almarai(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(23)),
                ),
              ),
            ),
            buildRecitersWidget(context),
            SliverToBoxAdapter(
              child: buildTransliterationWidget(context),
            ),
            SliverToBoxAdapter(
              child: buildTranslationsWidget(context),
            ),
            SliverToBoxAdapter(
              child: ListTile(
                title: Text(
                  "تفعيل الترجمة",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                trailing: CupertinoSwitch(
                  value: Provider.of<QuranProvider>(context).allowTranslation,
                  onChanged: (val) {
                    Provider.of<QuranProvider>(context, listen: false)
                        .setAllowTranslation(val);
                  },
                  trackColor: Colors.grey,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ListTile(
                title: Text(
                  "تفعيل الترجمة الحرفية",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                trailing: CupertinoSwitch(
                  value:
                      Provider.of<QuranProvider>(context).allowTransliteration,
                  onChanged: (val) {
                    Provider.of<QuranProvider>(context, listen: false)
                        .setAllowTransliteration(val);
                  },
                  trackColor: Colors.grey,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ListTile(
                title: Text(
                  "تفعيل تكرار الآية",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                trailing: CupertinoSwitch(
                  value: Provider.of<QuranProvider>(context).allowRepeatAyah,
                  onChanged: (val) {
                    Provider.of<QuranProvider>(context, listen: false)
                        .allowRepeatAyah = val;
                  },
                  trackColor: Colors.grey,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ListTile(
                title: Text(
                  "عدد تكرار الآية",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(40),
                  child: TextField(
                    onSubmitted: (s) {
                      try {
                        int count = int.parse("$s");
                        if (count > 1) {
                          locator<Prefs>().setAyahRepeetCount(count);
                        } else {
                          controller.text = "2";
                          locator<Prefs>().setAyahRepeetCount(2);
                        }
                      } catch (e) {
                        controller.text = "2";
                        locator<Prefs>().setAyahRepeetCount(2);
                      }
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    enabled:
                        Provider.of<QuranProvider>(context).allowRepeatAyah,
                    controller: controller,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(String text, Function onTap) => Column(
        children: <Widget>[
          ListTile(
            onTap: () async {
              await onTap();
            },
            title: Text(
              "$text",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),
          Divider()
        ],
      );
  Widget buildRecitersWidget(BuildContext context) {
    return SliverToBoxAdapter(
        child: buildListTile("إختر إسم الشيخ", () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuranSettingsGeneratedListView(
            provider: Provider.of<QuranProvider>(context, listen: false),
            title: "إختر إسم الشيخ",
            groupValue: _recitersGroupValue,
            generatedList: Provider.of<QuranProvider>(context).allReciters,
            onChange: (val) {
              Provider.of<QuranProvider>(context, listen: false)
                  .updateReciter(val);
            },
          ),
        ),
      );
    }));
  }

  Widget buildTranslationsWidget(BuildContext context) {
    return buildListTile("إختر الترجمة", () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuranSettingsGeneratedListView(
            provider: Provider.of<QuranProvider>(context, listen: false),
            title: "إختر الترجمة",
            downloadedMap:
                Provider.of<QuranProvider>(context).downloadedTranslation,
            groupValue: _translationGroupValue,
            generatedList: Provider.of<QuranProvider>(context).allTranslation,
            onChange: (val) async {
              await Provider.of<QuranProvider>(context, listen: false)
                  .updateSelectedTranslation(val);
            },
            onDownLoad: (index) async {
              await Provider.of<QuranProvider>(context, listen: false)
                  .downLoadTranslation(
                      "${Provider.of<QuranProvider>(context, listen: false).allTranslation[index].identifier}",
                      context,
                      true);
            },
          ),
        ),
      );
    });

    return ExpandablePanel(
      header: Text("إختر الترجمة"),
      expanded: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (c, index) {
          return ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
            title: Text(
              Provider.of<QuranProvider>(context).allTranslation[index].name,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            subtitle: Text(Provider.of<QuranProvider>(context)
                .allTranslation[index]
                .englishName),
            trailing: Provider.of<QuranProvider>(context)
                    .downloadedTranslation
                    .containsKey(Provider.of<QuranProvider>(context)
                        .allTranslation[index]
                        .identifier)
                ? Radio(
                    value: Provider.of<QuranProvider>(context)
                        .allTranslation[index]
                        .identifier,
                    groupValue: _translationGroupValue,
                    onChanged: (val) async {
                      await Provider.of<QuranProvider>(context, listen: false)
                          .updateSelectedTranslation(
                              Provider.of<QuranProvider>(context, listen: false)
                                  .allTranslation[index]
                                  .identifier);
                    })
                : IconButton(
                    icon: Icon(Icons.file_download),
                    onPressed: () async {
                      await Provider.of<QuranProvider>(context, listen: false)
                          .downLoadTranslation(
                              "${Provider.of<QuranProvider>(context, listen: false).allTranslation[index].identifier}",
                              context,
                              true);
                    }),
          );
        },
        itemCount: Provider.of<QuranProvider>(context).allTranslation == null
            ? 0
            : Provider.of<QuranProvider>(context).allTranslation.length,
      ),
    );
  }

  Widget buildTransliterationWidget(BuildContext context) {
    return buildListTile("إختر الترجمة الحرفية", () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuranSettingsGeneratedListView(
            provider: Provider.of<QuranProvider>(context, listen: false),
            title: "إختر الترجمة الحرفية",
            downloadedMap:
                Provider.of<QuranProvider>(context).downloadedTranslation,
            groupValue: _transliterationGroupValue,
            generatedList:
                Provider.of<QuranProvider>(context).allTransliteration,
            onChange: (val) async {
              await Provider.of<QuranProvider>(context, listen: false)
                  .updateSelectedTransliteration(val);
            },
            onDownLoad: (index) async {
              await Provider.of<QuranProvider>(context, listen: false)
                  .downLoadTranslation(
                      "${Provider.of<QuranProvider>(context, listen: false).allTransliteration[index].identifier}",
                      context,
                      false);
            },
          ),
        ),
      );
    });
    return ExpandablePanel(
      header: Text("إختر الترجمة الحرفية"),
      expanded: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (c, index) {
          return ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
            title: Text(
              Provider.of<QuranProvider>(context)
                  .allTransliteration[index]
                  .name,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            subtitle: Text(Provider.of<QuranProvider>(context)
                .allTransliteration[index]
                .englishName),
            trailing: Provider.of<QuranProvider>(context)
                    .downloadedTranslation
                    .containsKey(Provider.of<QuranProvider>(context)
                        .allTransliteration[index]
                        .identifier)
                ? Radio(
                    value: Provider.of<QuranProvider>(context)
                        .allTransliteration[index]
                        .identifier,
                    groupValue: _transliterationGroupValue,
                    onChanged: (val) async {
                      await Provider.of<QuranProvider>(context, listen: false)
                          .updateSelectedTransliteration(
                              Provider.of<QuranProvider>(context, listen: false)
                                  .allTransliteration[index]
                                  .identifier);
                    })
                : IconButton(
                    icon: Icon(Icons.file_download),
                    onPressed: () async {
                      await Provider.of<QuranProvider>(context, listen: false)
                          .downLoadTranslation(
                              "${Provider.of<QuranProvider>(context, listen: false).allTransliteration[index].identifier}",
                              context,
                              false);
                    }),
          );
        },
        itemCount:
            Provider.of<QuranProvider>(context).allTransliteration == null
                ? 0
                : Provider.of<QuranProvider>(context).allTransliteration.length,
      ),
    );
  }
}
