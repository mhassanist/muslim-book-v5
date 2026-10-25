import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/general_wigets/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../utils/sizing_info_extension.dart';

class RetryViewWidget extends StatefulWidget {
  final ViewStateProvider provider;
  final VoidCallback? function;
  final String text;

  const RetryViewWidget({
    super.key,
    required this.provider,
    this.function,
    required this.text,
  });

  @override
  State<RetryViewWidget> createState() => _RetryViewWidgetState();
}

class _RetryViewWidgetState extends State<RetryViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: sizeConfig.blockSizeHorizontal * 70,
                child: Image.asset(
                  "assets/images/azan_view/model_not_present_error_image.png",
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(
                AppLocalizations.of(context)!.translate("cannot_reach"),
                style: const TextStyle(color: Colors.grey),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                AppLocalizations.of(context)!.translate(widget.text),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: sizeConfig.blockSizeHorizontal * 5),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              LoadingButton(
                firstWidget: ElevatedButton(
                  onPressed: () => widget.function?.call(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate("retry"),
                    style: const TextStyle(color: Constants.CANVAS_COLOR),
                  ),
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
      Future.delayed(
        const Duration(milliseconds: 300),
        () => widget.function?.call(),
      );
    }
    super.dispose();
  }
}

Widget modelNotPresentWidget(
  SizingInformation sizeConfig,
  BuildContext context,
  ViewStateProvider provider,
  Function? function,
  String text,
) {
  return Scaffold(
    body: SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: sizeConfig.blockSizeHorizontal * 70,
            child: Image.asset(
                "assets/images/azan_view/model_not_present_error_image.png"),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Text(
            AppLocalizations.of(context)!.translate("cannot_reach"),
            style: const TextStyle(color: Colors.grey),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Text(
            AppLocalizations.of(context)!.translate(text),
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: sizeConfig.blockSizeHorizontal * 5),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          LoadingButton(
            firstWidget: ElevatedButton(
              onPressed: () => function?.call(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                AppLocalizations.of(context)!.translate("retry"),
                style: const TextStyle(color: Constants.CANVAS_COLOR),
              ),
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
