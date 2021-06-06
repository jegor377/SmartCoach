import 'package:flutter/material.dart';
import 'package:smart_coach/data/training.dart';
import 'package:smart_coach/widgets/headline.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _trained_time = 65;
  List<TrainingPlan> plans = [
    TrainingPlan(
      name: "Normalny plan",
      repeating_days: [0, 2, 4],
      exercises: [
        TrainingExercise(description: "20 przysiadow"),
        TrainingExercise(description: "10 pompek"),
        TimedTrainingExercise(description: "30 sekund planka", time: 30),
      ],
    )
  ];

  void _incrementCounter() {
    setState(() {
      _trained_time++;
    });
  }

  String _getTimeSpentWorkingLabel() {
    int hours = _trained_time ~/ 60;
    return hours == 1 ? '1 hour' : '$hours hours';
  }

  @override
  Widget build(BuildContext context) {
    //plans = plans.isEmpty ? ModalRoute.of(context)!.settings.arguments as List<TrainingPlan> : plans;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: Colors.grey[850],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
            ),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Center(
                    child: Text(
                      'You have ${_getTimeSpentWorkingLabel()} spent training!',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
              ),
            ),
          ),
          Headline(text_content: 'Your training plans:'),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 100,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      print('TAP');
                    },
                    title: Text(plans[0].name, style: TextStyle(color: Colors.white),),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white,),
                      onPressed: () async {
                        bool result = await showDialog(
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
                        print(result);
                      },
                    ),
                    tileColor: Colors.grey[850],
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}