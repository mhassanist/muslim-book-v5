import 'package:base_app/ads/admob_rectangle.dart';
import 'package:base_app/azkar_feature/providers/azkar_provider.dart';
import 'package:base_app/azkar_feature/widgets/zikr_list_widget.dart';
import 'package:base_app/home_feature/controllers/home_controller.dart';
import 'package:base_app/models/banner_names_enum.dart';
import 'package:base_app/utils/sizing_info_extension.dart';
import 'package:base_app/widgets/app_scaffold.dart';
import 'package:base_app/widgets/app_scaffold_title.dart';
import 'package:base_app/widgets/share_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AzkarListView extends StatefulWidget {
  AzkarListView({Key key}) : super(key: key);

  @override
  _AzkarListViewState createState() => _AzkarListViewState();
}

class _AzkarListViewState extends State<AzkarListView> {
  var   widgetAddMob  ;
  @override
  void initState() {
    widgetAddMob =
    AdMobRectangle(BannerName.AZKAR) ;
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, SizingInformation sizeConfig) {
        return AppScaffold(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Get.find<HomeController>()
                    .scaffoldKey.currentState.openDrawer();
              },
            ),
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
            title: AppScaffoldTitleWidget(title: "الأذكار"),
            centerTitle: true,
            child: Container(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      child: StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        // use it

                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            vertical: sizeConfig.blockSizeHorizontal * 3),
                        crossAxisCount: 6,
                        itemCount: Provider.of<AzkarProvider>(context)
                            .azkarList
                            .length,
                        itemBuilder: (BuildContext context, int index) =>
                            ZikrListWidget(
                                sizeConfig: sizeConfig,
                                zikrDetails: Provider.of<AzkarProvider>(context)
                                    .azkarList[index]),
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.count(2, 2),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Container(
                          height: 100,
                          child:widgetAddMob )),
                ],
              ),
            )

            // ),
            );
      },
    );
  }


}
