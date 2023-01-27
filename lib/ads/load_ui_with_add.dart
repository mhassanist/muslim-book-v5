// import 'package:muslim_book/main.dart';
// import 'package:muslim_book/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/loading_pkg/indicator/ball_beat_indicator.dart';
import 'package:muslim_book/widgets/loading_pkg/loading.dart';

class LoadUiWithAd extends StatefulWidget {
  final Widget mainView;

  const LoadUiWithAd({
    super.key,
    required this.mainView,
  });

  @override
  _LoadUiWithAdState createState() => _LoadUiWithAdState();
}

class _LoadUiWithAdState extends State<LoadUiWithAd> {
  bool loadingAddMobe = false;

  @override
  void initState() {
    super.initState();
    // Hamza
    // Future.delayed(Duration(seconds:   2), () {
    //    setState(() {
    //     loadingAddMobe = false;
    //   });
    //  });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(child: this.widget.mainView),
        ),
        Positioned.fill(
          child: Visibility(
            visible: loadingAddMobe,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Loading(
                  indicator: BallBeatIndicator(),
                  size: 70.0,
                  color: Constants.PRIMARY_DARK_COLOR,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
