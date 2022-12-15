import 'package:muslim_book/home_feature/controllers/home_controller.dart';
import 'package:muslim_book/home_feature/widgets/single_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';

class CategoriesHomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return GetBuilder<HomeController>(builder: (controller) {
        return StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              vertical: sizeConfig.blockSizeHorizontal * 3),
          crossAxisCount: 4,
          itemCount: controller.getCategories(context).length,
          itemBuilder: (BuildContext context, int index) =>
              SingleCategoryWidget(
                  sizeConfig: sizeConfig,
                  categoryDetails: controller.getCategories(context)[index]),
          staggeredTileBuilder: (int index) => new StaggeredTile.count(2, 2),
        );
      });
    });
  }

}
