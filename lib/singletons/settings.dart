import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static final Settings _instance = Settings._internal();
  int _timeSpentWorking = 0;


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
    return true;
  }

  static void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('timeSpentWorking', _instance._timeSpentWorking);
  }

  static int get timeSpentWorking => _instance._timeSpentWorking;
  static set timeSpentWorking (int value) => _instance._timeSpentWorking = value;
}