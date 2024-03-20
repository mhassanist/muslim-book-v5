import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class QuranPagesPicApi {
  int totalQuranPages = 604;
  bool isFullQuranDownloaded = false;

  Future<Uint8List> downloadQuranSinglePage(int pageNumber) async {
    final directory = (await getExternalStorageDirectories())!.last.path;
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
    /// TODO: Need to fix crashes
    final directory = (await getExternalStorageDirectories())!.last.path;
    for (int i = 1; i < totalQuranPages + 1; i++) {
      bool found = File('$directory/$i.png').existsSync();
      if (found == false) {
        /// TODO: Need to fix crashes
        /// https://console.firebase.google.com/project/muslim-book-ab937/crashlytics/app/android:com.muslim_book.muslim_book/issues/820a385371f51a7d12b96e28eefde272?time=last-seven-days&types=crash&versions=4.5.9%20(86);4.5.9%20(85)&sessionEventKey=65FA6BCF016D00157A97ECE83220EF99_1926749907323297811
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
