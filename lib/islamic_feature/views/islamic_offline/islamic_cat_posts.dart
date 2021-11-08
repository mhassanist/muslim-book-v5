import 'dart:convert';

import 'package:base_app/ads/admob_rectangle.dart';
import 'package:base_app/home_feature/const/color.dart';
import 'package:base_app/islamic_feature/views/islamic_offline/islamic_post_offline_details.dart';
import 'package:base_app/models/banner_names_enum.dart';
import 'package:base_app/widgets/app_scaffold_title.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';

class IslamicCatPosts extends StatefulWidget {
  final Map<String, dynamic> data;

  const IslamicCatPosts(this.data, {Key key}) : super(key: key);

  @override
  _IslamicCatPostsState createState() => _IslamicCatPostsState();
}

class _IslamicCatPostsState extends State<IslamicCatPosts> {
  int adIndex = 1;
  bool isInternetConnected = false;

  @override
  void initState() {
    adIndex = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await DataConnectionChecker().hasConnection.then((value) {
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
    return Scaffold(
      appBar: AppBar(
        title: AppScaffoldTitleWidget(title: "${widget.data['name']}"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0XFF347D53),
      ),
      body: Container(
        color: Color(0XFF347D53),
        child: _buildIslamicPostList(),
      ),
    );
  }

  _buildIslamicPostList() {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString("assets/islamics_offline/${widget.data['id']}.json"),
        builder: (context, snapshot) {
          var data = jsonDecode(snapshot.data.toString());
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  if (isInternetConnected == true) {
                    if ((index + 1) / 10 == adIndex) {
                      adIndex = adIndex + 1;
                      return Column(
                        children: [
                          Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IslamicPostOfflineDetails(
                                                  data[index],
                                                  widget.data['name'])));
                                },
                                child: Container(
                                    height: 150,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            data[index]['title'],
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: darkish_green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            data[index]['body'] != null
                                                ? data[index]['body']
                                                : data[index]['title'],
                                            maxLines: 3,
                                            style: TextStyle(
                                              color: darkish_green,
                                              fontSize: 16, height: 2,
                                              //fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              )),
                          Container(
                              height: MediaQuery.of(context).size.height / 3.0,
                              child: AdMobRectangle(BannerName.AZKAR))
                        ],
                      );
                    } else {
                      return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          IslamicPostOfflineDetails(data[index],
                                              widget.data['name'])));
                            },
                            child: Container(
                                height: 150,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        data[index]['title'],
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: darkish_green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        data[index]['body'] != null
                                            ? data[index]['body']
                                            : data[index]['title'],
                                        maxLines: 3,
                                        style: TextStyle(
                                          color: darkish_green,
                                          fontSize: 16, height: 2,
                                          //fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ));
                    }
                  } else {
                    return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IslamicPostOfflineDetails(
                                            data[index], widget.data['name'])));
                          },
                          child: Container(
                              height: 150,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      data[index]['title'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: darkish_green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      data[index]['body'] != null
                                          ? data[index]['body']
                                          : data[index]['title'],
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: darkish_green,
                                        fontSize: 16, height: 2,
                                        //fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ));
                  }
                });
          }
          return Center(
            child: Loading(
              indicator: BallBeatIndicator(),
              size: 70.0,
              color: Colors.white,
            ),
          );
        });
  }
}
