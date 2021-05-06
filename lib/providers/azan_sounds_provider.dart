import 'dart:convert';
import 'dart:io';

import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/local_storage/local_storage_manager.dart';
import 'package:base_app/models/azan_sound.dart';
import 'package:base_app/network_utils/azansounds_service.dart';
import 'package:base_app/providers/view_state_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

enum DataLoadingState { notLoaded, localAvailable, canBeLoadedFromWeb }
enum FileDownloadState { downloaded, initial, downloading }

class AzanSoundsProvider extends ViewStateProvider {
  List<AzanSound> azanSounds = List();
  int _pickedAzanShiekhIndex;

  DataLoadingState loadedState = DataLoadingState.notLoaded;
  List<FileDownloadState> filesStates = List();
  int get pickedAzanShiekhIndex => _pickedAzanShiekhIndex;
  static var httpClient = new HttpClient();


  set pickedAzanShiekhIndex(int value) {
    _pickedAzanShiekhIndex = value;
    notifyListeners();
  }

 loadAzanSounds() async {
    setViewState(ViewState.Loading);
    azanSounds = await LocalStorageManager().loadAzanSoundsList();
    if (azanSounds!= null) {
      for(AzanSound sound in azanSounds){
        filesStates.add(FileDownloadState.initial);
      }
      loadedState = DataLoadingState.localAvailable;
      setViewState(ViewState.Idle);
      print("from local storage");
    } else {
      azanSounds = await AzanSoundsAPI().requestAzanSounds();
      for(AzanSound sound in azanSounds){
        filesStates.add(FileDownloadState.initial);
      }
      //save azan sounds locally
      await LocalStorageManager().saveAzanSoundsList(azanSounds);
      loadedState = DataLoadingState.localAvailable;

      setViewState(ViewState.Idle);
      print("from web");
    }
  } //load azan sounds

  void checkForLocal(String azanId) async{
    var azanList = await LocalStorageManager().loadAzanSoundsList();
    String savedAzanSheikh = locator<Prefs>().getAzanShiekhJSON(azanId);
    if ( azanList != null) {
      loadedState = DataLoadingState.localAvailable;
      azanSounds = azanList;

      for (AzanSound sound in azanSounds) {
        if(sound.localPath!=null)
          filesStates.add(FileDownloadState.downloaded);
        else
          filesStates.add(FileDownloadState.initial);

        if(savedAzanSheikh!=null){
          Map<String,dynamic> localSavedSheikh = jsonDecode(savedAzanSheikh);

          if(localSavedSheikh != null && localSavedSheikh['id'].toString() == sound.id.toString()){
            _pickedAzanShiekhIndex = azanSounds.indexOf(sound);
          }
        }


      }
      notifyListeners();
    } else {
      loadedState = DataLoadingState.canBeLoadedFromWeb;
      notifyListeners();
    }
  }

  Future<File> downloadFile(int soundIndex) async {
    filesStates[soundIndex] = FileDownloadState.downloading;
    notifyListeners();
    AzanSound sound = azanSounds[soundIndex];
    sound.fileUrl = sound.fileUrl
        .replaceFirst("http://", "https://");

    var request = await httpClient.getUrl(Uri.parse(sound.fileUrl));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    String dir = (await getApplicationDocumentsDirectory()).path;
    var filename="azan_sound${sound.id}.mp3";

    File file = new File(join(dir,filename));
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

  Future<void> saveSelectedShiekhJson(Map<String, dynamic> json , String azanId , BuildContext context) async {
    await locator<Prefs>().setAzanShiekhJSON(json ,azanId);
    print("saved local db azan sound json");
    Navigator.pop(context, _pickedAzanShiekhIndex);
  }



}
