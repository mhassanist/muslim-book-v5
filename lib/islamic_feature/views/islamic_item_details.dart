import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslim_book/ads/admob_banner.dart';
import 'package:muslim_book/home_feature/const/color.dart';
import 'package:muslim_book/home_feature/controllers/providers_get_post.dart';
import 'package:muslim_book/home_feature/domian/model/categories_model.dart';
import 'package:muslim_book/home_feature/domian/model/islamic_posts_model.dart';
import 'package:muslim_book/home_feature/widgets/islamic_post_details.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/widgets/app_scaffold_title.dart';
import 'package:muslim_book/widgets/loading_pkg/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/all.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:share_plus/share_plus.dart';

class IslamicItemDetails extends ConsumerWidget {
  final Categore category;
  final bool mounted;

  IslamicItemDetails({required this.category, required this.mounted});

  late PostsNotifier postschanges;
  static int islamicPageIndex = 1;

  static List<Widget> islamicPostsListWidget = [];
  List<PostsOfIslamic> islamicPostsList = [];

  static final _key = Key('AHMED');

  RefreshController _islamicCatListRefreshController =
      RefreshController(initialRefresh: false);

  void _onIslamicPostsRefresh() async {
    await postschanges.getIslamicCategoryPosts(
        ++islamicPageIndex, category.id ?? -1);
    _islamicCatListRefreshController.loadComplete();
  }

  Future<void> _onIslamicPostsLoading() async {
    await postschanges.getIslamicCategoryPosts(
        ++islamicPageIndex, category.id ?? -1);

    if (postschanges.islamicCatPosts.isEmpty) {
      _islamicCatListRefreshController.loadNoData();
    } else {
      _islamicCatListRefreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    postschanges = ref.watch(getPosts);

    if (postschanges.isIslamicCatItemsLoading == true) {
      postschanges.getIslamicCategoryPosts(islamicPageIndex, category.id ?? -1);
    }
    if (postschanges.islamicCatPosts.isNotEmpty) {
      for (int i = 1; i <= postschanges.islamicCatPosts.length; i++) {
        if (!islamicPostsList.contains(postschanges.islamicCatPosts[i - 1])) {
          islamicPostsListWidget.add(_buildIslamicPostItem(
              postschanges.islamicCatPosts[i - 1], context));
          islamicPostsList.add(postschanges.islamicCatPosts[i - 1]);

          //add ad every 10 posts
          if (islamicPageIndex.isOdd && (i == 10 || i == 20)) {
            islamicPostsListWidget
                .add(AdmobBanner(bannerName: BannerName.BOSLA));
          } else if (islamicPageIndex.isEven &&
              (i == 5 || i == 15 || i == 25)) {
            islamicPostsListWidget
                .add(AdmobBanner(bannerName: BannerName.BOSLA));
          }
        }
      }
    }
    return ResponsiveBuilder(builder: (context, SizingInformation sizeConfig) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          islamicPostsList = [];
          islamicPostsListWidget = [];
          postschanges.islamicCatPosts = [];
          islamicPageIndex = 1;
          postschanges.isIslamicCatItemsLoading = true;
          Navigator.pop(context);
          //return CatsSubCatsBloc().categoryName = null;
        },
        child: Scaffold(
          appBar: AppBar(
            title: AppScaffoldTitleWidget(title: "${category.name}"),
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Color(0XFF347D53),
          ),
          body: Container(
              color: Color(0XFF347D53),
              child: postschanges.islamicCatPosts.isNotEmpty
                  ? _buildIslamicPostList()
                  : islamicPostsListWidget.isNotEmpty
                      ? _buildIslamicPostList()
                      : postschanges.isIslamicCatItemsLoading == true
                          ? Container(
                              child: Center(
                                child: Loading(
                                ),
                              ),
                            )
                          : Center(
                              child: Container(
                              child: Text(
                                "${AppLocalizations.of(context)!.translate("data_not_found")}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ))),
        ),
      );
    });
  }

  _buildIslamicPostList() {
    return SmartRefresher(
        key: _key,
        onRefresh: _onIslamicPostsRefresh,
        onLoading: _onIslamicPostsLoading,
        enablePullDown: false,
        enablePullUp: true,
        controller: _islamicCatListRefreshController,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.noMore) {
              body = Text(
                  AppLocalizations.of(context)!.translate("no_more_posts"));
            } else if (mode == LoadStatus.idle) {
              body =
                  Text(AppLocalizations.of(context)!.translate("pull_up-load"));
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text(AppLocalizations.of(context)!
                  .translate("release_to_load_more"));
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        child: ListView(
          children: islamicPostsListWidget,
        ));
  }

  Widget _buildIslamicPostItem(
      PostsOfIslamic islamicPost, BuildContext context) {
    return StatefulBuilder(
      builder: (context, setstate) => Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      islamicPost.name,
                      maxLines: 2,
                      style: TextStyle(
                          color: darkish_green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      IslamicPostDetails(islamicPost)));
                        },
                        child: Container(
                            child: (islamicPost.featured.endsWith('mp4') ||
                                    islamicPost.featured.isEmpty)
                                ? Image.asset(
                                    "assets/images/splash_view/logo.png",
                                    color: Colors.grey[100],
                                    fit: BoxFit.fill)
                                : Image.network(islamicPost.featured,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 0.5,
                    color: darkish_green,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Share.share(islamicPost.name +
                                "\n \n " +
                                "ادعوكم للانضمام الي تطبيق الاذان ، القران ،الاذكار . مسلم بوك من هنا \n👇👇👇\n https://play.google.com/store/apps/details?id=com.muslim_book.muslim_book");
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate("share"),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/path_514.svg',
                                    height: 15,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 0.5,
                        height: 30,
                        color: darkish_green,
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setstate(() {
                              islamicPost.liked
                                  ? postschanges
                                      .unlikeIslamicPost(islamicPost.id)
                                  : postschanges
                                      .likeIslamicPost(islamicPost.id);

                              islamicPost.liked = !islamicPost.liked;
                            });
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate("like"),
                                  style: TextStyle(
                                      color: islamicPost.liked
                                          ? darkish_green
                                          : Colors.grey[300]),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/group_313.svg',
                                  color: islamicPost.liked
                                      ? darkish_green
                                      : Colors.grey[300],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ))),
    );
  }
}
