import 'package:base_app/home_feature/const/color.dart';
import 'package:base_app/home_feature/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CategoriesHorizontalHomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return GetBuilder<HomeController>(builder: (controller) {
        return GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 4.0,
            childAspectRatio: (1 / .4),
            crossAxisSpacing: 4.0,
            children: controller.categories.map((Map<String, dynamic> item) {
              return InkWell(
                  onTap: item["onTap"], child: buildItem(sizeConfig, item));
            }).toList());
        // ListView.builder(
        //     itemCount: controller.categories.length,
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (ctx, index) {
        //       return InkWell(
        //           onTap: controller.categories[index]["onTap"],
        //           child: buildItem(sizeConfig, controller.categories[index]));
        //     });
      });
    });
  }

  Widget buildItem(SizingInformation sizeConfig,
      final Map<String, dynamic> categoryDetails) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 115,
      decoration: BoxDecoration(
          color: light_grey, borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: darkish_green,
                          borderRadius: BorderRadius.circular(90)),
                      // child: Center(
                      //     child: Icon(
                      //   Icons.arrow_back,
                      //   size: 10,
                      //   color: Colors.white,
                      // )),
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
                          categoryDetails["name"],
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              color: darkish,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              height: 1.1),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
            left: 3,
            bottom: 2,
            child: Container(
              height: 20,
              width: 35,
              child: SvgPicture.asset(
                categoryDetails["icon"],
                color: Colors.black12,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
    );
  }
}
