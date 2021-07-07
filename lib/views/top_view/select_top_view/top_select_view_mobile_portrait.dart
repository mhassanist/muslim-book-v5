import 'package:base_app/ads/admob_rectangle.dart';
import 'package:base_app/models/banner_names_enum.dart';
import 'package:base_app/providers/tasbeeh_top_provider.dart';
import 'package:base_app/providers/top_provider.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/views/top_view/competition_top_view_mobile_portrait/competition_top_mobile_portrait_ui.dart';
import 'package:base_app/views/top_view/compeition_top_view.dart';
import 'package:base_app/views/top_view/tasbeeh_top_view.dart';
import 'package:base_app/widgets/app_scaffold.dart';
import 'package:base_app/widgets/share_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
class TopSelectionPage extends StatefulWidget {
  @override
  _TopSelectionPageState createState() => _TopSelectionPageState();
}

class _TopSelectionPageState extends State<TopSelectionPage> {
  var tops = ["أوائل المسابقات", "أوائل التسبيح"];
  var _images = [
    "assets/images/start_view/leaderboard_icon.svg",
    "assets/images/start_view/azkar.svg"
  ];
  var   widgetAddMob  ;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    widgetAddMob =
        AdMobRectangle(BannerName.Top ) ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      actions: [
        InkWell(
            onTap: () {
              Get.dialog(ShareDialog());
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.share),
            )),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/settings');
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(Icons.settings),
          ),
        ),
        Container(
          width: 10,
        )
      ],
      title: Text("الأوائل"),
      centerTitle: true,
      padding: EdgeInsets.zero,
      backGroundColor: Colors.white,
      child: ResponsiveBuilder(builder: (context, sizeConfig) {
     return CustomScrollView(

       slivers: <Widget>[
     SliverToBoxAdapter(
     child:
          StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          crossAxisCount: 4,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) => _buildItem(index),
          staggeredTileBuilder: (int index) => new StaggeredTile.count(2, 2),
        )),

         SliverToBoxAdapter(
             child:
             Container(
                 child: widgetAddMob
             //  ..  AdMobRectangle(BannerName.Top)
             )),
         SliverToBoxAdapter(
             child:
             SizedBox(
               height: 10,
             )),
        ],
        );
      }),
    );
  }

  _buildItem(int index) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _getCompetitionPage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>_getTabseehTopPage()),
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
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0XFF347D53),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(
                _images[index],
                width: index == 1 ? 85 : 75,
                fit: BoxFit.cover,
                color: Colors.grey.withOpacity(.3),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        tops[index],
                        style: TextStyle(
                            color: const Color(0XFF347D53),
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getCompetitionPage() {
    return ChangeNotifierProxyProvider<UserProvider, TopProvider>(
      create: (_) => TopProvider(null),
      update: (_, user, __) => TopProvider(user),
      child:ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => CompetitionTopView(),
        ),
      ),
    );
  }

  _getTabseehTopPage() {
    return ChangeNotifierProxyProvider<UserProvider, TasbeehTopProvider>(
      create: (_) => TasbeehTopProvider(null),
      update: (_, user, __) => TasbeehTopProvider(user),
      child:ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => TasbeehTopView(),
        ),
      ),
    );
  }
}
