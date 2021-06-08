import 'package:flutter/material.dart';
import 'package:smart_coach/models/training.dart';
import 'package:smart_coach/screens/contact.dart';
import 'package:smart_coach/screens/training_plan_info.dart';
import 'package:smart_coach/screens/training_plan_setter.dart';
import 'package:smart_coach/singletons/settings.dart';
import 'package:smart_coach/singletons/training_plans.dart';
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

  void _newTrainingPlan() async {
    TrainingPlan? _newTrainingPlan = await Navigator.pushNamed(
      context,
      TrainingPlanSetterScreen.routeName,
    ) as TrainingPlan?;
    if(_newTrainingPlan != null) {
      setState(() {
        TrainingPlans.plans.add(_newTrainingPlan);
        TrainingPlans.save();
      });
    }
  }

  void _reorderPlans(int oldIndex, int newIndex) {
    setState(() {
      TrainingPlans.reorderPlans(oldIndex, newIndex);
      TrainingPlans.save();
    });
  }

  void _removePlan(int index) {
    setState(() {
      TrainingPlans.plans.removeAt(index);
      TrainingPlans.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue
              ),
              child: Text(widget.title),
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
                print('Settings');
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
              itemCount: TrainingPlans.plans.length,
              itemBuilder: (context, index) {
                return Card(
                  key: ValueKey(index),
                  child: ListTile(
                    onTap: () async {
                      Navigator.of(context).pushNamed(
                        TrainingPlanInfoScreen.routeName,
                        arguments: TrainingPlanScreenArguments(
                            plan: TrainingPlan.from(TrainingPlans.plans[index]),
                            index: index
                        ),
                      ).then((_) => setState((){}));
                    },
                    leading: Icon(Icons.play_arrow),
                    title: Text(TrainingPlans.plans[index].name),
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