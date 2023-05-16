import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslim_book/home_feature/controllers/providers_get_post.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'islamic_item_details.dart';

class IslamicsScreen extends ConsumerWidget {
  PostsNotifier? postschanges;
  final bool mounted;

  IslamicsScreen({required this.mounted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (postschanges == null) postschanges = ref.watch(getPosts);

    if (postschanges!.isloading == true) {
      postschanges!.getcategories();
    }
    return SafeArea(
      child: postschanges!.isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : postschanges!.categories.isEmpty
              ? _buildDataNotFoundUI(context)
              : ResponsiveBuilder(
                  builder: (context, SizingInformation sizeConfig) {
                    return Container(
                      child: StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            vertical: sizeConfig.blockSizeHorizontal * 3),
                        crossAxisCount: 6,
                        itemCount: postschanges!.categories.length,
                        itemBuilder: (BuildContext context, int index) =>
                            _buildIslamicCatsItem(index, sizeConfig, context),
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.count(2, 2),
                      ),
                    );
                  },
                ),
    );
  }

  _buildIslamicCatsItem(
      int index, SizingInformation sizeConfig, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IslamicItemDetails(
                    category: postschanges!.categories[index],
                    mounted: mounted)));
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
              shape: BoxShape.circle,
            ),
            child: ExtendedImage.asset(
              "assets/images/islamic_icons/${postschanges!.categories[index].id}.png",
              fit: BoxFit.cover,
              width: sizeConfig.blockSizeHorizontal * 15,
              height: sizeConfig.blockSizeHorizontal * 15,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${postschanges!.categories[index].name}",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  _buildDataNotFoundUI(BuildContext context) {
    return Center(
        child: Container(
      child: Text(
        "${AppLocalizations.of(context)!.translate("data_not_found")}",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }
}
