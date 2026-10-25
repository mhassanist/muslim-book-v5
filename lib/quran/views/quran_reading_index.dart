import 'dart:convert';

import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/quran/provider/quran_pages_pic_bloc.dart';
import 'package:muslim_book/quran/views/quran_page_pic_view.dart';
import 'package:muslim_book/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranReadingIndex extends StatefulWidget {
  const QuranReadingIndex({super.key});

  @override
  _QuranReadingIndexState createState() => _QuranReadingIndexState();
}

class _QuranReadingIndexState extends State<QuranReadingIndex> {
  final Future<List> _parts = _loadJson("parts_page_list.json");
  final Future<List> _soras = _loadJson("sora_list.json");

  static Future<List> _loadJson(String name) async => jsonDecode(
      await rootBundle.loadString("assets/databases/quran_database/$name"));

  Route _createRoute(pgNumber) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          QuranPagePicView(pgNumber),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Resume the last read page once, when the index is first opened.
    // Doing this in build() pushed a new page on every rebuild, so Back
    // could never get out of the reader.
    Future.delayed(Duration(seconds: 1), () async {
      final lastPage =
          (await SharedPreferences.getInstance()).getInt("LAST_READ_PAGE");
      if (lastPage == null || !mounted) return;
      QuranPagesPicBloc().setState(APIStatus.initial);
      Navigator.push(context, _createRoute(lastPage));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: Text("قراءة القرءان بالصور"),
        centerTitle: true,
        backgroundImage: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/islamic_background.jpg")),
        padding: EdgeInsets.all(0),
        child: _buildQuranLayout());
  }

  Widget _buildQuranLayout() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: [
          _buildLayoutTitle(),
          Expanded(
            child: Row(
              children: [
                _buildQuranPartsList(),
                _buildVerticalDivider(),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: _buildQuranSoraList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildLayoutTitle() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 3.0, color: Colors.white),
      )),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 9,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.square_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                  Positioned(
                      bottom: 15,
                      child: Text(
                        'ج',
                        style: TextStyle(fontSize: 17),
                      ))
                ],
              ),
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Text(
                      'اسم السورة',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.square_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                        Positioned(
                            bottom: 15,
                            child: Text(
                              'ص',
                              style: TextStyle(fontSize: 16),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildQuranPartsList() {
    return Container(
      width: MediaQuery.of(context).size.width / 9,
      padding: EdgeInsets.only(bottom: 10.0),
      child: FutureBuilder<List>(
          future: _parts,
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data != null) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: InkWell(
                          onTap: () {
                            QuranPagesPicBloc().setState(APIStatus.initial);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        QuranPagePicView(data[index]['page'])));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 9.1,
                            child: Center(
                              child: Text((data[index]['part']).toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      height: 3)),
                            ),
                          )),
                    );
                  });
            }
            return Container();
          }),
    );
  }

  _buildQuranSoraList() {
    return FutureBuilder<List>(
        future: _soras,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data != null) {
            return Column(children: [
              for (int i = 0; i < data.length; i++)
                InkWell(
                    onTap: () {
                      QuranPagesPicBloc().setState(APIStatus.initial);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QuranPagePicView(data[i]['page'])));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(data[i]['name'],
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    height: 3)),
                            Text(data[i]['page'].toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    height: 3)),
                          ],
                        ),
                      ),
                    ))
            ]);
          }
          return Container();
        });
  }

  _buildVerticalDivider() {
    return VerticalDivider(
      color: Colors.white,
      thickness: 3,
    );
  }
}
