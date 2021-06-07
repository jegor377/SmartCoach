import 'package:flutter/material.dart';
import 'package:smart_coach/models/training.dart';
import 'package:smart_coach/screens/creating_training_plan.dart';
import 'package:smart_coach/widgets/headline.dart';

class HomePageScreen extends StatefulWidget {
  static const routeName = '/home';

  HomePageScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _trainedTime = 65;
  List<TrainingPlan> _plans = [
    TrainingPlan(
        name: "Normalny plan",
        repeatsOnFriday: true,
        repeatsOnWednesday: true,
        repeatsOnMonday: true,
        exercises: [
          TrainingExercise(
            type: TrainingExerciseType.NORMAL,
            description: "20 przysiadow"
          ),
          TrainingExercise(
            type: TrainingExerciseType.NORMAL,
            description: "10 pompek"
          ),
          TrainingExercise(
            type: TrainingExerciseType.TIMED,
            description: "30s planka",
            time: 30
          ),
        ]
    ),
    TrainingPlan(
        name: "Lol plan",
        repeatsOnFriday: true,
        repeatsOnWednesday: true,
        repeatsOnMonday: true,
        exercises: [
          TrainingExercise(
              type: TrainingExerciseType.NORMAL,
              description: "20 przysiadow"
          ),
          TrainingExercise(
              type: TrainingExerciseType.NORMAL,
              description: "10 pompek"
          ),
          TrainingExercise(
              type: TrainingExerciseType.TIMED,
              description: "30s planka",
              time: 30
          ),
        ]
    ),
    TrainingPlan(
        name: "Nienormalny plan",
        repeatsOnFriday: true,
        repeatsOnWednesday: true,
        repeatsOnMonday: true,
        exercises: [
          TrainingExercise(
              type: TrainingExerciseType.NORMAL,
              description: "20 przysiadow"
          ),
          TrainingExercise(
              type: TrainingExerciseType.NORMAL,
              description: "10 pompek"
          ),
          TrainingExercise(
              type: TrainingExerciseType.TIMED,
              description: "30s planka",
              time: 30
          ),
        ]
    )
  ];

  void _newTrainingPlan() {
    Navigator.pushNamed(
      context,
      CreatingTrainingPlanScreen.routeName,
    );
  }

  String _getTimeSpentWorkingLabel() {
    int hours = _trainedTime ~/ 60;
    return hours == 1 ? '1 hour' : '$hours hours';
  }

  void _reorderPlans(int oldIndex, int newIndex) {
    setState(() {
      if(oldIndex < newIndex) {
        newIndex -= 1;
      }
      final TrainingPlan plan = _plans.removeAt(oldIndex);
      _plans.insert(newIndex, plan);
    });
  }

  void _removePlan(int index) {
    setState(() {
      _plans.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Center(
                    child: Text(
                      'You have ${_getTimeSpentWorkingLabel()} spent training!'
                    ),
                  )
              ),
            ),
          ),
          Headline(textContent: 'Your training plans'),
          Expanded(
            child: ReorderableListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              onReorder: _reorderPlans,
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                return Card(
                  key: ValueKey(index),
                  child: ListTile(
                    onTap: () {
                      print('TAP $index');
                    },
                    leading: Icon(Icons.play_arrow),
                    title: Text(_plans[index].name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
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
                          _removePlan(index);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newTrainingPlan,
        tooltip: 'Create new training plan',
        child: Icon(Icons.add),
      ),
    );
  }
}