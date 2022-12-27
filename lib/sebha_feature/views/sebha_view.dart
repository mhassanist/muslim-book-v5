import 'dart:io';

import 'package:muslim_book/sebha_feature/offline_sebha/views/offline_sebha_view.dart';
import 'package:muslim_book/sebha_feature/online_sebha/views/online_sebha_view.dart';
import 'package:flutter/material.dart';

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
            snapshot.data!.isNotEmpty &&
            snapshot.data![0].rawAddress.isNotEmpty)
          return OnlineSebhaView();
        else
          return OfflineSebhaView();
      },
    );
  }

  
}
