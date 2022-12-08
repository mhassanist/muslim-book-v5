import 'dart:io';

import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/quran/api_service/quran_pages_pic_api.dart';
import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart';

class QuranPagesPicBloc with ChangeNotifier{

  int totalQuranPages = 604;
  bool _isCurrentPageDownloaded = false;
  bool isFullQuranDownloaded = false;
  Uint8List _currentPage;
  APIStatus _currentPageState = APIStatus.initial;
  APIStatus _fullPagesState = APIStatus.initial;

  static QuranPagesPicBloc _quranPagesPicBloc = QuranPagesPicBloc._internal();

  factory QuranPagesPicBloc(){
    return _quranPagesPicBloc;
  }
  QuranPagesPicBloc._internal();
  APIStatus get currentPageState => _currentPageState;
  APIStatus get fullPagesState => _fullPagesState;

  bool get isCurrentPageDownloaded => _isCurrentPageDownloaded;

  void setState(APIStatus state) {
    _currentPageState = state;
    notifyListeners();
  }

  void setFullPagesState(APIStatus state) {
    _fullPagesState = state;
    notifyListeners();
  }


  Future<Uint8List> downloadQuranSinglePage(int pageNumber) async{
    setState(APIStatus.loading);

    _currentPage = await QuranPagesPicApi().downloadQuranSinglePage(pageNumber);
    setState(APIStatus.loaded);
    return _currentPage;
  }

  Future checkIfFullQuranDownloaded() async{
    setFullPagesState(APIStatus.loading);
    final directory = (await getExternalStorageDirectories()).last.path;
    Directory d = await Directory('$directory').create(recursive: true);
    int quranPagesLength = d.listSync().length;
    if(quranPagesLength == totalQuranPages){
      setFullPagesState(APIStatus.loaded);
      isFullQuranDownloaded = true;
    }else{
      QuranPagesPicApi().downloadFullQuranPages().then((value) {
        if(value == true){
          setFullPagesState(APIStatus.loaded);
          isFullQuranDownloaded = value;
        }
      });
    }
    notifyListeners();
  }


  void _setValue(bool value) {
    _isCurrentPageDownloaded = value;
    notifyListeners();
  }
}