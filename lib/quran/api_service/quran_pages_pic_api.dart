import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class QuranPagesPicApi {
  int totalQuranPages = 604;
  bool isFullQuranDownloaded = false;

  Future<Uint8List> downloadQuranSinglePage(int pageNumber) async {
    final directory = (await getExternalStorageDirectories()).last.path;
    bool found = File('$directory/$pageNumber.png').existsSync();
      if (found == false) {
        var res = await http.get(
            Uri.parse("https://post.walid-fekry.com/quran/$pageNumber.jpg"));

        Uint8List exportImage = res.bodyBytes;
        Directory d = await Directory('$directory').create(recursive: true);
        print("quran" +d.listSync().length.toString());
        final fullPath = '$directory/$pageNumber.png';
        final imgFile = File('$fullPath');
        imgFile.writeAsBytesSync(exportImage);
        return exportImage;
      }else{
        Uint8List exportImage ;
        final fullPath = '$directory/$pageNumber.png';
        final imgFile = File('$fullPath');
        exportImage = await imgFile.readAsBytes();
        return exportImage;
      }
  }

  Future<bool> downloadFullQuranPages() async {
    final directory = (await getExternalStorageDirectories()).last.path;
    for (int i = 1; i < totalQuranPages + 1; i++) {
      bool found = File('$directory/$i.png').existsSync();
      if (found == false) {
        var res = await http.get(
            Uri.parse("https://post.walid-fekry.com/quran/$i.jpg"));

        Uint8List exportImage = res.bodyBytes;
        Directory d = await Directory('$directory').create(recursive: true);
        print("quran" +d.listSync().length.toString());
        final fullPath = '$directory/$i.png';
        final imgFile = File('$fullPath');
        imgFile.writeAsBytesSync(exportImage);
      }
    }
    return true;
  }
}
