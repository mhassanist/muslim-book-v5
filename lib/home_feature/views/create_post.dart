import 'package:muslim_book/ads/admob_banner.dart';
import 'package:muslim_book/home_feature/const/color.dart';
import 'package:muslim_book/home_feature/controllers/providers_get_post.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/widgets/loading_pkg/loading.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({
    super.key,
    this.postsChanges,
  });

  final PostsNotifier? postsChanges;

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
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
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 0,
                right: 10.0,
                left: 10.0,
                bottom: 10.0,
              ),
              child: Column(
                children: [
                  // Text(AppLocalizations.of(context)!.translate("be_goodness"),
                  //   style: TextStyle(fontSize: 17, color: dark_blue_green),),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 5,
                    ),
                    child: Form(
                      key: formKey,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: darkish_green,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: darkish_green,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          fillColor: Colors.grey[100],
                          filled: true,
                          hintText: AppLocalizations.of(context)!
                              .translate("be_goodness"),
                          hintStyle: const TextStyle(
                            fontSize: 17,
                            color: Colors.black38,
                          ),
                        ),
                        maxLines: 5,
                        onChanged: (val) {
                          content = val;
                        },
                      ),
                    ),
                  ),
                  const AdmobBanner(bannerName: BannerName.AZKAR),
                  const SizedBox(
                    height: 20,
                  ),

                  if (loadingHere)
                    const SizedBox(
                      height: 100,
                      child: Center(
                        child: Loading(),
                      ),
                    )
                  else
                    InkWell(
                      onTap: () {
                        if (loadingHere) {
                          return;
                        }
                        if (content.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .translate("post_empty")),
                            ),
                          );
                          return;
                        }
                        FocusScope.of(context).requestFocus(FocusNode());

                        setState(() {
                          loadingHere = true;
                        });
                        if (widget.postsChanges != null) {
                          widget.postsChanges!
                              .createPost(content, 1)
                              .then((sent) {
                            if (!context.mounted) return;
                            if (!sent) {
                              setState(() {
                                loadingHere = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)!
                                      .translate("cannot_reach")),
                                ),
                              );
                              return;
                            }
                            Future.delayed(const Duration(seconds: 1), () {
                              if (!context.mounted) return;
                              // setState(() {
                              //   loadingHere = false;
                              // });
                              if (widget.postsChanges != null) {
                                Navigator.of(context).pop();
                                // final snackBar = SnackBar(
                                //   content: Text(
                                //     widget.postsChanges!.message ?? '',
                                //   ),
                                // );
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(snackBar);
                              }
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  const AdmobBanner(bannerName: BannerName.AZKAR),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
