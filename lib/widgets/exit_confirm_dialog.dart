import 'package:flutter/material.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/text_styles.dart';
import 'package:muslim_book/utils/Constants.dart';

/// "Leave this section?" confirmation. Deliberately ad-free: AdMob discourages
/// ads next to the buttons of exit confirmation screens (accidental clicks).
class ExitConfirmDialog extends StatefulWidget {
  final String title;
  final String buttomTitle;
  final Function? exit;
  final Widget? mainView;

  const ExitConfirmDialog({
    super.key,
    this.title = '',
    this.buttomTitle = '',
    this.exit,
    this.mainView,
  });

  @override
  State<ExitConfirmDialog> createState() => _ExitConfirmDialogState();
}

class _ExitConfirmDialogState extends State<ExitConfirmDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)!.translate("Exit") +
                  widget.title,
              style: almaraiTextStyle,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Constants.PRIMARY_DARK_COLOR,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(5, 5),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.buttomTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if ((widget.title ==
                              AppLocalizations.of(context)!
                                  .translate('competition')) ||
                          (widget.title ==
                              AppLocalizations.of(context)!
                                  .translate('competitions'))) {
                        widget.exit?.call();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.5,
                          color: Constants.PRIMARY_DARK_COLOR,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(5, 5),
                            blurRadius: 7,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.translate("Exit_from"),
                          style: const TextStyle(
                            color: Constants.PRIMARY_DARK_COLOR,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
