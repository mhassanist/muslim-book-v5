import 'dart:convert';

import 'package:base_app/utils/sizing_info_extension.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'islamic_cat_posts.dart';

class IslamicsOfflineScreen extends StatefulWidget {
  const IslamicsOfflineScreen({Key key}) : super(key: key);

  @override
  _IslamicsOfflineScreenState createState() => _IslamicsOfflineScreenState();
}

class _IslamicsOfflineScreenState extends State<IslamicsOfflineScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString("assets/islamics_offline/categories.json"),
        builder: (context, snapshot) {
          var data = jsonDecode(snapshot.data.toString());
          if (snapshot.connectionState == ConnectionState.done) {
            return ResponsiveBuilder(
                builder: (context, SizingInformation sizeConfig) {
              return Container(
                child: StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      vertical: sizeConfig.blockSizeHorizontal * 3),
                  crossAxisCount: 6,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildIslamicCatsItem(index, sizeConfig, data),
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(2, 2),
                ),
              );
            });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  _buildIslamicCatsItem(int index, SizingInformation sizeConfig, data) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IslamicCatPosts(data[index])));
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
              shape: BoxShape.circle,
            ),
            child: ExtendedImage.asset(
              "assets/images/islamic_offline_icons/${data[index]['id']}.png",
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
            "${data[index]['name']}",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
