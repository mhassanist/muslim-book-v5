import 'package:muslim_book/ads/admob_banner.dart';
import 'package:muslim_book/ads/load_ui_with_add.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/home_feature/domian/model/islamic_posts_model.dart';
import 'package:muslim_book/home_feature/widgets/video_view.dart';
import 'package:muslim_book/islamic_feature/bloc/islamic_post_details_bloc.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/models/push_notification_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IslamicPostDetailsFromNotification extends StatefulWidget {
  final NotificationData data;
  const IslamicPostDetailsFromNotification(this.data, {super.key});

  @override
  _IslamicPostDetailsFromNotificationState createState() =>
      _IslamicPostDetailsFromNotificationState();
}

class _IslamicPostDetailsFromNotificationState
    extends State<IslamicPostDetailsFromNotification> {
  @override
  void initState() {
    IslamicPostDetailsBloc().getIslamicPostDetails(widget.data.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IslamicPostDetailsBloc _islamicPostDetails =
        Provider.of<IslamicPostDetailsBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.catName),
        centerTitle: true,
        backgroundColor: Color(0XFF347D53),
      ),
      body: _buildIslamicPostDetailsUIOrError(_islamicPostDetails),
    );
  }

  _buildIslamicPostDetailsUIOrError(IslamicPostDetailsBloc islamicPostDetails) {
    if (islamicPostDetails.state == APIStatus.initial ||
        islamicPostDetails.state == APIStatus.loading) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (islamicPostDetails.state == APIStatus.error) {
      return Container(
        child: Center(
          child: Text('error'),
        ),
      );
    }
    if (islamicPostDetails.state == APIStatus.loaded) {
      return _buildIslamicPostDetailsUI(islamicPostDetails.postsOfIslamic);
    }
  }

  _buildIslamicPostDetailsUI(PostsOfIslamic postsOfIslamic) {
    return LoadUiWithAd(
      mainView: ListView(
        padding: EdgeInsets.all(10),
        children: [
          _buildPostTitleUi(postsOfIslamic),
          _buildSizedBox(),
          _buildPostDescriptionUi(postsOfIslamic),
          _buildSizedBox(),
          _buildAdSection(),
          _buildSizedBox(),
          _buildPostContentUi(postsOfIslamic),
          _buildSizedBox(),
          _buildPostVideoUi(postsOfIslamic),
        ],
      ),
    );
  }

  _buildPostTitleUi(PostsOfIslamic postsOfIslamic) {
    return Text(
      postsOfIslamic.name,
      style: TextStyle(fontSize: 18),
    );
  }

  _buildPostDescriptionUi(PostsOfIslamic postsOfIslamic) {
    return Text(postsOfIslamic.description, style: TextStyle(fontSize: 15));
  }

  _buildPostContentUi(PostsOfIslamic postsOfIslamic) {
    return Text(postsOfIslamic.content, style: TextStyle(fontSize: 15));
  }

  _buildPostVideoUi(PostsOfIslamic postsOfIslamic) {
    return postsOfIslamic.media.isNotEmpty
        ? SizedBox(
            height: 200,
            child: PostVideoView(
              url: postsOfIslamic.media[0].url,
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
    return AdmobBanner(bannerName: BannerName.BOSLA);
  }
}
