import 'dart:convert';
import 'dart:io';

import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/local_storage/local_storage_manager.dart';
import 'package:muslim_book/models/azan_sound.dart';
import 'package:muslim_book/network_utils/azansounds_service.dart';
import 'package:muslim_book/providers/azan_sounds_provider.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AzanFairSoundsProvider extends ViewStateProvider {
  late List<AzanSound> azanSounds;
  late int _pickedAzanShiekhIndex;

  DataLoadingState loadedState = DataLoadingState.notLoaded;
  late List<FileDownloadState> filesStates;

  int get pickedAzanShiekhIndex => _pickedAzanShiekhIndex;

  set pickedAzanShiekhIndex(int value) {
    _pickedAzanShiekhIndex = value;
    notifyListeners();
  }

  static var httpClient = new HttpClient();

  Future<File> downloadFile(int soundIndex) async {
    filesStates[soundIndex] = FileDownloadState.downloading;
    notifyListeners();
    AzanSound sound = azanSounds[soundIndex];
    sound.fileUrl = sound.fileUrl.replaceFirst("http://", "https://");

    var request = await httpClient.getUrl(Uri.parse(sound.fileUrl));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    String dir = (await getApplicationDocumentsDirectory()).path;
    var filename = "azan_sound${sound.id}.mp3";

    File file = new File(join(dir, filename));
    await file.writeAsBytes(bytes);
    sound.localPath = file.path;
    filesStates[soundIndex] = FileDownloadState.downloaded;
    LocalStorageManager().updateAzanSoundsList(sound);
    notifyListeners();
    return file;
  }

  AzanSound getAzanSound(index) {
    return azanSounds[index];
  }

  /*Future<void> saveDownloadedAzanShiekhJson(Map<String, dynamic> json, BuildContext context) async {
    await locator<Prefs>().setAzanShiekhJSON(json);
    print("saved local db azan sound json");
    Navigator.pop(context, _pickedAzanShiekhIndex);
  }*/

  Future<void> saveDownloadedFajrShiekhJson(Map<String, dynamic> json,
      BuildContext context) async {
    await locator<Prefs>().setFajrAzanShiekhJSON(json);
    print("saved local db azan sound json");
    Navigator.pop(context, _pickedAzanShiekhIndex);
  }

  loadAzanSounds() async {
    setViewState(ViewState.Loading);
    final result = await LocalStorageManager().loadFajrAzanSoundsList();
    if (result != null) {
      azanSounds = result;
      for (AzanSound sound in azanSounds) {
        filesStates.add(FileDownloadState.initial);
      }
      loadedState = DataLoadingState.localAvailable;
      setViewState(ViewState.Idle);
      print("from local storage");
    } else {
      var azanSoundsResult = await AzanSoundsAPI().requestAzanSounds();
      for (AzanSound sound in azanSoundsResult) {
        filesStates.add(FileDownloadState.initial);
      }
      //save azan sounds locally
      await LocalStorageManager().saveAzanSoundsList(azanSoundsResult);
      azanSounds = (await LocalStorageManager().loadFajrAzanSoundsList())!;
      loadedState = DataLoadingState.localAvailable;

      setViewState(ViewState.Idle);
      print("from web");
    }
  } //load azan sounds

  void checkForLocal() async {
    var azanList = await LocalStorageManager().loadFajrAzanSoundsList();
    var fairAzanSheikh = await locator<Prefs>().getFajrAzanShiekhJSON();

    if (azanList != null && fairAzanSheikh !=null) {
      loadedState = DataLoadingState.localAvailable;
      azanSounds = azanList;
      Map<String,dynamic>? localSavedSheikh;

      final result = locator<Prefs>().getFajrAzanShiekhJSON();
      if(result != null){
        localSavedSheikh = jsonDecode(result);
      }
      for (AzanSound sound in azanSounds) {
        if(sound.localPath != null)
          filesStates.add(FileDownloadState.downloaded);
        else
          filesStates.add(FileDownloadState.initial);
        if(localSavedSheikh != null && localSavedSheikh['id'].toString() == sound.id.toString()){
          _pickedAzanShiekhIndex = azanSounds.indexOf(sound);
        }

      }
      notifyListeners();
    } else {
      loadedState = DataLoadingState.canBeLoadedFromWeb;
      notifyListeners();
    }
  }
}
