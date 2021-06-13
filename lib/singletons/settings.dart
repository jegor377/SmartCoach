import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_coach/models/repeating_days.dart';
import 'package:smart_coach/singletons/native_api.dart';

class Settings {
  static final Settings _instance = Settings._internal();
  late SharedPreferences _preferences;
  static int timeSpentWorking = 0;
  static bool shouldNotify = false;
  static NotifyTime notificationTime = NotifyTime();
  static TrainingRepeatingDays repeatingDays = TrainingRepeatingDays();


  factory Settings() {
    return _instance;
  }

  Settings._internal();

  static Future load() async {
    _instance._preferences = await SharedPreferences.getInstance();
    await _instance._loadTimeSpentWorking();
    await _instance._loadShouldNotify();
    await _instance._loadNotificationTime();
    await _instance._loadRepeatingDays();
  }

  static Future save() async {
    await _instance._saveTimeSpentWorking();
    await _instance._saveShouldNotify();
    await _instance._saveNotificationTime();
    await _instance._saveRepeatingDays();
  }

  static Future resetNotificationService() async {
    await NativeAPI.stopService();
    if(shouldNotify) {
      await NativeAPI.startService(notificationTime, repeatingDays);
    }
  }

  Future _loadTimeSpentWorking() async {
    if(_preferences.containsKey('timeSpentWorking')) {
      timeSpentWorking = _preferences.getInt('timeSpentWorking')!;
    } else {
      await _saveTimeSpentWorking();
    }
  }

  Future _saveTimeSpentWorking() async {
    await _preferences.setInt('timeSpentWorking', timeSpentWorking);
  }

  Future _loadShouldNotify() async {
    if(_preferences.containsKey('shouldNotify')) {
      shouldNotify = _preferences.getBool('shouldNotify')!;
    } else {
      await _saveShouldNotify();
    }
  }

  Future _saveShouldNotify() async {
    await _preferences.setBool('shouldNotify', shouldNotify);
  }

  Future _loadNotificationTime() async {
    if(_preferences.containsKey('notificationTime')) {
      notificationTime = NotifyTime.fromJson(jsonDecode(_preferences.getString('notificationTime')!));
    } else {
      await _saveNotificationTime();
    }
  }

  Future _saveNotificationTime() async {
    await _preferences.setString('notificationTime', jsonEncode(notificationTime.toJson()));
  }

  Future _loadRepeatingDays() async {
    if(_preferences.containsKey('repeatingDays')) {
      repeatingDays = TrainingRepeatingDays.fromJson(jsonDecode(_preferences.getString('repeatingDays')!));
    } else {
      await _saveRepeatingDays();
    }
  }

  Future _saveRepeatingDays() async {
    await _preferences.setString('repeatingDays', jsonEncode(repeatingDays.toJson()));
  }
}