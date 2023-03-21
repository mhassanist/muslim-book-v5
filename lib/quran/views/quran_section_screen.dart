import 'package:muslim_book/ads/admob_banner.dart';
import 'package:muslim_book/ads/load_ui_with_add.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/quran/views/quran_reading_index.dart';
import 'package:muslim_book/quran/views/quran_listening_view.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

class QuranSectionScreen extends StatefulWidget {
  const QuranSectionScreen({super.key});

  @override
  State<QuranSectionScreen> createState() => _QuranSectionScreenState();
}

class _QuranSectionScreenState extends State<QuranSectionScreen> {
  var _images = [
    "assets/images/islamic_offline_icons/17.png",
    "assets/images/islamic_offline_icons/14.png"
  ];
  var _title = ["قراءة", "استماع"];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context)!.translate("moshaf")),
      centerTitle: true,
      child: ResponsiveBuilder(
        builder: (context, sizeConfig) {
          return LoadUiWithAd(
            mainView: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                    child: StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  crossAxisCount: 4,
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildItem(index),
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(2, 2),
                )),
                SliverToBoxAdapter(
                    child: AdmobBanner(bannerName: BannerName.TOP)),
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: 10,
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildItem(int index) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuranReadingIndex()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuranListeningView()),
            );
            break;
          default:
            break;
        }
      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color(0XFFF1F6F3),
            borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            Padding(
              padding: index == 1 ? EdgeInsets.all(1) : EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: index == 1
                    ? Icon(
                        Icons.headset,
                        color: Colors.grey.withOpacity(.3),
                        size: 80,
                      )
                    : Image.asset(
                        _images[index],
                        width: 75,
                        fit: BoxFit.cover,
                        color: Colors.grey.withOpacity(.3),
                      ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(top: 35),
                child: Container(
                  //width: double.infinity,
                  child: Text(
                    _title[index],
                    style: TextStyle(
                        color: const Color(0XFF347D53),
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
