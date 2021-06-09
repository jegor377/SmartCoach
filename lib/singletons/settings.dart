import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static final Settings _instance = Settings._internal();
  int _timeSpentWorking = 0;
  TimeOfDay _notificationTime = TimeOfDay.now();


  factory Settings() {
    return _instance;
  }

  Settings._internal();

  static Future<bool> load() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('timeSpentWorking')) {
      _instance._timeSpentWorking = prefs.getInt('timeSpentWorking')!;
    } else {
      prefs.setInt('timeSpentWorking', _instance._timeSpentWorking);
    }
    if(prefs.containsKey('notificationTimeHour') && prefs.containsKey('notificationTimeMinute')) {
      _instance._notificationTime = TimeOfDay(
        hour: prefs.getInt('notificationTimeHour')!,
        minute: prefs.getInt('notificationTimeMinute')!
      );
    } else {
      prefs.setInt('notificationTimeHour', _instance._notificationTime.hour);
      prefs.setInt('notificationTimeMinute', _instance._notificationTime.minute);
    }
    return true;
  }

  static void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('timeSpentWorking', _instance._timeSpentWorking);
  }

  static int get timeSpentWorking => _instance._timeSpentWorking;
  static set timeSpentWorking (int value) => _instance._timeSpentWorking = value;

  static TimeOfDay get notificationTime => _instance._notificationTime;
  static set notificationTime(TimeOfDay value) => _instance._notificationTime = value;
  static String get notificationTimeLabel {
    String hours = _instance._notificationTime.hour.toString().padLeft(2, '0');
    String minutes = _instance._notificationTime.minute.toString().padLeft(2, '0');
    return "${hours}:${minutes}";
  }
}