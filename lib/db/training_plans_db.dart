import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:smart_coach/models/plan.dart';

class TrainingPlansDB {
  static final TrainingPlansDB _instance = TrainingPlansDB._internal();
  static const String _databaseFile = 'training_plans.json';
  static List<TrainingPlan> plans = [];

  factory TrainingPlansDB() {
    return _instance;
  }

  TrainingPlansDB._internal();

  static Future<String> get localFilesDir async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> get databasePath async {
    var dir = await localFilesDir;
    return '$dir/$_databaseFile';
  }

  static Future init() async {
    String filePath = await databasePath;
    bool fileExists = await File(filePath).exists();
    if(fileExists) {
      await _instance._load(filePath);
    } else {
      await _instance._createDb(filePath);
    }
  }

  Future _load(String filePath) async {
    File file = File(filePath);
    final contents = await file.readAsString();
    final contentsPlans = jsonDecode(contents);
    for(Map<String, dynamic> plan in contentsPlans['plans']) {
      TrainingPlan _plan = TrainingPlan.fromJson(plan);
      _plan.id = plans.length;
      plans.add(_plan);
    }
  }

  Future _createDb(String filePath) async {
    File file = await File(filePath).create();
    var defaultTrainingPlans = {
      'plans': [],
    };
    file.writeAsString(jsonEncode(defaultTrainingPlans));
  }

  Future save() async {
    String filePath = await databasePath;
    File file = File(filePath);
    List<Map<String, dynamic>> plansToSave = [];
    for(TrainingPlan plan in plans) {
      plansToSave.add(plan.toJson());
    }
    file.writeAsString(jsonEncode({
      'plans': plansToSave,
    }), mode: FileMode.write);
  }

  static Future<TrainingPlan> createPlan(TrainingPlan plan) async {
    plan.id = plans.length;
    plans.add(plan);
    await _instance.save();
    return plan;
  }

  static Future updatePlan(TrainingPlan plan) async {
    plans[plan.id] = plan;
    await _instance.save();
  }

  static Future reorderPlans(int oldIndex, int newIndex) async {
    if(oldIndex < newIndex) {
      newIndex -= 1;
    }
    final TrainingPlan plan = plans.removeAt(oldIndex);
    plans.insert(newIndex, plan);
    for(int i=0; i < plans.length; i++) {
      plans[i].id = i;
    }
    await _instance.save();
  }

  static Future deletePlan(int id) async {
    plans.removeAt(id);
    await _instance.save();
  }
}