import 'package:muslim_book/utils/Constants.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final CrossFadeState state;
  final Widget firstWidget;

  const LoadingButton({
    super.key,
    required this.state,
    required this.firstWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: firstWidget,
      secondChild: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Constants.PRIMARY_COLOR),
        ),
      ),
      crossFadeState: state,
      duration: Duration(milliseconds: 200),
    );
  }
}
