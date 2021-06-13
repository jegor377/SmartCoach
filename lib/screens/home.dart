import 'package:flutter/material.dart';
import 'package:smart_coach/db/training_plans_db.dart';
import 'package:smart_coach/models/plan.dart';
import 'package:smart_coach/screens/contact.dart';
import 'package:smart_coach/screens/settings.dart';
import 'package:smart_coach/screens/training_plan_info.dart';
import 'package:smart_coach/screens/training_plan_setter.dart';
import 'package:smart_coach/singletons/settings.dart';
import 'package:smart_coach/widgets/headline.dart';

class HomePageScreen extends StatefulWidget {
  static const routeName = '/home';

  HomePageScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String _getTimeSpentWorkingLabel() {
    int hours = Settings.timeSpentWorking ~/ 3600;
    return hours == 1 ? '1 hour' : '$hours hours';
  }

  Future _newTrainingPlan() async {
    TrainingPlan? _newTrainingPlan = await Navigator.pushNamed(
      context,
      TrainingPlanSetterScreen.routeName,
    ) as TrainingPlan?;
    if(_newTrainingPlan != null) {
      await TrainingPlansDB.createPlan(_newTrainingPlan);
      setState(() {});
    }
  }

  Future _reorderPlans(int oldIndex, int newIndex) async {
    await TrainingPlansDB.reorderPlans(oldIndex, newIndex);
    setState(() {});
  }

  Future _removePlan(int id) async {
    await TrainingPlansDB.deletePlan(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SmartCoach"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.blue
              ),
              child: Text('SmartCoach'),
            ),
            ListTile(
              title: const Text('Contact'),
              onTap: () {
                Navigator.of(context).pushNamed(ContactScreen.routeName);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pushNamed(SettingsScreen.routeName);
              },
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              itemCount: TrainingPlansDB.plans.length,
              itemBuilder: (context, index) {
                return Card(
                  key: ValueKey(index),
                  child: ListTile(
                    onTap: () async {
                      await Navigator.of(context).pushNamed(
                        TrainingPlanInfoScreen.routeName,
                        arguments: TrainingPlan.from(TrainingPlansDB.plans[index]),
                      );
                      setState(() {});
                    },
                    leading: Icon(Icons.play_arrow),
                    title: Text(TrainingPlansDB.plans[index].name),
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
                          _removePlan(TrainingPlansDB.plans[index].id);
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