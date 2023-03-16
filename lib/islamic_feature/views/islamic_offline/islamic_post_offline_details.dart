import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:muslim_book/ads/admob_rectangle_updated.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:muslim_book/widgets/app_scaffold_title.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class IslamicPostOfflineDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  final String catName;

  const IslamicPostOfflineDetails(
    this.data,
    this.catName, {
    super.key,
  });

  @override
  State<IslamicPostOfflineDetails> createState() =>
      _IslamicPostOfflineDetailsState();
}

class _IslamicPostOfflineDetailsState extends State<IslamicPostOfflineDetails> {
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
    return ResponsiveBuilder(
      builder: (context, SizingInformation sizeConfig) {
        return AppScaffold(
          padding: EdgeInsets.symmetric(vertical: 20),
          transparentBackground: false,
          title: AppScaffoldTitleWidget(title: widget.catName),
          centerTitle: true,
          child: Column(
            children: [
              isInternetConnected == true
                  ? _buildAdSection(context)
                  : Container(),
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                children: [
                  widget.data['body'] != null
                      ? _buildPostTitleUi(widget.data)
                      : Container(),
                  widget.data['body'] != null ? _buildSizedBox() : Container(),
                  _buildPostContentUi(widget.data),
                  _buildSizedBox(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _buildPostTitleUi(Map<String, dynamic> data) {
    return Text(data['title'] ?? '',
        style: TextStyle(fontSize: 16, height: 2, fontWeight: FontWeight.w600));
  }

  _buildSizedBox() {
    return SizedBox(
      height: 10,
    );
  }

  _buildPostContentUi(Map<String, dynamic> data) {
    return Text(
      data['body'] != null ? data['body'] : data['title'],
      style: TextStyle(
        fontSize: 16, height: 2,
        //fontWeight: FontWeight.w600
      ),
    );
  }

  _buildAdSection(BuildContext context) {
    return AdmobRectangleUpdated(bannerName: BannerName.AZKAR);
  }
}
