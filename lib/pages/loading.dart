import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_coach/data/training.dart';

class LoadingTrainingPlan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoadingTrainingPlan();
}

class _LoadingTrainingPlan extends State<LoadingTrainingPlan> with TickerProviderStateMixin {
  @override
  void initState() {
    loadTrainingPlans();
    super.initState();
  }

  Future<String> get appDir async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> get trainingPlansPath async {
    var dir = await appDir;
    return '$dir/training_plans.json';
  }

  void loadTrainingPlans() async {
    List<TrainingPlan> plans = [];
    String filePath = await trainingPlansPath;
    bool fileExists = await File(filePath).exists();
    if(fileExists) {
      File file = File(filePath);
      final contents = await file.readAsString();
      final contentsPlans = jsonDecode(contents);
      for(Map plan in contentsPlans['plans']) {
        plans.add(TrainingPlan.fromJson(plan));
      }
    } else {
      File file = await File(filePath).create();
      var defaultTrainingPlans = {
        'plans': [],
      };
      file.writeAsString(jsonEncode(defaultTrainingPlans));
    }
    Navigator.pushReplacementNamed(context, '/home', arguments: plans);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900]
      ),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SpinKitFadingCube(
          color: Colors.white,
          size: 50.0,
          controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
      ),
    );
  }
}