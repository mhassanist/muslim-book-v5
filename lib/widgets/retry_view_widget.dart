import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/providers/view_state_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/widgets/general_wigets/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../utils/sizing_info_extension.dart';

class RetryViewWidget extends StatefulWidget {
  final ViewStateProvider provider;
  final Function function;
  final String text;

  const RetryViewWidget({Key key, this.provider, this.function, this.text})
      : super(key: key);

  @override
  _RetryViewWidgetState createState() => _RetryViewWidgetState();
}

class _RetryViewWidgetState extends State<RetryViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: sizeConfig.blockSizeHorizontal * 70,
                child: Image.asset(
                    "assets/images/azan_view/model_not_present_error_image.png"),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Text(
                AppLocalizations.of(context).translate("cannot_reach"),
                style: TextStyle(color: Colors.grey),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                AppLocalizations.of(context).translate(widget.text),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: sizeConfig.blockSizeHorizontal * 5),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              LoadingButton(
                firstWidget: RaisedButton(
                  onPressed: widget.function,
                  child: Text(
                    AppLocalizations.of(context).translate("retry"),
                    style: TextStyle(color: Constants.CANVAS_COLOR),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                state: widget.provider.viewState == ViewState.Loading
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    if (widget.provider.mounted) {
      Future.delayed(Duration(milliseconds: 300), widget.function);
    }
    super.dispose();
  }
}

Widget modelNotPresentWidget(
  SizingInformation sizeConfig,
  BuildContext context,
  ViewStateProvider provider,
  Function function,
  String text,
) {
  return Scaffold(
    body: Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: sizeConfig.blockSizeHorizontal * 70,
            child: Image.asset(
                "assets/images/azan_view/model_not_present_error_image.png"),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Text(
            AppLocalizations.of(context).translate("cannot_reach"),
            style: TextStyle(color: Colors.grey),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Text(
            AppLocalizations.of(context).translate(text),
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: sizeConfig.blockSizeHorizontal * 5),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          LoadingButton(
            firstWidget: RaisedButton(
              onPressed: function,
              child: Text(
                AppLocalizations.of(context).translate("retry"),
                style: TextStyle(color: Constants.CANVAS_COLOR),
              ),
              color: Theme.of(context).primaryColor,
            ),
            state: provider.viewState == ViewState.Loading
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          )
        ],
      ),
    ),
  );
}
