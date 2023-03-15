import 'package:muslim_book/ads/admob_rectangle_updated.dart';
import 'package:muslim_book/home_feature/const/color.dart';
import 'package:muslim_book/home_feature/controllers/providers_get_post.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CreatePostView extends StatefulWidget {
  final PostsNotifier? postschanges;

  const CreatePostView({
    super.key,
    this.postschanges,
  });

  @override
  _CreatePostViewState createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  String content = "";
  bool loadingHere = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, SizingInformation sizeConfig) {
      return AppScaffold(
        //padding: EdgeInsets.symmetric(vertical: 20),
        transparentBackground: false,
        title: Text(AppLocalizations.of(context)!.translate("Post")),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              ),
            ),
            child: Stack(children: <Widget>[
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, right: 10.0, left: 10.0, bottom: 10.0),
                  child: Column(
                    children: [
                      // Text(AppLocalizations.of(context)!.translate("be_goodness"),
                      //   style: TextStyle(fontSize: 17, color: dark_blue_green),),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: Form(
                          key: formKey,
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: darkish_green),
                                    borderRadius: BorderRadius.circular(20)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: darkish_green),
                                    borderRadius: BorderRadius.circular(20)),
                                fillColor: Colors.grey[100],
                                filled: true,
                                hintText: AppLocalizations.of(context)!
                                    .translate("be_goodness"),
                                hintStyle: TextStyle(
                                    fontSize: 17, color: Colors.black38)),
                            maxLines: 5,
                            onChanged: (val) {
                              content = val;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 250,
                        child:
                            AdmobRectangleUpdated(bannerName: BannerName.AZKAR),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());

                          setState(() {
                            loadingHere = true;
                          });
                          if (this.widget.postschanges != null) {
                            this
                                .widget
                                .postschanges!
                                .createPost(content, 1)
                                .then((value) {
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  loadingHere = false;
                                });
                                if (this.widget.postschanges != null) {
                                  final snackBar = SnackBar(
                                    content: Text(
                                      this.widget.postschanges!.message ?? '',
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                                Navigator.of(context).pop();
                              });
                            });
                          }
                        },
                        child: Container(
                          width: 200,
                          height: 45,
                          decoration: BoxDecoration(
                              color: darkish_green,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate("Post"),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 250,
                        child:
                            AdmobRectangleUpdated(bannerName: BannerName.AZKAR),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
    });
  }
}
