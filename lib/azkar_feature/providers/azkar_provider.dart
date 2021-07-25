import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:flutter/material.dart';

class AzkarProvider extends ChangeNotifier {
  List<Map<String, String>>  azkarList(context) => [
        {"name":
  AppLocalizations.of(context).translate("morning_azkar"),
  "path": "morning.json", "image": "morning.png"},
        {
          "name":AppLocalizations.of(context).translate("evening_azkar"),
          "path": "evening_azkar.json",
          "image": "evening_azkar.png"
        },
        {
          "name": AppLocalizations.of(context).translate("best_doa"),
          "path": "best_doa.json",
          "image": "best_doa.png"
        },
        {"name":AppLocalizations.of(context).translate("nabe"),
          "path": "propet_doa.json", "image": "propet_doa.png"},
        {
          "name":AppLocalizations.of(context).translate("opening_salah"),
          "path": "opening_salah.json",
          "image": "opening_salah.png"
        },
        {
          "name": AppLocalizations.of(context).translate("setting_between_sajda"),
          "path": "setting_between_sajda.json",
          "image": "setting_between_sajda.png"
        },
        {
          "name": AppLocalizations.of(context).translate("getting_up_from_ruku"),
          "path": "getting_up_from_ruku.json",
          "image": "getting_up_from_ruku.png"
        },
        {"name": AppLocalizations.of(context).translate("ruku_doa"),
        "path": "ruku_doa.json", "image": "ruku_doa.png"},
        {"name":AppLocalizations.of(context).translate("sujud_doa") ,
 "path": "sujud_doa.json", "image": "sujud_doa.png"},
        {
          "name": AppLocalizations.of(context).translate("sujud_telawa"),
          "path": "sujud_doa.json",
          "image": "sujud_doa.png"
        },
        {"name":AppLocalizations.of(context).translate("sleeping"),
        "path": "sleeping.json", "image": "sleeping.png"},
        {
          "name": AppLocalizations.of(context).translate("wake_up"),
          "path": "wake_up.json",
          "image": "wake_up.png"
        },
      ];
}
