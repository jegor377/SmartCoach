import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_coach/models/training.dart';
import 'package:smart_coach/screens/repeat_days_selector.dart';
import 'package:smart_coach/screens/training_exercise_setter.dart';

class TrainingPlanSetterScreen extends StatefulWidget {
  static const routeName = '/new_plan';

  const TrainingPlanSetterScreen({Key? key}) : super(key: key);

  @override
  _TrainingPlanSetterScreenState createState() => _TrainingPlanSetterScreenState();
}

class _TrainingPlanSetterScreenState extends State<TrainingPlanSetterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TrainingPlan _trainingPlan = TrainingPlan.empty();

  void _setRepeatDays() async {
    RepeatingDaysScreenArguments? result = await Navigator.pushNamed(
      context,
      RepeatDaysSelectorScreen.routeName,
      arguments: _trainingPlan.repeatingDaysScreenArgs,
    ) as RepeatingDaysScreenArguments?;
    setState(() {
      if(result != null && !identical(result, _trainingPlan.repeatingDaysScreenArgs)) {
        _trainingPlan.repeatingDaysScreenArgs = result;
      }
    });
  }

  void _reorderExercises(int oldIndex, int newIndex) {
    setState(() {
      if(oldIndex < newIndex) {
        newIndex -= 1;
      }
      final TrainingExercise plan = _trainingPlan.exercises.removeAt(oldIndex);
      _trainingPlan.exercises.insert(newIndex, plan);
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _trainingPlan.exercises.removeAt(index);
    });
  }

  Widget _getExerciseListTile(BuildContext context, int index) {
    TrainingExercise exercise = _trainingPlan.exercises[index];
    List<IconData> exerciseTypeIcons = [
      Icons.accessibility,
      Icons.timer,
    ];

    return ListTile(
      onTap: () async {
        TrainingExercise? changedExercise = await Navigator.pushNamed(
          context,
          TrainingExerciseSetterScreen.routeName,
          arguments: TrainingExercise.from(_trainingPlan.exercises[index])
        ) as TrainingExercise?;
        if(changedExercise != null) {
          _trainingPlan.exercises[index] = changedExercise;
        }
      },
      leading: Icon(
        exerciseTypeIcons[exercise.type.index],
      ),
      title: Text(_trainingPlan.exercises[index].description),
      subtitle: exercise.type == TrainingExerciseType.TIMED ? Text("Duration time: ${exercise.timeLabel}") : null,
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => _removeExercise(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TrainingPlan? newTrainingPlan = ModalRoute.of(context)!.settings.arguments as TrainingPlan?;
    _trainingPlan = newTrainingPlan != null ? newTrainingPlan : _trainingPlan;

    return Scaffold(
      appBar: AppBar(
        title: Text('Configure Training Plan'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Name",
                      hintText: "Enter training plan's name",
                    ),
                    initialValue: _trainingPlan.name,
                    onChanged: (value) => _trainingPlan.name = value,
                    validator: (String? value) {
                      if(value == null || value.isEmpty) {
                        return 'Please enter some name';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
                    child: const Text('Repeat days'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_trainingPlan.repeatingDays),
                      IconButton(
                        onPressed: _setRepeatDays,
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
                    child: const Text('Exercises'),
                  ),
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: _trainingPlan.exercises.length,
                    itemBuilder: (context, index) {
                      return Card(
                        key: ValueKey(index),
                        child: _getExerciseListTile(context, index),
                      );
                    },
                    onReorder: _reorderExercises,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                    child: ElevatedButton(
                      onPressed: () async {
                        TrainingExercise? newExercise = await Navigator.of(context).pushNamed(
                          TrainingExerciseSetterScreen.routeName
                        ) as TrainingExercise?;
                        if(newExercise != null) {
                          setState(() {
                            _trainingPlan.exercises.add(newExercise);
                          });
                        }
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                  Divider(),
                  ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        if(_trainingPlan.exercises.isNotEmpty) {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop(_trainingPlan);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Not enough exercises!'),
                                content: const Text('Please create at least one exercise'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK')
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}
