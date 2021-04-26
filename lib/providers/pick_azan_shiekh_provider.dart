import 'package:base_app/local_storage/local_storage_manager.dart';
import 'package:base_app/models/azan_sound.dart';
import 'package:base_app/providers/view_state_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:flutter/material.dart';

class PickAzanShiekhProvider extends ViewStateProvider {
  Map<String, dynamic> _pickedAzanShiekh;

  int _pickedAzanShiekhIndex;

  Map<String, dynamic> get pickedAzanShiekh => _pickedAzanShiekh;

  set pickedAzanShiekh(Map<String, dynamic> value) {
    _pickedAzanShiekh = value;
    notifyListeners();
  }

  int get pickedAzanShiekhIndex => _pickedAzanShiekhIndex;

  set pickedAzanShiekhIndex(int value) {
    _pickedAzanShiekhIndex = value;
    notifyListeners();
  }

  Future saveSelectedShiekh(context ,String azanId) async {
    locator<Prefs>().setAzanShiekh(Constants.SHIEKH_NAMES[_pickedAzanShiekhIndex]["id"] ,azanId);
    Navigator.pop(context, _pickedAzanShiekhIndex);
  }


  Future loadSelectedShiekh(String azanId) async {

    String savedShiekhId = locator<Prefs>().getAzanShiekh(azanId);
    if(savedShiekhId != null){
      for(Map<String, dynamic> shiekh in Constants.SHIEKH_NAMES){
        String check = '${shiekh["id"]}$azanId';


        if(shiekh["id"]== savedShiekhId){
          _pickedAzanShiekhIndex = Constants.SHIEKH_NAMES.indexOf(shiekh);
          _pickedAzanShiekh = Constants.SHIEKH_NAMES[_pickedAzanShiekhIndex];

          return;
        }
      }
    }else if(locator<Prefs>().getDownloadedAzanShiekhId()!=null){ //check for azan json
      String savedLoadedid = locator<Prefs>().getDownloadedAzanShiekhId();
      List<AzanSound> sounds = await LocalStorageManager().loadAzanSoundsList();
      for(AzanSound sound in sounds){
        if(savedLoadedid == sound.id.toString()){
          _pickedAzanShiekhIndex = sounds.indexOf(sound);
          _pickedAzanShiekh = sound.toJSON();
          return;
        }
      }
    }else{
      _pickedAzanShiekhIndex = 0;
      _pickedAzanShiekh = Constants.SHIEKH_NAMES[_pickedAzanShiekhIndex];

    }

  }
}
