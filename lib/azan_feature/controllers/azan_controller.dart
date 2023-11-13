import 'dart:async';

import 'package:muslim_book/azan_feature/models/azan_model.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class AzanController extends GetxController {
  DateTime _now = DateTime.now();
  String _currentDate = '';
  bool _volume = false;
  String _currentDayName = '';
  DateTime? _nextSalah;
  late int _nextAzanKey;
  Duration? _remaining;
  String _remainingText = '';
  StreamSubscription? _stream;
  List<Azan> azanValue = [];
  List<String> mutedAzanList = [];
  List<Map<String, dynamic>> azanList = [];

  @override
  void onInit() {
    super.onInit();
    getMutedAzanList();
  }

  @override
  onReady() {
    print("arrived to onReady");
    getCurrentDay();
    setNextSalah();
    _remaining = Duration(seconds: 0);
    startRemainingStream();
  }

  void startRemainingStream() {
    _stream = Stream.periodic(Duration(seconds: 1)).listen((_) {
      setRemaining();
    });
  }

  void setRemaining() {
    try {
      if (_nextSalah != null) {
        _remaining = Duration(
            milliseconds: _nextSalah!.millisecondsSinceEpoch -
                DateTime.now().millisecondsSinceEpoch);
        if (_remaining!.inMilliseconds < 1000) {
          _remaining = Duration(seconds: 0);
          getCurrentDay();
          setNextSalah();
        }
        final DateTime remainingDateTime =
            DateTime.fromMillisecondsSinceEpoch(remaining!.inMilliseconds);
        _remainingText = DateFormat.Hms().format(remainingDateTime);
        update();
      }
    } catch (ex) {
      print(ex);
    }
  }

  List<Azan>? getAzanList(context) {
    getMutedAzanList();

    azanList = [
      {
        "id": "1",
        "key": "alfajr",
        "hours": locator<Prefs>().getAssalahTime("1").split(":")[0],
        "volume_enable": true,
        "title": AppLocalizations.of(context)!.translate("alfajr"),
        "time": getFormattedTime(locator<Prefs>().getAssalahTime("1")),
        "count": locator<Prefs>().getAssalahTime("update1").isNotEmpty
            ? int.parse(locator<Prefs>().getAssalahTime("update1"))
            : 0,
        "minute": locator<Prefs>().getAssalahTime("1").split(":")[1]
      },
      {
        "id": "2",
        "key": "aldahi",
        "hours": locator<Prefs>().getAssalahTime("2").split(":")[0],
        "title": AppLocalizations.of(context)!.translate("aldahi"),
        "volume_enable": true,
        "time": getFormattedTime(locator<Prefs>().getAssalahTime("2")),
        "count": locator<Prefs>().getAssalahTime("update2").isNotEmpty
            ? int.parse(locator<Prefs>().getAssalahTime("update2"))
            : 0,
        "minute": locator<Prefs>().getAssalahTime("2").split(":")[1]
      },
      {
        "id": "3",
        "key": "alzuhr",
        "hours": locator<Prefs>().getAssalahTime("3").split(":")[0],
        "title": AppLocalizations.of(context)!.translate("alzuhr"),
        "volume_enable": true,
        "time": getFormattedTime(locator<Prefs>().getAssalahTime("3")),
        "count": locator<Prefs>().getAssalahTime("update3").isNotEmpty
            ? int.parse(locator<Prefs>().getAssalahTime("update3"))
            : 0,
        "minute": locator<Prefs>().getAssalahTime("3").split(":")[1]
      },
      {
        "id": "4",
        "key": "aleasr",
        "hours": locator<Prefs>().getAssalahTime("4").split(":")[0],
        "title": AppLocalizations.of(context)!.translate("aleasr"),
        "volume_enable": true,
        "time": getFormattedTime(locator<Prefs>().getAssalahTime("4")),
        "count": locator<Prefs>().getAssalahTime("update4").isNotEmpty
            ? int.parse(locator<Prefs>().getAssalahTime("update4"))
            : 0,
        "minute": locator<Prefs>().getAssalahTime("4").split(":")[1]
      },
      {
        "id": "5",
        "key": "almaghrib",
        "hours": locator<Prefs>().getAssalahTime("5").split(":")[0],
        "title": AppLocalizations.of(context)!.translate("almaghrib"),
        "volume_enable": true,
        "time": getFormattedTime(locator<Prefs>().getAssalahTime("5")),
        "count": locator<Prefs>().getAssalahTime("update5").isNotEmpty
            ? int.parse(locator<Prefs>().getAssalahTime("update5"))
            : 0,
        "minute": locator<Prefs>().getAssalahTime("5").split(":")[1]
      },
      {
        "id": "6",
        "key": "aleasha",
        "hours": locator<Prefs>().getAssalahTime("6").split(":")[0],
        "title": AppLocalizations.of(context)!.translate("aleasha"),
        "volume_enable": true,
        "time": getFormattedTime(locator<Prefs>().getAssalahTime("6")),
        "isha": "true",
        "count": locator<Prefs>().getAssalahTime("update6").isNotEmpty
            ? int.parse(locator<Prefs>().getAssalahTime("update6"))
            : 0,
        "minute": locator<Prefs>().getAssalahTime("6").split(":")[1]
      }
    ];
    try {
      for (var data in azanList) {
        final azan = Azan.fromMap(data);
        final product = azanValue.firstWhere((product) => product.id == azan.id,
            orElse: () => Azan());
        if (product.id.isEmpty) {
          if (mutedAzanList.isNotEmpty && mutedAzanList.contains(azan.id)) {
            azan.volumeEnable = false;
          } else {
            azan.volumeEnable = true;
          }
          azan.count = locator<Prefs>()
                  .getAssalahTime("update${azan.id}")
                  .isNotEmpty
              ? int.parse(locator<Prefs>().getAssalahTime("update${azan.id}"))
              : 0;

          azanValue.add(azan);
        }
      }

      return azanValue;
    } catch (ex) {
      print("error is $ex");
      return null;
    }
  }

  String getFormattedTime(time) {
    var timeOfDay = TimeOfDay(
      hour: int.parse(time.split(":")[0]),
      minute: int.parse(time.split(":")[1]),
    );
    // print(DateFormat('hh:mm').format(DateTime.now()));
    return DateFormat('hh:mm').format(DateTime(
        _now.year, _now.month, _now.day, timeOfDay.hour, timeOfDay.minute));
    // return "asd";
  }

  Future<void> getCurrentDay() async {
    await initializeDateFormatting("ar_SA", null);

    _currentDate = DateFormat.yMMMd('ar_SA').format(DateTime.now());
    _currentDayName = DateFormat.EEEE('ar_SA').format(DateTime.now());
    update();
  }

  String get currentDate => _currentDate;

  String get currentDayName => _currentDayName;

  void setNextSalah() {
    try {
      int today = DateTime.now().day;
      int month = DateTime.now().month;
      int year = DateTime.now().year;
      for (int i = 1; i <= 6; i++) {
        String time = locator<Prefs>().getAssalahTime("$i");
        var min = time == '' ? 0 : int.parse(time.split(":")[1]);
        String corrctedTimeByMinuets =
            locator<Prefs>().getAssalahTime("update$i");
        if (corrctedTimeByMinuets.isNotEmpty) {
          min += int.parse(corrctedTimeByMinuets);
        }
        var timeOfDay = TimeOfDay(
          hour: time == '' ? 0 : int.parse(time.split(":")[0]),
          minute: min,
          // minute: int.parse(time.split(":")[1]),
        );
        if (DateTime(year, month, today, timeOfDay.hour, timeOfDay.minute)
            .isAfter(DateTime.now())) {
          _nextSalah =
              DateTime(year, month, today, timeOfDay.hour, timeOfDay.minute);
          _nextAzanKey = i;
          update();
          break;
        }
        if (i == 6) {
          setTomorrowFajr();
        }
      }
    } catch (ex) {
      print(ex);
    }
  }

  void setTomorrowFajr() {
    String time = locator<Prefs>().getAssalahTime("1");
    var timeOfDay = TimeOfDay(
      hour: time == '' ? 0 : int.parse(time.split(":")[0]),
      minute: time == '' ? 0 : int.parse(time.split(":")[1]),
    );
    var tomorrow = DateTime.now().add(Duration(days: 1));
    _nextSalah = DateTime(tomorrow.year, tomorrow.month, tomorrow.day,
        timeOfDay.hour, timeOfDay.minute);
    _nextAzanKey = 1;
    update();
  }

  get nextSalahTime => _nextSalah;

  int? get nextAzanKey => _nextAzanKey;

  Duration? get remaining => _remaining;

  get remainingText => _remainingText;

  get volume => _volume;

  changeVolume() {
    _volume = !_volume;
  }

  String getHijriDate(context) {
    Localizations.localeOf(context).languageCode == 'ar'
        ? HijriCalendar.setLocal("ar")
        : HijriCalendar.setLocal("en");
    return HijriCalendar.now().toFormat("dd MMMM yyyy");
  }

  getMutedAzanList() {
    var str = locator<Prefs>().getMutedAzanList();
    if (str != null) {
      mutedAzanList =
          str.runes.map((rune) => new String.fromCharCode(rune)).toList();
    }
  }

  saveAzanMute(bool isAdd, String azanId) {
    if (!isAdd) {
      if (mutedAzanList.isNotEmpty) {
        if (!mutedAzanList.contains(azanId)) {
          mutedAzanList.add(azanId);
        }
      } else {
        mutedAzanList.add(azanId);
      }
    } else {
      if (mutedAzanList.isNotEmpty) mutedAzanList.remove(azanId);
    }
    String map = '';
    for (var st in mutedAzanList) {
      map += st;
    }
    locator<Prefs>().saveMutedAzanList(map);
  }

  Future enableWeeklyFastingAlerts() async {
    await Constants.platform
        .invokeMethod("createOrDeleteFastingMondaysAndThursdaysAlert");
  }
}
