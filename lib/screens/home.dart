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
  int _trained_time = 65;
  List<TrainingPlan> plans = [
    TrainingPlan(
      name: "Normalny plan",
      repeatsOnMonday: true,
      repeatsOnTuesday: true,
      repeatsOnFriday: true,
      exercises: [
        TrainingExercise(description: "20 przysiadow"),
        TrainingExercise(description: "10 pompek"),
        TimedTrainingExercise(description: "30 sekund planka", time: 30),
      ],
    )
  ];

  void _newTrainingPlan() {
    // setState(() {
    //   _trained_time++;
    // });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatingTrainingPlanScreen()),
    );
  }

  String _getTimeSpentWorkingLabel() {
    int hours = _trained_time ~/ 60;
    return hours == 1 ? '1 hour' : '$hours hours';
  }

  @override
  Widget build(BuildContext context) {
    //plans = plans.isEmpty ? ModalRoute.of(context)!.settings.arguments as List<TrainingPlan> : plans;

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
          Headline(text_content: 'Your training plans'),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 100,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTileTheme(
                    child: ListTile(
                      onTap: () {
                        print('TAP');
                      },
                      leading: Icon(Icons.play_arrow),
                      title: Text(plans[0].name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          bool? result = await showDialog<bool>(
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
                          result = result == null ? false : result;
                          print(result);
                        },
                      ),
                    ),
                  )
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