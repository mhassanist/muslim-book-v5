import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_book/ads/admob_banner.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/utils/Constants.dart';

class AdWidgetEdit extends StatefulWidget {
  final String title;
  final String buttomTitle;
  final Function? exit;
  final bannerName;
  final Widget? mainView;

  const AdWidgetEdit({
    super.key,
    this.title = '',
    this.bannerName,
    this.buttomTitle = '',
    this.exit,
    this.mainView,
  });

  @override
  _AdWidgetEditState createState() => _AdWidgetEditState();
}

class _AdWidgetEditState extends State<AdWidgetEdit> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (MediaQuery.of(context).size.height / 1.8),
      width: (MediaQuery.of(context).size.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)!.translate("Exit") +
                  widget.title,
              style: GoogleFonts.almarai(
                color: Constants.PRIMARY_DARK_COLOR,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AdmobBanner(
            bannerName: widget.bannerName,
            width: MediaQuery.of(context).size.width * 0.72,
            height: 250,
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
