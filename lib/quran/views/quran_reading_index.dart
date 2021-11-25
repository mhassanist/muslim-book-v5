import 'dart:convert';

import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/quran/provider/quran_pages_pic_bloc.dart';
import 'package:base_app/quran/views/quran_page_pic_view.dart';
import 'package:base_app/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuranReadingIndex extends StatefulWidget {
  const QuranReadingIndex({Key key}) : super(key: key);

  @override
  _QuranReadingIndexState createState() => _QuranReadingIndexState();
}

class _QuranReadingIndexState extends State<QuranReadingIndex> {

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: Text("قراءة القرءان بالصور"),
        centerTitle: true,
        //backGroundColor: Colors.blueAccent,
        padding: EdgeInsets.all(0),
        child: _buildQuranLayout());
  }

  Widget _buildQuranLayout() {
    return Container(
      //color: Colors.green,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                  "https://png.pngtree.com/thumb_back/fw800/background/20190718/pngtree-islamic-ramadhan-background-image_284340.jpg"))),
      child: Padding(
        padding: EdgeInsets.only(left: 15.0,right: 15.0),
        child: Column(
          children: [
            _buildLayoutTitle(),
            Expanded(
              child: Container(
                //color: Colors.white,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildQuranSoraList(),
                                //_buildVerticalDivider(),
                                _buildSoraPagesList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    //_buildVerticalDivider(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildLayoutTitle() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 3.0, color: Colors.amber),
      )),
      //color: Color(0XFF347D53),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 9,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 50,
                  ),
                  Positioned(
                      bottom: 15,right: 19,
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
                  Container(
                    //width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                      child: Text(
                        'اسم السورة',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    //width: MediaQuery.of(context).size.width / 9,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 50,
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
                  ),
                ],
              ),
            ),
          ),
          //_buildVerticalDivider(),

          //_buildVerticalDivider(),
        ],
      ),
    );
  }

  _buildQuranPartsList() {
    return Container(
      width: MediaQuery.of(context).size.width / 9,
      padding: EdgeInsets.only(bottom: 10.0),
      child: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString(
              "assets/databases/quran_database/parts_page_list.json"),
          builder: (context, snapshot) {
            var data = jsonDecode(snapshot.data.toString());
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: InkWell(
                          onTap: () {
                            QuranPagesPicBloc().setState(APIStatus.initial);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => QuranPagePicView(data[index]['page'])));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 9.1,
                            child: Center(
                              child: Text((data[index]['part']).toString(),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white,height: 3)),
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
    return Container(
      //width: MediaQuery.of(context).size.width / 2,
      child: FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString("assets/databases/quran_database/sora_list.json"),
          builder: (context, snapshot) {
            var data = jsonDecode(snapshot.data.toString());
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                  children:  [
                    for(int i = 0; i< data.length; i++)
                     InkWell(
                      onTap: () {
                        QuranPagesPicBloc().setState(APIStatus.initial);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => QuranPagePicView(data[i]['page'])));
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(data[i]['name'],
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white,height: 3)),
                        ),
                      ),
                    )
                  ]);
            }
            return Container();
          }),
    );
  }

  _buildSoraPagesList() {
    return Container(
      //width: MediaQuery.of(context).size.width / 9,
      child: FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString("assets/databases/quran_database/sora_list.json"),
          builder: (context, snapshot) {
            var data = jsonDecode(snapshot.data.toString());
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                  children: [
                    for(int i = 0; i< data.length; i++)
                     Center(
                      child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => QuranPagePicView(data[i]['page'])));
                          },
                          child: Text(data[i]['page'].toString(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white,height: 3))),
                    )
                  ]);
            }
            return Container();
          }),
    );
  }

  _buildVerticalDivider() {
    return VerticalDivider(
      color: Colors.amber,
      //Color(0XFF347D53),
      thickness: 3,
    );
  }
}
