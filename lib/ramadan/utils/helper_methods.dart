import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getFormattedTime(time) {
  DateTime _now = DateTime.now();
  var timeOfDay = TimeOfDay(
    hour: int.parse(time.split(":")[0]),
    minute: int.parse(time.split(":")[1]),
  );
  return DateFormat('hh:mm').format(DateTime(
      _now.year, _now.month, _now.day, timeOfDay.hour, timeOfDay.minute))+"   " +"${timeOfDay.hour >= 12 ? "م" : "ص"}";
}
String getFormattedDate(String date){

  var inputFormat = DateFormat('dd-MM-y');
  var inputDate = inputFormat.parse(date); // <-- Incoming date
  var outputFormat = DateFormat.MMMMd("ar");
  var outputDate = outputFormat.format(inputDate); // <-- Desired date

  return outputDate;
}
