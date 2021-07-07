import 'package:base_app/home_feature/const/color.dart';
import 'package:base_app/home_feature/controllers/providers_get_post.dart';
import 'package:base_app/home_feature/domian/model/post_model.dart';
import 'package:base_app/home_feature/domian/repository_home.dart';
import 'package:base_app/home_feature/widgets/azan_home_widget.dart';
import 'package:base_app/home_feature/widgets/categories_horisontal_home_widget.dart';
import 'package:base_app/language_constants.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/main.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';

class HomePage extends ConsumerWidget {
  HomeRepository homeRepository = HomeRepository();
  String content = "";
  var postschanges;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    double width = MediaQuery.of(context).size.width;
    postschanges = watch(getPosts);
    if (postschanges.posts.isEmpty || postschanges.isloading == true) {
      postschanges.getPosts();
    }
    return
       //MyApp.loading
        // ? Container(
        //     child: Center(
        //       child: Loading(
        //         indicator: BallBeatIndicator(),
        //         size: 70.0,
        //         color:
        //         Constants.PRIMARY_DARK_COLOR,
        //       ),
        //
        //     ),
        //   )
        // :
    SafeArea(
            child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AzanHomeWidget(),
                buildTitle(AppLocalizations.of(context).translate( "MainSections")),
                Container(
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    child: CategoriesHorizontalHomeWidget()),
                buildTitle("الاخبار"),
                Container(
                  width: width * 0.90,
                  height: 40,
                  decoration: BoxDecoration(
                      color: light_grey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 70,
                          height: 40,
                          decoration: BoxDecoration(
                              color: darkish_green,
                              borderRadius: BorderRadius.circular(28)),
                          child: Center(
                            child: Text(
                              "نشر",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextField(
                            textDirection: TextDirection.rtl,
                            readOnly: true,
                            onTap: () => showBottomsheetOptions(context),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    " كن داعيا للخير و ادعو بحديث او اية او دعاء....  ",
                                hintStyle: TextStyle(
                                    fontSize: 13, color: light_grey_Two)),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: postschanges.isloading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: postschanges.posts.length,
                          itemBuilder: (ctx, index) =>
                              buildPostItem(postschanges.posts[index]),
                        ),
                ),
              ],
            ),
          ));
  }

  Widget buildPostItem(Post _post) {
    return StatefulBuilder(
      builder: (context, setstate) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
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
                            _post.userImage != null ? _post.userImage : ""),
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
                                _post.userName,
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
                  child: Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _post.content,
                        style: TextStyle(fontSize: 16),
                      ),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "مشاركة",
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
                                ? postschanges.unlikePost(_post.id)
                                : postschanges.likePost(_post.id);
                            _post.liked = !_post.liked;
                          });
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "اعجبني",
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

  showBottomsheetOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10.0),
            topRight: const Radius.circular(10.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          ".... كن داعيا للخير و ادعو بحديث او اية او دعاء  ",
                      hintStyle:
                          TextStyle(fontSize: 13, color: Colors.black38)),
                  maxLines: 20,
                  onChanged: (val) {
                    content = val;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      postschanges.createPost(content);

                      final snackBar =
                          SnackBar(content: Text(postschanges.message));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 200,
                      height: 45,
                      decoration: BoxDecoration(
                          color: darkish_green,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          "نشر",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
