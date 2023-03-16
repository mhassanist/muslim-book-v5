import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslim_book/ads/admob_rectangle_updated.dart';
import 'package:muslim_book/home_feature/const/color.dart';
import 'package:muslim_book/home_feature/controllers/providers_get_post.dart';
import 'package:muslim_book/home_feature/domian/model/categories_model.dart';
import 'package:muslim_book/home_feature/domian/model/islamic_posts_model.dart';
import 'package:muslim_book/home_feature/domian/model/post_model.dart';
import 'package:muslim_book/home_feature/domian/repository_home.dart';
import 'package:muslim_book/home_feature/views/create_post.dart';
import 'package:muslim_book/home_feature/widgets/azan_home_widget.dart';
import 'package:muslim_book/home_feature/widgets/categories_horisontal_home_widget.dart';
import 'package:muslim_book/home_feature/widgets/islamic_post_details.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/main.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/views/login_pop_up_view/login_pop_up_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muslim_book/widgets/loading_pkg/indicator/ball_beat_indicator.dart';
import 'package:muslim_book/widgets/loading_pkg/loading.dart';
import "package:provider/provider.dart" as ProviderUser;
import 'package:share_plus/share_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends ConsumerWidget {
  HomeRepository homeRepository = HomeRepository();
  late PostsNotifier postschanges;
  int pageIndex = 1;
  int islamicPageIndex = 1;
  List<Widget> postsListWidget = [];
  List<int> postsListIDS = [];
  List<Widget> islamicPostsListWidget = [];
  List<PostsOfIslamic> islamicPostsList = [];
  RefreshController _postsRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController _islamicPostsRefreshController =
      RefreshController(initialRefresh: false);
  Key _postsKey = Key('posts');

  void _onPostsRefresh() async {
    // monitor network fetch
    await postschanges.getPosts(++pageIndex);
    // if failed,use refreshFailed()
    _postsRefreshController.refreshCompleted();
  }

  Future<void> _onPostsLoading() async {
    await postschanges.getPosts(++pageIndex);
    if (postschanges.posts.data.isEmpty) {
      _postsRefreshController.loadNoData();
    } else {
      _postsRefreshController.loadComplete();
    }
  }

  void _onIslamicPostsRefresh() async {
    // monitor network fetch
    await postschanges.getIslamicPosts(++islamicPageIndex, 8);
    // if failed,use refreshFailed()
    _islamicPostsRefreshController.refreshCompleted();
  }

  Future<void> _onIslamicPostsLoading() async {
    await postschanges.getIslamicPosts(++islamicPageIndex, 8);
    if (postschanges.islamicPosts.isEmpty) {
      _islamicPostsRefreshController.loadNoData();
    } else {
      _islamicPostsRefreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    postschanges = ref.watch(getPosts);
    if (postschanges.isloading == true) {
      postschanges.getPosts(pageIndex);
    }
    if (postschanges.posts.data.isNotEmpty) {
      if (postschanges.posts.data.isNotEmpty) {
        if (postschanges.posts.meta!.currentPage == 1) {
          postsListWidget = [];
          postsListIDS = [];
        }
        for (int i = 1; i <= postschanges.posts.data.length; i++) {
          if (!postsListIDS.contains(postschanges.posts.data[i - 1].id)) {
            postsListWidget.add(buildPostItem(postschanges.posts.data[i - 1]));
            postsListIDS.add(postschanges.posts.data[i - 1].id ?? -1);

            //add ad every 10 posts
            if (pageIndex.isOdd && (i == 10 || i == 20)) {
              postsListWidget
                  .add(AdmobRectangleUpdated(bannerName: BannerName.BOSLA));
            } else if (pageIndex.isEven && (i == 5 || i == 15 || i == 25)) {
              postsListWidget
                  .add(AdmobRectangleUpdated(bannerName: BannerName.BOSLA));
            }
          }
        }
      }
    }
    if (postschanges.isloading == true) {
      postschanges.getcategories();
      postschanges.getIslamicPosts(islamicPageIndex, 8);
    }
    if (postschanges.islamicPosts.isNotEmpty) {
      for (int i = 1; i <= postschanges.islamicPosts.length; i++) {
        if (!islamicPostsList.contains(postschanges.islamicPosts[i - 1])) {
          islamicPostsListWidget.add(
              _buildIslamicPostItem(postschanges.islamicPosts[i - 1], context));
          islamicPostsList.add(postschanges.islamicPosts[i - 1]);

          //add ad every 10 posts
          if (islamicPageIndex.isOdd && (i == 10 || i == 20)) {
            islamicPostsListWidget
                .add(AdmobRectangleUpdated(bannerName: BannerName.BOSLA));
          } else if (islamicPageIndex.isEven &&
              (i == 5 || i == 15 || i == 25)) {
            islamicPostsListWidget
                .add(AdmobRectangleUpdated(bannerName: BannerName.BOSLA));
          }
        }
      }
    }

    return MyApp.loading
        ? Container(
            child: Center(
              child: Loading(
                indicator: BallBeatIndicator(),
                size: 70.0,
                color: Constants.PRIMARY_DARK_COLOR,
              ),
            ),
          )
        : SafeArea(
            child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AzanHomeWidget(),
                buildTitle(
                    AppLocalizations.of(context)!.translate("MainSections")),
                Container(
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    child: CategoriesHorizontalHomeWidget()),
                SizedBox(
                  height: 2,
                ),
                buildTabbar(postschanges, context),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                    child: postschanges.isloading
                        ? Center(
                            child: Loading(
                              indicator: BallBeatIndicator(),
                              size: 50.0,
                              color: Constants.PRIMARY_DARK_COLOR,
                            ),
                          )
                        : Container(
                            height: 150,
                            child: Column(
                              children: [
                                postschanges.isPosts
                                    ? InkWell(
                                        onTap: () async {
                                          ProviderUser.Provider.of<
                                                          UserProvider>(context,
                                                      listen: false)
                                                  .isLoggedIn
                                              ? Navigator.of(context).push(
                                                  CustomPageRoute(
                                                      child: CreatePostView(
                                                        postschanges:
                                                            postschanges,
                                                      ),
                                                      direction:
                                                          AxisDirection.up))
                                              : showSheet(context);
                                        },
                                        child: Container(
                                          width: width * 0.90,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: light_grey,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(start: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: TextField(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      readOnly: true,
                                                      onTap: () async {
                                                        ProviderUser
                                                                    .Provider.of<
                                                                        UserProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .isLoggedIn
                                                            ? Navigator.of(context).push(
                                                                CustomPageRoute(
                                                                    child:
                                                                        CreatePostView(
                                                                      postschanges:
                                                                          postschanges,
                                                                    ),
                                                                    direction:
                                                                        AxisDirection
                                                                            .up))
                                                            : showSheet(
                                                                context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .translate(
                                                          "be_goodness",
                                                        ),
                                                        hintStyle: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              dark_blue_green,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  width: 70,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: darkish_green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Center(
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .translate("Post"),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))
                                    : Container(),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                    child: postschanges.errormessage != null
                                        ? Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate(
                                                postschanges.errormessage ?? '',
                                              ),
                                            ),
                                          )
                                        : postschanges.isPosts
                                            ? postschanges.posts.data.isNotEmpty
                                                ? _buildPostsList()
                                                : postsListWidget.isNotEmpty
                                                    ? _buildPostsList()
                                                    : postschanges
                                                                .isPostListError ==
                                                            false
                                                        ? Container(
                                                            child: Center(
                                                              child: Loading(
                                                                indicator:
                                                                    BallBeatIndicator(),
                                                                size: 70.0,
                                                                color: Constants
                                                                    .PRIMARY_DARK_COLOR,
                                                              ),
                                                            ),
                                                          )
                                                        : Center(
                                                            child: Container(
                                                            child: Text(
                                                              "${AppLocalizations.of(context)!.translate("data_not_found")}",
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ))
                                            : postschanges.categories
                                                        .isNotEmpty &&
                                                    postschanges
                                                        .categories.isNotEmpty
                                                ? _buildIslamicPostList()
                                                // CaregoryItem(
                                                //     postschanges
                                                //             .categories[
                                                //         index],
                                                //     context),
                                                // StaggeredGridView
                                                //                 .countBuilder(
                                                //                 padding:
                                                //                     EdgeInsets.symmetric(
                                                //                         vertical: 10),
                                                //                 crossAxisCount: 4,
                                                //                 itemCount: postschanges
                                                //                     .categories.length,
                                                //                 itemBuilder: (BuildContext
                                                //                             context,
                                                //                         int index) =>
                                                //                     CaregoryItem(
                                                //                         postschanges
                                                //                                 .categories[
                                                //                             index],
                                                //                         context),
                                                //                 staggeredTileBuilder:
                                                //                     (int index) =>
                                                //                         StaggeredTile.count(
                                                //                             2,
                                                //                             index.isEven
                                                //                                 ? 2
                                                //                                 : 2.5),
                                                //                 mainAxisSpacing: 4.0,
                                                //                 crossAxisSpacing: 4.0,
                                                //               )
                                                : Center(
                                                    child: Container(
                                                    child: Text(
                                                      "${AppLocalizations.of(context)!.translate("data_not_found")}",
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )))
                              ],
                            ),
                          )),
              ],
            ),
          ));
  }

  Widget buildPostItem(Post _post) {
    return StatefulBuilder(
      builder: (context, setstate) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16.0,
                        backgroundImage: NetworkImage(
                          _post.userImage != null ? _post.userImage! : '',
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                _post.userName ?? '',
                                style: TextStyle(
                                    color: darkish_green,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _post.content ?? '',
                      maxLines: 10,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
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
                          Share.share(_post.content! +
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
                            _post.liked
                                ? postschanges.unlikePost(_post.id ?? -1)
                                : postschanges.likePost(_post.id ?? -1);

                            _post.liked = !_post.liked;
                          });
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.translate("like"),
                                style: TextStyle(
                                    color: _post.liked
                                        ? darkish_green
                                        : Colors.grey[300]),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              SvgPicture.asset(
                                'assets/icons/group_313.svg',
                                color: _post.liked
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
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 13,
                color: dark_blue_green,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  showSheet(BuildContext context) {
    return showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Material(
          elevation: 10,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Container(
            height: 200,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.translate("Login_must")}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 30),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPopUpView(
                                          close: true,
                                        ))).then((value) {});
                          },
                          fillColor: Theme.of(context).primaryColor,
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate("Login_key"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Constants.CANVAS_COLOR,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  showBottomsheetOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CreatePostView(
              postschanges: postschanges,
            ));
  }

  Widget buildTabbar(PostsNotifier postschanges, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => postschanges.changeisPosts(false),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.translate("Feeds"),
                style: TextStyle(
                    color: postschanges.isPosts ? warm_grey : darkish_green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              postschanges.isPosts
                  ? Container()
                  : Container(
                      height: 3.5,
                      width: 60,
                      decoration: BoxDecoration(
                          color: darkish_green,
                          borderRadius: BorderRadius.circular(30)),
                    )
            ],
          ),
        ),
        SizedBox(
          width: 80,
        ),
        InkWell(
          onTap: () => postschanges.changeisPosts(true),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.translate("community_share"),
                style: TextStyle(
                    color: postschanges.isPosts ? darkish_green : warm_grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              postschanges.isPosts
                  ? Container(
                      height: 3.5,
                      width: 60,
                      decoration: BoxDecoration(
                          color: darkish_green,
                          borderRadius: BorderRadius.circular(30)),
                    )
                  : Container()
            ],
          ),
        )
      ],
    );
  }

  Widget CaregoryItem(Categore category, BuildContext context) {
    return Card(
        elevation: 5,
        child: Container(
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: InkWell(
                      onTap: () {},
                      child:
                          // SizedBox(
                          //   height: 200,
                          //   child: PostVideoView(
                          //     url: 'https://examole.com/a.mp4',
                          //   ),
                          // ),
                          Container(
                              child: Image.asset(
                        "assets/images/splash_view/logo.png",
                        color: Colors.grey[100],
                        fit: BoxFit.fill,
                      ))),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      children: [
                        Text(
                          category.name ?? '',
                          style: TextStyle(
                              color: darkish_green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          category.description ?? '',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: InkWell(
                                    onTap: () {
                                      Share.share(category.name ??
                                          '' +
                                              "\n \n " +
                                              "ادعوكم للانضمام الي تطبيق الاذان ، القران ،الاذكار . مسلم بوك من هنا \n👇👇👇\n https://play.google.com/store/apps/details?id=com.muslim_book.muslim_book");
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/path_514.svg',
                                              color: Colors.grey[300],
                                              height: 15,
                                            )
                                          ],
                                        )))),
                            Expanded(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/group_313.svg',
                                          color: Colors.grey[300],
                                          height: 15,
                                        )
                                      ],
                                    ))),
                          ],
                        ),
                      ],
                    )),
              ],
            )));
  }

  _buildPostsList() {
    return SmartRefresher(
      key: _postsKey,
      onRefresh: _onPostsRefresh,
      onLoading: _onPostsLoading,
      enablePullDown: false,
      enablePullUp: true,
      controller: _postsRefreshController,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.noMore) {
            body =
                Text(AppLocalizations.of(context)!.translate("no_more_posts"));
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
        padding: EdgeInsets.all(0),
        children: postsListWidget,
      ),
    );
  }

  _buildIslamicPostList() {
    return SmartRefresher(
      onRefresh: _onIslamicPostsRefresh,
      onLoading: _onIslamicPostsLoading,
      enablePullDown: false,
      enablePullUp: true,
      controller: _islamicPostsRefreshController,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.noMore) {
            body =
                Text(AppLocalizations.of(context)!.translate("no_more_posts"));
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
      ),
    );
  }

  _buildIslamicPostItem(PostsOfIslamic islamicPost, BuildContext context) {
    return StatefulBuilder(
      builder: (context, setstate) => Card(
          elevation: 5,
          child: Container(
              height: 200,
              child: Container(
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                  )))),
    );
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

  CustomPageRoute({
    required this.child,
    this.direction = AxisDirection.up,
  }) : super(
          transitionDuration: Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
            .animate(animation),
        child: child,
      );
}
