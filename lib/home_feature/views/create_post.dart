import 'package:base_app/home_feature/const/color.dart';
import 'package:base_app/home_feature/controllers/providers_get_post.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';

class CreatePostView extends StatefulWidget {
  final PostsNotifier postschanges;

  const CreatePostView({Key key, this.postschanges}) : super(key: key);

  @override
  _CreatePostViewState createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  String content = "";
  bool loadingHere = false;

  @override
  Widget build(BuildContext context) {
    return

      Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0),
        ),
      ),
      child: Stack(children: <Widget>[
      Positioned.fill(child:
      Scaffold(
        body:

        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          AppLocalizations.of(context).translate("be_goodness"),
                      hintStyle:
                          TextStyle(fontSize: 13, color: Colors.black38)),
                  maxLines: 10,
                  onChanged: (val) {
                    content = val;
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());

                setState(() {
                  loadingHere = true;
                });
                this.widget.postschanges.createPost(content).then((value) {
                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      loadingHere = false;
                    });
                    if (this.widget.postschanges != null) {
                      final snackBar = SnackBar(
                          content: Text(this.widget.postschanges.message));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    Navigator.of(context).pop();
                   });

                });
              },
              child: Container(
                width: 200,
                height: 45,
                decoration: BoxDecoration(
                    color: darkish_green,
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).translate("Post"),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              // margin: EdgeInsets.only(top: 100),
              child: Visibility(
                visible: loadingHere,
                child: Loading(
                  indicator: BallBeatIndicator(),
                  size: 70.0,
                  color: Constants.PRIMARY_DARK_COLOR,
                ),
              ),
            ),
          ),
        )


      ]),
    );
  }
}
