import 'package:muslim_book/local_storage/local_storage_manager.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/azan_sound.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:flutter/material.dart';

class PickAzanShiekhProvider extends ViewStateProvider {
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

  Future saveAssetsSelectedShiekh(
    context,
    String azanId,
    int azanIndex, {
    bool saveToAll = true,
  }) async {
    if (saveToAll) {
      //save the same sheikh to all prayer times
      for (int i = 2; i <= 6; i++) {
        await locator<Prefs>().setAzanShiekh(
          Constants.AZAN_SHIEKH_LOCAL_ID + i.toString(),
          azanIndex.toString(),
        );
        await locator<Prefs>().setAzanShiekh(
          Constants.AZAN_SHIEKH + i.toString(),
          azanIndex.toString(),
        );
        await locator<Prefs>().clearDownloadedAzanShiekh(i.toString());
      }
    } else {
      await locator<Prefs>().setAzanShiekh(
          Constants.AZAN_SHIEKH_LOCAL_ID + azanId.toString(),
          azanIndex.toString());
      // The picker reads this key; without it, it showed the previous sheikh
      await locator<Prefs>().setAzanShiekh(
          Constants.AZAN_SHIEKH + azanId.toString(), azanIndex.toString());
      await locator<Prefs>().clearDownloadedAzanShiekh(azanId.toString());
    }
    Navigator.pop(context, _pickedAzanShiekhIndex);
  }

  Future loadSelectedShiekh(String azanId, context) async {
    String savedShiekhId = locator<Prefs>().getAzanShiekh(azanId);
    if (savedShiekhId.isNotEmpty) {
      for (Map<String, dynamic> shiekh
          in AppLocalizations.of(context)!.isEnglish()
              ? Constants.EN_SHIEKH_NAMES
              : Constants.AR_SHIEKH_NAMES) {
        // String check = '${shiekh["id"]}$azanId';

        if (shiekh["id"] == savedShiekhId) {
          _pickedAzanShiekhIndex = AppLocalizations.of(context)!.isEnglish()
              ? Constants.EN_SHIEKH_NAMES.indexOf(shiekh)
              : Constants.AR_SHIEKH_NAMES.indexOf(shiekh);
          _pickedAzanShiekh = AppLocalizations.of(context)!.isEnglish()
              ? Constants.EN_SHIEKH_NAMES[_pickedAzanShiekhIndex]
              : Constants.AR_SHIEKH_NAMES[_pickedAzanShiekhIndex];

          return;
        }
      }
    } else if (locator<Prefs>().getDownloadedAzanShiekhId().isNotEmpty) {
      //check for azan json
      String savedLoadedid = locator<Prefs>().getDownloadedAzanShiekhId();
      List<AzanSound>? sounds = await LocalStorageManager().loadAzanSoundsList();
      if (sounds != null) {
        for (AzanSound sound in sounds) {
          if (savedLoadedid == sound.id.toString()) {
            _pickedAzanShiekhIndex = sounds.indexOf(sound);
            _pickedAzanShiekh = sound.toJSON();
            return;
          }
        }
      }
    } else {
      _pickedAzanShiekhIndex = 0;
      _pickedAzanShiekh = AppLocalizations.of(context)!.isEnglish()
          ? Constants.EN_SHIEKH_NAMES[_pickedAzanShiekhIndex]
          : Constants.AR_SHIEKH_NAMES[_pickedAzanShiekhIndex];
    }
  }
}
