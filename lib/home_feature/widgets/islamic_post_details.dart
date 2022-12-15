import 'package:muslim_book/ads/admob_rectangle.dart';
import 'package:muslim_book/ads/load_ui_with_add.dart';
import 'package:muslim_book/home_feature/domian/model/islamic_posts_model.dart';
import 'package:muslim_book/home_feature/widgets/video_view.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:share/share.dart';

class IslamicPostDetails extends StatefulWidget {
  final PostsOfIslamic islamicPost;

  const IslamicPostDetails(this.islamicPost, {Key key}) : super(key: key);

  @override
  _IslamicPostDetailsState createState() => _IslamicPostDetailsState();
}

class _IslamicPostDetailsState extends State<IslamicPostDetails> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, SizingInformation sizeConfig) {
        return AppScaffold(
          padding: EdgeInsets.symmetric(vertical: 20),
          transparentBackground: false,
          title: Text(AppLocalizations.of(context)!.translate("Feeds")),
          centerTitle: true,
          child: LoadUiWithAdd(
            mainView: ListView(
              padding: EdgeInsets.all(10),
              children: [
                _buildPostTitleUi(),
                _buildAdSection(),
                _buildSizedBox(),
                _buildPostContentUi(),
                _buildSizedBox(),
                _buildPostVideoUi(),
                _buildAdSection(),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Share.share(widget.islamicPost.name +
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
                              AppLocalizations.of(context)
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
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _buildPostTitleUi() {
    return Text(
      widget.islamicPost.name,
      style: TextStyle(fontSize: 16, height: 2, fontWeight: FontWeight.w600),
    );
  }

  _buildPostDescriptionUi() {
    return Text(widget.islamicPost.description, style: TextStyle(fontSize: 15));
  }

  _buildPostImageUi() {
    return (widget.islamicPost.featured == null ||
            widget.islamicPost.featured.endsWith('mp4'))
        ? Image.asset(
            "assets/images/splash_view/logo.png",
            color: Colors.grey[100],
            fit: BoxFit.contain,
            height: 250,
          )
        : Image.network(widget.islamicPost.featured, fit: BoxFit.fill);
  }

  _buildPostContentUi() {
    return Text(widget.islamicPost.content,
        style: TextStyle(fontSize: 16, height: 2,));
  }

  _buildPostVideoUi() {
    return widget.islamicPost.media.isNotEmpty
        ? SizedBox(
            height: 200,
            child: PostVideoView(
              url: widget.islamicPost.media[0].url,
            ),
          )
        : Container();
  }

  _buildSizedBox() {
    return SizedBox(
      height: 10,
    );
  }

  _buildAdSection() {
    return Container(height: 300, child: AdMobRectangle(BannerName.BOSLA));
  }
}
