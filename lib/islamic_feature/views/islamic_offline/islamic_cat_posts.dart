import 'dart:convert';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:muslim_book/ads/admob_rectangle_updated.dart';
import 'package:muslim_book/home_feature/const/color.dart';
import 'package:muslim_book/islamic_feature/views/islamic_offline/islamic_post_offline_details.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/widgets/app_scaffold_title.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/widgets/loading_pkg/indicator/ball_beat_indicator.dart';
import 'package:muslim_book/widgets/loading_pkg/loading.dart';

class IslamicCatPosts extends StatefulWidget {
  final Map<String, dynamic> data;

  const IslamicCatPosts(this.data, {super.key});

  @override
  _IslamicCatPostsState createState() => _IslamicCatPostsState();
}

class _IslamicCatPostsState extends State<IslamicCatPosts> {
  bool isInternetConnected = false;
  int numberOfCharacter = 100;
  bool isInteger(num value) => value is int || value == value.roundToDouble();

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
                    if (isInteger((index + 1) / 4)) {
                      if ((index + 1).isEven) {
                        return Column(
                          children: [
                            _buildPostCardUi(data[index]),
                            AdmobRectangleUpdated(bannerName: BannerName.AZKAR,)
                          ],
                        );
                      } else {
                        return _buildPostCardUi(data[index]);
                      }
                    } else {
                      return _buildPostCardUi(data[index]);
                    }
                  } else {
                    return _buildPostCardUi(data[index]);
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

  _buildPostCardUi(data) {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    data['title'] ?? '',
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                        text: data['body'] != null
                            ? data['body'].toString().length > numberOfCharacter
                                ? data['body']
                                        .toString()
                                        .substring(0, numberOfCharacter) +
                                    '.. '
                                : data['body'].toString()
                            : data['title'].toString().length >
                                    numberOfCharacter
                                ? data['title']
                                        .toString()
                                        .substring(0, numberOfCharacter) +
                                    '.. '
                                : data['title'].toString(),
                        style: TextStyle(
                          color: darkish_green,
                          fontSize: 16,
                          height: 2,
                          fontFamily: 'arabic',
                          //fontWeight: FontWeight.w600
                        ),
                        children: <TextSpan>[
                          data['body'] != null
                              ? data['body'].toString().length >
                                      numberOfCharacter
                                  ? _buildTextSpan(data)
                                  : TextSpan()
                              : data['title'].toString().length >
                                      numberOfCharacter
                                  ? _buildTextSpan(data)
                                  : TextSpan()
                        ]),
                  ),
                ),
              ],
            )));
  }

  _buildTextSpan(data) {
    return TextSpan(
        text: 'عرض المزيد ..',
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'arabic',
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        IslamicPostOfflineDetails(data, widget.data['name'])));
          });
  }
}
