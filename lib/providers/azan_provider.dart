import 'dart:async';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/network_utils/azan_apis.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AzanProvider extends ViewStateProvider {
  DateTime now = DateTime.now();
  bool isMounted = true;
  late BuildContext _context;
  DateFormat timeFormatter = DateFormat('hh:mm');
  List<Map<String, String>>? azanList;
  DateTime? _nextSalah;
  int? nextAzanKey;
  late Duration _remaining;
  StreamSubscription? stream;

  AzanProvider() {
    _remaining = Duration(seconds: 0);
  }

  Duration get remaining => _remaining;

  void setRemaining() {
    try {
      if (nextSalah != null) {
        _remaining = Duration(
            milliseconds: nextSalah!.millisecondsSinceEpoch -
                DateTime.now().millisecondsSinceEpoch);
        if (_remaining.inMilliseconds < 1000) {
          _remaining = Duration(seconds: 0);
          setNextSalah();
        }
        notifyListeners();
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future getAzanModel(context) async {
    setViewState(ViewState.Loading);
    //print("hosaaaaaaaaaaaaaaaaaaaaaaaam  2   ");

    await AzanApis().getAzan();
    Future.delayed(Duration(seconds: 1), () {
      setViewState(ViewState.Idle);
      setNextSalah();
      startRemainingStream();
      notifyListeners();
    });
  }

  List<Map<String, String>>? getAzanList() {
    try {
      List<Map<String, String>> azanList = [
        {
          "hours": locator<Prefs>().getAssalahTime("1").split(":")[0],
          "icon": "assets/images/azan_view/fajr_icon.svg",
          "title": AppLocalizations.of(_context)!.translate("fajr"),
          "time": getFormattedTime(locator<Prefs>().getAssalahTime("1")),
        },
        {
          "hours": locator<Prefs>().getAssalahTime("2").split(":")[0],
          "icon": "assets/images/azan_view/doha_icon.svg",
          "title": AppLocalizations.of(_context)!.translate("doha"),
          "time": getFormattedTime(locator<Prefs>().getAssalahTime("2")),
        },
        {
          "hours": locator<Prefs>().getAssalahTime("3").split(":")[0],
          "icon": "assets/images/azan_view/zuhr_icon.svg",
          "title": AppLocalizations.of(_context)!.translate("azzuhr"),
          "time": getFormattedTime(locator<Prefs>().getAssalahTime("3")),
        },
        {
          "hours": locator<Prefs>().getAssalahTime("4").split(":")[0],
          "icon": "assets/images/azan_view/.svg",
          "title": AppLocalizations.of(_context)!.translate("asr"),
          "time": getFormattedTime(locator<Prefs>().getAssalahTime("4")),
        },
        {
          "hours": locator<Prefs>().getAssalahTime("5").split(":")[0],
          "icon": "assets/images/azan_view/maghreb_icon.svg",
          "title": AppLocalizations.of(_context)!.translate("maghreb"),
          "time": getFormattedTime(locator<Prefs>().getAssalahTime("5")),
        },
        {
          "hours": locator<Prefs>().getAssalahTime("6").split(":")[0],
          "icon": "assets/images/azan_view/isha_icon.svg",
          "title": AppLocalizations.of(_context)!.translate("isha"),
          "time": getFormattedTime(locator<Prefs>().getAssalahTime("6")),
          "isha": "true"
        }
      ];
      return azanList;
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
    return "${timeFormatter.format(DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute))}";
  }

  set context(BuildContext context) => _context = context;

  DateTime? get nextSalah => _nextSalah;

  void setNextSalah() {
    try {
      int today = DateTime.now().day;
      int month = DateTime.now().month;
      int year = DateTime.now().year;
      for (int i = 1; i <= 6; i++) {
        String time = locator<Prefs>().getAssalahTime("$i");
        var timeOfDay = TimeOfDay(
          hour: int.parse(time.split(":")[0]),
          minute: int.parse(time.split(":")[1]),
        );
        if (DateTime(year, month, today, timeOfDay.hour, timeOfDay.minute)
            .isAfter(DateTime.now())) {
          _nextSalah =
              DateTime(year, month, today, timeOfDay.hour, timeOfDay.minute);
          nextAzanKey = i;
          notifyListeners();
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
      hour: int.parse(time.split(":")[0]),
      minute: int.parse(time.split(":")[1]),
    );
    var tomorrow = DateTime.now().add(Duration(days: 1));
    _nextSalah = DateTime(tomorrow.year, tomorrow.month, tomorrow.day,
        timeOfDay.hour, timeOfDay.minute);
    nextAzanKey = 1;
    notifyListeners();
  }

  Map<int, String> getAzanByIndex(context) => {
        1: AppLocalizations.of(context)!.translate("fajr"),
        2: AppLocalizations.of(context)!.translate("doha"),
        3: AppLocalizations.of(context)!.translate("azzuhr"),
        4: AppLocalizations.of(context)!.translate("asr"),
        5: AppLocalizations.of(context)!.translate("maghreb"),
        6: AppLocalizations.of(context)!.translate("isha"),
      };

  void startRemainingStream() {
    stream = Stream.periodic(Duration(seconds: 1)).listen((_) {
      if (isMounted) {
        setRemaining();
      }
    });
  }

  @override
  void dispose() {
    if (stream != null) {
      stream!.cancel();
      stream = null;
    }
    super.dispose();
  }
}
