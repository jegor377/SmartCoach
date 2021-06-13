import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_coach/db/training_plans_db.dart';
import 'package:smart_coach/singletons/settings.dart';

class LoadingTrainingPlanScreen extends StatefulWidget {
  static const routeName = '/loading';

  const LoadingTrainingPlanScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingTrainingPlanScreenState();
}

class _LoadingTrainingPlanScreenState extends State<LoadingTrainingPlanScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    loadSettingsAndTrainingPlans();
    super.initState();
  }

  void loadSettingsAndTrainingPlans() async {
    await Settings.load();
    await TrainingPlansDB.init();
    await Navigator.pushReplacementNamed(context, '/home');
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
          color: Theme.of(context).textTheme.bodyText2!.color,
          size: 50.0,
          controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
      ),
    );
  }
}