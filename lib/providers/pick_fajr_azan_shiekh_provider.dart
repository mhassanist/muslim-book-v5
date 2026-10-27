import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:flutter/material.dart';

class PickFajrAzanShiekhProvider extends ViewStateProvider {
  Map<String, dynamic> _pickedAzanShiekh = {};

  int _pickedAzanShiekhIndex = 0;

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

  Future saveAssetsFajrSheikhId(context) async {
    //locator<Prefs>().setAzanShiekh(Constants.FAJR_SHIEKH_NAMES[_pickedAzanShiekhIndex]["id"]);
    locator<Prefs>().setFajrAzanShiekhIdAsset(Constants.FAJR_SHIEKH_NAMES[_pickedAzanShiekhIndex]["id"]);
    // A downloaded Fajr sheikh takes precedence natively; clear it so the
    // built-in one actually plays
    await locator<Prefs>().clearDownloadedFajrAzanShiekh();
    Navigator.pop(context, _pickedAzanShiekhIndex);
  }


  Future loadAssetsFajrSheikhId() async {
    String savedShiekhId = locator<Prefs>().getFajrAzanShiekh();
    if(savedShiekhId.isNotEmpty){
      for(Map<String, dynamic> shiekh in Constants.FAJR_SHIEKH_NAMES){
        if(shiekh["id"] == savedShiekhId){
          _pickedAzanShiekhIndex = Constants.FAJR_SHIEKH_NAMES.indexOf(shiekh);
          return;
        }
      }
    }else{
      _pickedAzanShiekhIndex = 0;
    }

    _pickedAzanShiekh = Constants.FAJR_SHIEKH_NAMES[_pickedAzanShiekhIndex];
  }
}
