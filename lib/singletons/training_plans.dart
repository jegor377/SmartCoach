import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:smart_coach/models/training.dart';

class TrainingPlans {
  static final TrainingPlans _instance = TrainingPlans._internal();

  List<TrainingPlan> _plans = [];

  factory TrainingPlans() {
    return _instance;
  }

  TrainingPlans._internal();

  static Future<String> get appDir async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> get trainingPlansPath async {
    var dir = await appDir;
    return '$dir/training_plans.json';
  }

  static Future<bool> load() async {
    List<TrainingPlan> _tPlans = [];
    String filePath = await trainingPlansPath;
    bool fileExists = await File(filePath).exists();
    if(fileExists) {
      File file = File(filePath);
      final contents = await file.readAsString();
      final contentsPlans = jsonDecode(contents);
      for(Map<String, dynamic> plan in contentsPlans['plans']) {
        _tPlans.add(TrainingPlan.fromJson(plan));
      }
      _instance._plans = _tPlans;
    } else {
      File file = await File(filePath).create();
      var defaultTrainingPlans = {
        'plans': [],
      };
      file.writeAsString(jsonEncode(defaultTrainingPlans));
    }
    return true;
  }

  static void save() async {
    String filePath = await trainingPlansPath;
    bool fileExists = await File(filePath).exists();
    if(fileExists) {
      File file = File(filePath);
      List<Map<String, dynamic>> plansToSave = [];
      for(TrainingPlan plan in _instance._plans) {
        plansToSave.add(plan.toJson());
      }
      file.writeAsString(jsonEncode({
        'plans': plansToSave,
      }), mode: FileMode.write);
    }
  }

  static List<TrainingPlan> get plans => _instance._plans;

  static void reorderPlans(int oldIndex, int newIndex) {
    if(oldIndex < newIndex) {
      newIndex -= 1;
    }
    final TrainingPlan plan = _instance._plans.removeAt(oldIndex);
    _instance._plans.insert(newIndex, plan);
  }
}