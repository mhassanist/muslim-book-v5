import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/quran/provider/quran_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class QuranLoadingView extends StatefulWidget {
  @override
  _QuranLoadingViewState createState() => _QuranLoadingViewState();
}

class _QuranLoadingViewState extends State<QuranLoadingView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SpinKitRing(
              color: Colors.white,
              size: 50.0,
              controller: AnimationController(
                vsync: this,
                  duration: const Duration(milliseconds: 1200)),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Text(
              AppLocalizations.of(context)!.translate("Loading_quran"),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Text('${Provider.of<QuranProvider>(context).errorMessage}')
        ],
      ),
    );
  }
}
