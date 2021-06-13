import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_coach/db/training_plans_db.dart';
import 'package:smart_coach/models/exercise.dart';
import 'package:smart_coach/models/plan.dart';
import 'package:smart_coach/screens/training.dart';
import 'package:smart_coach/screens/training_plan_setter.dart';
import 'package:smart_coach/singletons/settings.dart';

class TrainingPlanInfoScreen extends StatefulWidget {
  static const String routeName = '/training_plan_info';

  const TrainingPlanInfoScreen({Key? key}) : super(key: key);

  @override
  _TrainingPlanInfoScreenState createState() => _TrainingPlanInfoScreenState();
}

class _TrainingPlanInfoScreenState extends State<TrainingPlanInfoScreen> {
  TrainingPlan _plan = TrainingPlan.empty();

  Timer _startTimer() => Timer.periodic(Duration(seconds: 1), (timer) {
    Settings.timeSpentWorking++;
  });
  
  Widget informationWidget(String text) => Padding(
    padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
    child: Text(
      text,
      style: TextStyle(
          fontSize: 20.0
      ),
    ),
  );
  
  Widget? exerciseSubtitle(TrainingExercise exercise) {
    if(exercise.type == TrainingExerciseType.timed) return Text('Duration time: ${exercise.timeLabel}');
    return null;
  }

  Widget exerciseListTile(TrainingExercise exercise) => ListTile(
    leading: Icon(exercise.type == TrainingExerciseType.timed ? Icons.timer : Icons.accessibility),
    title: Text(exercise.description),
    subtitle: exerciseSubtitle(exercise),
  );

  @override
  Widget build(BuildContext context) {
    TrainingPlan? plan = ModalRoute.of(context)!.settings.arguments as TrainingPlan?;
    _plan = plan != null ? plan : _plan;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Plan'),
        actions: [
          IconButton(
            onPressed: () async {
              bool? shouldRemove = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Remove Alert'),
                    content: const Text('Do you want to remove the plan?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('No'),
                      ),
                    ],
                  )
              );
              shouldRemove = shouldRemove == null ? false : shouldRemove;
              if(shouldRemove) {
                TrainingPlansDB.deletePlan(_plan.id);
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () async {
              TrainingPlan? changedTrainingPlan = await Navigator.of(context).pushNamed(
                TrainingPlanSetterScreen.routeName,
                arguments: _plan, // previous copy of
              ) as TrainingPlan?;
              if(changedTrainingPlan != null) setState(() {
                _plan = changedTrainingPlan;
                TrainingPlansDB.updatePlan(changedTrainingPlan);
              });
              //TrainingPlans.save();
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name'),
            informationWidget(_plan.name),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20.0, 0, 10.0),
              child: const Text('Exercises'),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _plan.exercises.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: exerciseListTile(_plan.exercises[index]),
                    );
                  }
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      Timer timer = _startTimer();
                      await Navigator.of(context).pushNamed(
                        TrainingScreen.routeName,
                        arguments: _plan,
                      );
                      timer.cancel();
                      Settings.save();
                    },
                    child: const Text('START'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}