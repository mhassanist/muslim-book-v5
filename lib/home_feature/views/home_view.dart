import 'package:base_app/home_feature/controllers/home_controller.dart';
import 'package:base_app/home_feature/widgets/azan_home_widget.dart';
import 'package:base_app/home_feature/widgets/categories_home_widget.dart';
import 'package:base_app/utils/sizing_info_extension.dart';
import 'package:base_app/widgets/app_scaffold.dart';
import 'package:base_app/widgets/share_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, SizingInformation sizeConfig) {
      return AppScaffold(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Get
                .find<HomeController>()
                .scaffoldKey.currentState.openDrawer();
          },
        ),        actions: [
          InkWell(
              onTap: () {
                Get.dialog(ShareDialog());
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.share),
              )),
          // InkWell(
          //   onTap: () {
          //     Navigator.pushNamed(context, '/settings');
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 5),
          //     child: Icon(Icons.settings),
          //   ),
          // )
        ],
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(top: sizeConfig.blockSizeVertical / 2),
          child: Container(
            height: sizeConfig.blockSizeVertical * 6.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter:
                    new ColorFilter.mode(Colors.white, BlendMode.srcIn),
                image: AssetImage(
                  "assets/images/splash_view/decoration.png",
                ),
              ),
            ),
            child: Center(
              child: Image.asset(
                "assets/images/splash_view/logo.png",
                height: sizeConfig.blockSizeVertical * 5,
              ),
            ),
          ),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 100 * 3),
                    child:
                    SingleChildScrollView(
                      child:Column(
                        children: [
                          Container(
                            child: AzanHomeWidget(),
                          ) ,
                          CategoriesHomeWidget()
                        ],
                      )

              )

          // child: CustomScrollView(
          //   slivers: [
          //     SliverToBoxAdapter(
          //       child: AzanHomeWidget(),
          //     ),
          //     // SliverToBoxAdapter(
          //     //   child: CategoriesHomeWidget(),
          //     // ),
          //     SliverFillRemaining(
          //       child:  Center(
          //         child:  CategoriesHomeWidget(),
          //       ),
          //
          //     )
          //   ],
          // ),
        ),
      );
    });
  }
}
