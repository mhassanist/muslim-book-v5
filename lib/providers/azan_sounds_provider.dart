import 'dart:convert';
import 'dart:io';

import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/local_storage/local_storage_manager.dart';
import 'package:muslim_book/models/azan_sound.dart';
import 'package:muslim_book/network_utils/azansounds_service.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

enum DataLoadingState { notLoaded, localAvailable, canBeLoadedFromWeb }

enum FileDownloadState { downloaded, initial, downloading }

class AzanSoundsProvider extends ViewStateProvider {
  List<AzanSound> azanSounds = [];
  int _pickedAzanShiekhIndex = 0;

  DataLoadingState loadedState = DataLoadingState.notLoaded;
  List<FileDownloadState> filesStates = [];
  int get pickedAzanShiekhIndex => _pickedAzanShiekhIndex;
  static var httpClient = new HttpClient();

  set pickedAzanShiekhIndex(int value) {
    _pickedAzanShiekhIndex = value;
    notifyListeners();
  }

  loadAzanSounds() async {
    setViewState(ViewState.Loading);
    azanSounds = await LocalStorageManager().loadAzanSoundsList() ?? [];
    if (azanSounds.isNotEmpty) {
      for (AzanSound sound in azanSounds) {
        filesStates.add(FileDownloadState.initial);
      }
      loadedState = DataLoadingState.localAvailable;
      setViewState(ViewState.Idle);
      print("from local storage");
    } else {
      azanSounds = await AzanSoundsAPI().requestAzanSounds();
      for (AzanSound sound in azanSounds) {
        filesStates.add(FileDownloadState.initial);
      }
      //save azan sounds locally
      await LocalStorageManager().saveAzanSoundsList(azanSounds);
      loadedState = DataLoadingState.localAvailable;

      setViewState(ViewState.Idle);
      print("from web");
    }
  } //load azan sounds

  void checkForLocal(String azanId) async {
    var azanList = await LocalStorageManager().loadAzanSoundsList();
    String savedAzanSheikh = locator<Prefs>().getAzanShiekhJSON(azanId);
    if (azanList != null && filesStates.isNotEmpty) {
      loadedState = DataLoadingState.localAvailable;
      azanSounds = azanList;

      for (AzanSound sound in azanSounds) {
        if (sound.localPath.isNotEmpty)
          filesStates.add(FileDownloadState.downloaded);
        else
          filesStates.add(FileDownloadState.initial);

        if (savedAzanSheikh.isNotEmpty) {
          Map<String, dynamic>? localSavedSheikh = jsonDecode(savedAzanSheikh);

          if (localSavedSheikh != null &&
              localSavedSheikh['id'].toString() == sound.id.toString()) {
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

  AzanSound? getAzanSound(int index) {
    if (azanSounds.length > index - 1) {
      return azanSounds[index];
    } else {
      return null;
    }
  }

  Future<void> saveDownloadedShiekhJson(Map<String, dynamic> json,
      String azanId, BuildContext context, bool saveToAll) async {
    if (saveToAll) {
      //save the same sheikh to all prayer times
      for (int i = 2; i <= 6; i++) {
        await locator<Prefs>().setAzanShiekhJSON(json, i.toString());
      }
    } else {
      await locator<Prefs>().setAzanShiekhJSON(json, azanId);
    }
    Navigator.pop(context, _pickedAzanShiekhIndex);
  }
}
