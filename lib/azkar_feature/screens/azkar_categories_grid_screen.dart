import 'package:muslim_book/ads/admob_rectangle_updated.dart';
import 'package:muslim_book/ads/load_ui_with_add.dart';
import 'package:muslim_book/azkar_feature/providers/azkar_provider.dart';
import 'package:muslim_book/azkar_feature/widgets/azkar_categories_grid_item.dart';
import 'package:muslim_book/home_feature/controllers/home_controller.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:muslim_book/widgets/app_scaffold_title.dart';
import 'package:muslim_book/widgets/share_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AzkarCategoriesGridScreen extends StatefulWidget {
  AzkarCategoriesGridScreen({super.key});

  @override
  _AzkarCategoriesGridScreenState createState() =>
      _AzkarCategoriesGridScreenState();
}

class _AzkarCategoriesGridScreenState extends State<AzkarCategoriesGridScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, SizingInformation sizeConfig) {
        return AppScaffold(
          leading: InkWell(
            child: Container(
              margin: EdgeInsetsDirectional.only(start: 10),
              height: 20,
              width: 20,
              child: SvgPicture.asset("assets/icons/iconappbar.svg",
                  color: Colors.white),
            ),
            onTap: () {
              Get.find<HomeController>().scaffoldKey.currentState!.openDrawer();
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
              ),
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
            Container(
              width: 10,
            )
          ],
          title: AppScaffoldTitleWidget(
              title: AppLocalizations.of(context)!.translate("azkar")),
          centerTitle: true,
          child: LoadUiWithAd(
            mainView: Container(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      child: StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            vertical: sizeConfig.blockSizeHorizontal * 3,
                            horizontal: 5),
                        crossAxisCount: 6,
                        itemCount: Provider.of<AzkarProvider>(context)
                            .azkarList(context)
                            .length,
                        itemBuilder: (BuildContext context, int index) =>
                            AzkarCategoriesGridItem(
                          sizeConfig: sizeConfig,
                          zikrDetails: Provider.of<AzkarProvider>(context)
                              .azkarList(context)[index],
                        ),
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.count(2, 2),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AdmobRectangleUpdated(
                      bannerName: BannerName.AZKAR,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
