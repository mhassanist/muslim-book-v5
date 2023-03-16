import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/local_storage/local_storage_manager.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/ramadan/api_service/ramadan_api_service.dart';
import 'package:muslim_book/ramadan/api_service/ramadan_cannon_apis.dart';
import 'package:muslim_book/ramadan/api_service/ramadan_mashraat_apis.dart';
import 'package:muslim_book/ramadan/models/ramadan_cannon_model.dart';
import 'package:muslim_book/ramadan/models/ramadan_data.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

enum DataLoadingState { notLoaded, localAvailable, canBeLoadedFromLocal }

enum FileDownloadState { downloaded, initial, downloading }

class Repetitions {
  final int id;

  final String name;

  Repetitions(this.id, this.name);
}

class RamadanProvider extends ViewStateProvider {
  static var httpClient = new HttpClient();
  List<Repetitions> _repetitions = [
    Repetitions(0, "لا نهائي"),
    Repetitions(1, "مره واحده"),
    Repetitions(2, "مرتان")
  ];
  List<RamadanData> _ramadanAllData = [];
  List<RamadanData> _ramadanDataShow = [];
  List<RamadanData> _ramadanDataLast = [];

  List<RamadanData> get ramadanDataShow => _ramadanDataShow;
  List<RamadanData> get ramadanAllData => _ramadanAllData;
  List<RamadanData> get ramadanDataLast => _ramadanDataLast;

  late Repetitions _repetitionsSelected;
  late BuildContext _context;
  bool alreadyFilledData = false;

  List<RamadanSoundsModel> ramadanCannonModel = [];
  DataLoadingState loadedCannonState = DataLoadingState.notLoaded;
  List<FileDownloadState> filesCannonStates = [];

  bool get ramadanCannon => _ramadanCannon;

  bool _ramadanCannon = false;
  int _pickedRamadanConnanIndex = 0;

  int get pickedRamadanConnanIndex => _pickedRamadanConnanIndex;

  set pickedRamadanConnanIndex(int value) {
    _pickedRamadanConnanIndex = value;
    notifyListeners();
  }

  late RamadanSoundsModel _ramadanCannonSelected;

  RamadanSoundsModel get ramadanCannonSelected => _ramadanCannonSelected;

  set ramadanCannonSelected(RamadanSoundsModel value) {
    _ramadanCannonSelected = value;
    notifyListeners();
  }

  // mashraaat

  DataLoadingState loadedMashraatState = DataLoadingState.notLoaded;
  List<RamadanSoundsModel> ramadanMashraatModel = [];
  List<FileDownloadState> filesMashraatStates = [];
  late RamadanSoundsModel _ramadanMashraatSelected;
  bool _ramadanMashraat = false;

  bool get ramadanMashraat => _ramadanMashraat;
  int _pickedRamadannMashraatIndex = 0;

  set pickedRamadannMashraatIndex(int value) {
    _pickedRamadannMashraatIndex = value;
    notifyListeners();
  }

  RamadanSoundsModel get ramadanMashraatSelected => _ramadanMashraatSelected;

  set ramadanMashraatSelected(RamadanSoundsModel value) {
    _ramadanMashraatSelected = value;
    notifyListeners();
  }

  DateTime _dateTime = DateTime.now();

  DateTime get dateMshart => _dateTime;

  set dateMshart(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }

  RamadanProvider() {
    getRamadanCalender();
  }

  getRamadanCalender() async {
    setViewState(ViewState.Loading);
    var dateLocal = locator<Prefs>().getRamadanMashartTime();
    var now = DateTime.now();
    _ramadanAllData = await RamadanApiService().getRamadanCalender();
    notifyListeners();

    if (_ramadanAllData != null && _ramadanAllData.isNotEmpty) {
      for (int i = 0; i < 7; i++) {
        _ramadanDataShow.add(_ramadanAllData[i]);
      }

      int next = 7 + 1;
      for (int i = next; i < _ramadanAllData.length; i++) {
        _ramadanDataLast.add(_ramadanAllData[i]);
      }
      // splitList(_ramadanAllData, _ramadanDataShow, _ramadanDataLast, 7);
    }
    notifyListeners();

    if (dateLocal == null || dateLocal.isEmpty) {
      if (_ramadanAllData.isNotEmpty) {
        final ramadanDay = _ramadanAllData.firstWhereOrNull(
          (element) => element.date?.gregorian?.day == now.day.toString(),
        );
        if (ramadanDay != null) {
          var beforFajirTime = ramadanDay.timings.fajr.split(" ")[0];
          var hourUpdate = int.parse(beforFajirTime.split(":")[0]) - 2;
          var mshatTime =
              hourUpdate.toString() + ":" + beforFajirTime.split(":")[1];
          locator<Prefs>().setRamadanMashartTime(mshatTime);
          _dateTime = DateTime(now.year, now.month, now.day, hourUpdate,
              int.parse(beforFajirTime.split(":")[1]));
        }
      }
    } else {
      _dateTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(dateLocal.split(":")[0]),
          int.parse(dateLocal.split(":")[1]));
    }
    setViewState(ViewState.Idle);
    notifyListeners();
  }

  splitList(List main, List frist, List secound, int index) {}

  fillTheSettingsData() async {
    if (!alreadyFilledData) {
      _ramadanCannon = locator<Prefs>().getRamadanConnanFlag() ?? false;
      _ramadanMashraat = locator<Prefs>().getRamadanMashraatFlag() ?? false;
      var data2 = await locator<Prefs>().getRamadanMashraatFlag() ?? false;
      _ramadanMashraat = data2;
      alreadyFilledData = true;
    }
    loadRepetitionsSelected();
  }

  set context(BuildContext value) {
    _context = value;
  }

  List<Repetitions> get repetitions => _repetitions;

  Repetitions get repetitionsSelected => _repetitionsSelected;

  set repetitionsSelected(Repetitions value) {
    _repetitionsSelected = value;
    notifyListeners();
  }

  ramadanCannonAlertFlagChanged(bool newVal) async {
    _ramadanCannon = newVal;
    locator<Prefs>().setRamadanConnanFlag(newVal);
    if (newVal) {
      saveUnSelectedVoiceCannon();
    }
    notifyListeners();
    await Constants.platform.invokeMethod("fireCannonRamadan");
  }

  saveUnSelectedVoiceCannon() async {
    ramadanCannonSelected = ramadanCannonModel[0];
    saveSelectedConnanJson(ramadanCannonSelected.toJson(), "");
    await downloadConnanFile(ramadanCannonModel.indexOf(ramadanCannonSelected));
  }

  ramadanMashraaatAlertFlagChanged(bool newVal) async {
    _ramadanMashraat = newVal;
    locator<Prefs>().setRamadanMashraatFlag(newVal);
    if (newVal) {
      saveUnSelectedVoiceMashraat();
    }
    notifyListeners();
    await Constants.platform.invokeMethod("fireMshartRamadan");
  }

  saveUnSelectedVoiceMashraat() async {
    ramadanMashraatSelected = ramadanMashraatModel[0];
    saveSelectedMashraatJson(ramadanMashraatSelected.toJson(), "");
    await downloadMashraatFile(
        ramadanMashraatModel.indexOf(ramadanMashraatSelected));
  }

  ramadanMshartTimeChanged(DateTime newVal) async {
    _dateTime = newVal;
    locator<Prefs>()
        .setRamadanMashartTime(DateFormat("HH:mm").format(_dateTime));
    notifyListeners();
    await Constants.platform.invokeMethod("fireMshartRamadan");
  }

  loadConnanSounds() async {
    ramadanCannonModel =
        await LocalStorageManager().loadRamadanCannonModel() ?? [];
    if (ramadanCannonModel.isNotEmpty) {
      for (RamadanSoundsModel sound in ramadanCannonModel) {
        filesCannonStates.add(FileDownloadState.initial);
      }
      loadedCannonState = DataLoadingState.localAvailable;
    } else {
      ramadanCannonModel = await RamadanCannonAPI().requestRamadanCannon();
      for (RamadanSoundsModel sound in ramadanCannonModel) {
        filesCannonStates.add(FileDownloadState.initial);
      }
      //save cannon sounds locally
      await LocalStorageManager()
          .saveRamadanCannonModelList(ramadanCannonModel);
      loadedCannonState = DataLoadingState.localAvailable;

      // setViewState(ViewState.Idle);
    }
    notifyListeners();
  }

  //load azan sounds
  void checkForCannonLocal(String soundId) async {
    var azanList = await LocalStorageManager().loadRamadanCannonModel();
    String? savedSoundCannon = locator<Prefs>().getRamadanCannonJSON(soundId);
    if (azanList != null) {
      loadedCannonState = DataLoadingState.localAvailable;
      ramadanCannonModel = azanList;

      for (RamadanSoundsModel sound in ramadanCannonModel) {
        if (sound.localPath != null)
          filesCannonStates.add(FileDownloadState.downloaded);
        else
          filesCannonStates.add(FileDownloadState.initial);

        if (savedSoundCannon != null) {
          Map<String, dynamic> localSavedSoundCannon =
              jsonDecode(savedSoundCannon);

          if (localSavedSoundCannon.containsKey('id') &&
              localSavedSoundCannon['id'].toString() == sound.id.toString()) {
            _pickedRamadanConnanIndex = ramadanCannonModel.indexOf(sound);
          }
        }
      }
      notifyListeners();
    } else {
      loadedCannonState = DataLoadingState.canBeLoadedFromLocal;
      notifyListeners();
    }
  }

  loadMashraatSounds() async {
    ramadanMashraatModel =
        await LocalStorageManager().loadRamadanMashraatModel() ?? [];
    if (ramadanMashraatModel.isNotEmpty) {
      for (RamadanSoundsModel sound in ramadanMashraatModel) {
        filesMashraatStates.add(FileDownloadState.initial);
      }
      loadedMashraatState = DataLoadingState.localAvailable;
    } else {
      ramadanMashraatModel =
          await RamadanMashraatAAPI().requestRamadanMashraat();

      for (RamadanSoundsModel sound in ramadanMashraatModel) {
        filesMashraatStates.add(FileDownloadState.initial);
      }
      await LocalStorageManager()
          .saveRamadanMashraatModelList(ramadanMashraatModel);
      loadedMashraatState = DataLoadingState.localAvailable;

      print("from web");
    }
    notifyListeners();
  }

  void checkForMashraatLocal(String soundId) async {
    var azanList = await LocalStorageManager().loadRamadanMashraatModel();
    String? savedSoundCannon = locator<Prefs>().getRamadanMashraatJSON(soundId);

    if (azanList != null) {
      //print(azanList.toString());
      loadedMashraatState = DataLoadingState.localAvailable;
      ramadanMashraatModel = azanList;

      for (RamadanSoundsModel sound in ramadanMashraatModel) {
        if (sound.localPath != null)
          filesMashraatStates.add(FileDownloadState.downloaded);
        else
          filesMashraatStates.add(FileDownloadState.initial);

        if (savedSoundCannon != null) {
          Map<String, dynamic> localSavedSoundCannon =
              jsonDecode(savedSoundCannon);

          if (localSavedSoundCannon.containsKey('id') &&
              localSavedSoundCannon['id'].toString() == sound.id.toString()) {
            _pickedRamadannMashraatIndex = ramadanMashraatModel.indexOf(sound);
          }
        }
      }
      notifyListeners();
    } else {
      loadedMashraatState = DataLoadingState.canBeLoadedFromLocal;
      notifyListeners();
    }
  }

  Future<File> downloadConnanFile(int soundIndex) async {
    filesCannonStates[soundIndex] = FileDownloadState.downloading;
    notifyListeners();
    RamadanSoundsModel sound = ramadanCannonModel[soundIndex];
    sound.file = (sound.file ?? '').replaceFirst("http://", "https://");

    var request = await httpClient.getUrl(Uri.parse(sound.file ?? ''));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    String dir = (await getApplicationDocumentsDirectory()).path;
    var filename = "ramadan_cannonModel_sounds${sound.id}.mp3";

    File file = new File(join(dir, filename));
    await file.writeAsBytes(bytes);
    sound.localPath = file.path;
    filesCannonStates[soundIndex] = FileDownloadState.downloaded;
    LocalStorageManager().updateRamadanCannonList(sound);
    notifyListeners();
    return file;
  }

  Future<File> downloadMashraatFile(int soundIndex) async {
    filesMashraatStates[soundIndex] = FileDownloadState.downloading;
    notifyListeners();
    RamadanSoundsModel sound = ramadanMashraatModel[soundIndex];
    sound.file = (sound.file ?? '').replaceFirst("http://", "https://");

    var request = await httpClient.getUrl(Uri.parse(sound.file ?? ''));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    String dir = (await getApplicationDocumentsDirectory()).path;
    var filename = "ramadan_mashraat_sounds${sound.id}.mp3";

    File file = new File(join(dir, filename));
    print("dowenlooooooood  " + file.path);
    await file.writeAsBytes(bytes);
    sound.localPath = file.path;
    filesMashraatStates[soundIndex] = FileDownloadState.downloaded;
    LocalStorageManager().updateRamadanMashraatList(sound);
    notifyListeners();
    return file;
  }

  RamadanSoundsModel getRamadanMashraat(index) {
    return ramadanMashraatModel[index];
  }

  RamadanSoundsModel getRamadanCannon(index) {
    return ramadanCannonModel[index];
  }

  Future<void> saveSelectedConnanJson(
      Map<String, dynamic> json, String azanId) async {
    await locator<Prefs>().setRamadanCannonJSON(json, azanId);
    print("saved local db cannon sound json");
  }

  Future<void> saveSelectedMashraatJson(
      Map<String, dynamic> json, String azanId) async {
    await locator<Prefs>().setRamadanMashraatJSON(json, azanId);
    print("saved local db mshart sound json");
  }

  Future<void> saveSelectedMashraatRepetitionsJson(
      String repetitionsId, BuildContext context) async {
    await locator<Prefs>().setSelectedMashraatRepetitionsId(repetitionsId);
    await locator<Prefs>().setCHECKREPETITIONRepetitionsId("0");
    print("saved local db repetitionsId  json");
  }

  loadCannonSelection() async {
    if (locator<Prefs>().getRamadanCannonJSON("") != null) {
      String? savedLoadedid =
          locator<Prefs>().getDownloadSelectedRamadanConnanID("");
      for (RamadanSoundsModel sound in ramadanCannonModel) {
        if (savedLoadedid == sound.id.toString()) {
          _ramadanCannonSelected = sound;
          return;
        }
      }
    }
  }

  loadMshartSelection() async {
    if (locator<Prefs>().getRamadanMashraatJSON("") != null) {
      String? savedLoadedid =
          locator<Prefs>().getDownloadSelectedRamadanMshartID("");
      for (RamadanSoundsModel sound in ramadanMashraatModel) {
        if (savedLoadedid == sound.id.toString()) {
          _ramadanMashraatSelected = sound;
          return;
        }
      }
    }
    print(_ramadanMashraatSelected);
    print("hosssaaaaaaaaaaaaaaaam");
    print(_ramadanMashraatSelected.id);
  }

  loadRepetitionsSelected() {
    var repetitionsId =
        locator<Prefs>().getSelectedMashraatRepetitionsId() ?? "0";
    _repetitionsSelected =
        _repetitions.firstWhere((itme) => itme.id.toString() == repetitionsId);
  }
}
