import 'package:muslim_book/home_feature/const/color.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ListSection extends StatelessWidget {
  List<Map> items = [
    {
      "icon": "assets/icons/group_437.svg",
      "title": "الاحاديث\nالنبوية",
      "selected": true
    },
    {
      "icon": "assets/icons/group_445.svg",
      "title": "مسابقات\nإسلامية",
      "selected": false
    },
    {
      "icon": "assets/icons/group_442.svg",
      "title": "قصص\nإسلامية",
      "selected": false
    },
    {
      "icon": "assets/icons/group_449.svg",
      "title": "خطب\nإسلامية",
      "selected": false
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 89,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            return buildItem(items[index]['icon'], items[index]['title'],
                items[index]['selected'],context);
          }),
    );
  }

  Widget buildItem(String icon, String title, bool selected,context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 115,
      decoration: BoxDecoration(
          color: selected ? darkish_green : light_grey,
          borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: selected ? Colors.white : darkish_green,
                          borderRadius: BorderRadius.circular(90)),
                      child: Center(
                          child: Icon(
                        Icons.arrow_back,
                        size: 13,
                        color: selected ? darkish_green : Colors.white,
                      )),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          title,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              color: selected ? Colors.white : darkish,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              height: 1.1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translate("store"),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "120 ",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
              left: -17,
              bottom: -10,
              child: Container(
                  height: 50,
                  width: 50,
                  child: SvgPicture.asset(
                    icon,
                    color: Colors.black12,
                    fit: BoxFit.fill,
                  ),),)
        ],
      ),
    );
  }
}
