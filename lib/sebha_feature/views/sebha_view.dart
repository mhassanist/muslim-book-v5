import 'dart:io';

import 'package:base_app/sebha_feature/offline_sebha/views/offline_sebha_view.dart';
import 'package:base_app/sebha_feature/online_sebha/views/online_sebha_view.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:base_app/widgets/share_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SebhaView extends StatefulWidget {
  @override
  _SebhaViewState createState() => _SebhaViewState();
}

class _SebhaViewState extends State<SebhaView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InternetAddress>>(
      future: InternetAddress.lookup('google.com'),
      builder: (c, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        if (snapshot.data != null &&
            snapshot.data.isNotEmpty &&
            snapshot.data[0].rawAddress.isNotEmpty)
          return OnlineSebhaView();
        else
          return OfflineSebhaView();
      },
    );
  }

  
}
