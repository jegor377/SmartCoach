import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_coach/models/repeating_days.dart';

class NativeAPI {
  static final NativeAPI _instance = NativeAPI._internal();
  static const channel = 'com.smart_coach.methods';
  late var _platform = MethodChannel(channel);


  factory NativeAPI() {
    return _instance;
  }

  NativeAPI._internal();

  static void initialize() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static Future startService(NotifyTime time, TrainingRepeatingDays repeatingDays) async {
    await _instance._platform.invokeMethod('startNotificationService', {
      'time': time.toJson(),
      'repeatingDays': repeatingDays.toJson(),
    });
  }

  static Future playSound(String resourcePath) async {
    await _instance._platform.invokeMethod('playSound', {
      'path': resourcePath
    });
  }

  static Future stopService() async {
    await _instance._platform.invokeMethod('stopNotificationService');
  }
}

class NotifyTime {
  final int hour;
  final int minute;

  NotifyTime({this.hour = 0, this.minute = 0});

  factory NotifyTime.fromTimeOfDay(TimeOfDay time) => NotifyTime(
    hour: time.hour,
    minute: time.minute,
  );

  TimeOfDay toTimeOfDay() => TimeOfDay(
    hour: hour,
    minute: minute,
  );

  factory NotifyTime.fromJson(Map<String, dynamic> json) {
    return NotifyTime(hour: json['hour'], minute: json['minute']);
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'minute': minute
    };
  }

  @override
  String toString() {
    String _hour = hour.toString().padLeft(2, '0');
    String _minute = minute.toString().padLeft(2, '0');
    return '$_hour:$_minute';
  }
}