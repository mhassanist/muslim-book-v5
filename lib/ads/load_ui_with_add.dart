import 'package:base_app/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';

class LoadUiWithAdd extends StatefulWidget {
  final Widget mainView;

  const LoadUiWithAdd({
    super.key,
    required this.mainView,
  });

  @override
  _LoadUiWithAddState createState() => _LoadUiWithAddState();
}

class _LoadUiWithAddState extends State<LoadUiWithAdd> {
  bool loadingAddMobe = true ;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds:   2), () {
       setState(() {
        loadingAddMobe = false;
      });
     });
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
