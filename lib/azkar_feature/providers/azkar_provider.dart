import 'package:flutter/material.dart';

class AzkarProvider extends ChangeNotifier {
  List<Map<String, String>> get azkarList => [
        {"name": "الصباح", "path": "morning.json", "image": "morning.png"},
        {
          "name": "المساء",
          "path": "evening_azkar.json",
          "image": "evening_azkar.png"
        },
        {
          "name": "جوامع الدعاء",
          "path": "best_doa.json",
          "image": "best_doa.png"
        },
        {"name": "النبي", "path": "propet_doa.json", "image": "propet_doa.png"},
        {
          "name": "استفتاح الصلاة",
          "path": "opening_salah.json",
          "image": "opening_salah.png"
        },
        {
          "name": " الجلوس بين السجدتين",
          "path": "setting_between_sajda.json",
          "image": "setting_between_sajda.png"
        },
        {
          "name": " الرفع من الركوع",
          "path": "getting_up_from_ruku.json",
          "image": "getting_up_from_ruku.png"
        },
        {"name": " الركوع", "path": "ruku_doa.json", "image": "ruku_doa.png"},
        {"name": " السجود", "path": "sujud_doa.json", "image": "sujud_doa.png"},
        {
          "name": "سجود التلاوة",
          "path": "sujud_telawa_doa.json",
          "image": "sujud_doa.png"
        },
        {"name": "النوم", "path": "sleeping.json", "image": "sleeping.png"},
        {
          "name": "الإستيقاظ من النوم",
          "path": "wake_up.json",
          "image": "wake_up.png"
        },
      ];
}
