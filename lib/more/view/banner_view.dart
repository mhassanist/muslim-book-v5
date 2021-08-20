import 'package:base_app/more/view/banner_item.dart';
import 'package:flutter/material.dart';

class BannersView extends StatelessWidget {
  List<Map> items = [
    {
      "icon": "assets/images/more/Group_human.svg",
      "title": "join_us",
      "sub": "The_largest_Islamic_community",
      "title_button": "Join_now",
      "selected": false
    },
    {
      "icon": "assets/images/more/book.svg",
      "title": "Do_not_forget",
      "sub": "Read_daily_rosesn",
      "title_button": "Read_now",
      "selected": false
    },
    {
      "icon": "assets/images/more/lamp.svg",
      "title": "know",
      "sub": "Every_day_useful_information",
      "title_button": "Join_now",
      "selected": false
    },
    {
      "icon": "assets/images/more/drum.svg",
      "title": "Ready_for_challenge",
      "sub": "you_have_new_questions",
      "title_button": "start_now",
      "selected": false,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          itemCount: items.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (ctx, index) {
            return BannerItem(
                icon: items[index]['icon'],
                title: items[index]['title'],
                sub: items[index]['sub'],
                selected: items[index]['selected'],
                title_button: items[index]['title_button']);
          }),
    );
  }
}
