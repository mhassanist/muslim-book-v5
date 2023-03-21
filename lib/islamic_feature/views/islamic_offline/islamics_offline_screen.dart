import 'dart:convert';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:muslim_book/ads/admob_banner.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'islamic_cat_posts.dart';

class IslamicsOfflineScreen extends StatefulWidget {
  const IslamicsOfflineScreen({super.key});

  @override
  _IslamicsOfflineScreenState createState() => _IslamicsOfflineScreenState();
}

class _IslamicsOfflineScreenState extends State<IslamicsOfflineScreen> {
  bool isInternetConnected = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await InternetConnectionChecker().hasConnection.then((value) {
        if (value == true) {
          setState(() {
            isInternetConnected = true;
          });
        } else {
          setState(() {
            isInternetConnected = false;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString("assets/islamics_offline/categories.json"),
        builder: (context, snapshot) {
          var data = jsonDecode(snapshot.data.toString());
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildIslamicCatsGridWithAd(data);
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

  Widget _buildIslamicCatsGridWithAd(data) {
    return Column(
      children: [
        ResponsiveBuilder(builder: (context, SizingInformation sizeConfig) {
          return Container(
            child: StaggeredGridView.countBuilder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  vertical: sizeConfig.blockSizeHorizontal * 3),
              crossAxisCount: 6,
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return _buildIslamicCatsItem(index, sizeConfig, data);
              },
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, 2),
            ),
          );
        }),
        isInternetConnected == true
            ? AdmobBanner(bannerName: BannerName.AZKAR)
            : Container(),
        ResponsiveBuilder(builder: (context, SizingInformation sizeConfig) {
          return Container(
            child: StaggeredGridView.countBuilder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  vertical: sizeConfig.blockSizeHorizontal * 3),
              crossAxisCount: 6,
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) {
                if (index >= 9) {
                  return _buildIslamicCatsItem(index, sizeConfig, data);
                } else {
                  return Container(
                    height: 0,
                  );
                }
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.count(
                  index >= 9 ? 2 : 0, index >= 9 ? 2 : 0),
            ),
          );
        }),
        isInternetConnected == true
            ? AdmobBanner(bannerName: BannerName.AZKAR)
            : Container(),
        ResponsiveBuilder(builder: (context, SizingInformation sizeConfig) {
          return Container(
            child: StaggeredGridView.countBuilder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  vertical: sizeConfig.blockSizeHorizontal * 3),
              crossAxisCount: 6,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                if (index >= 15) {
                  return _buildIslamicCatsItem(index, sizeConfig, data);
                } else {
                  return Container(
                    height: 0,
                  );
                }
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.count(
                  index >= 15 ? 2 : 0, index >= 15 ? 2 : 0),
            ),
          );
        })
      ],
    );
  }
}
