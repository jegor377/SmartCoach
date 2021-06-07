import 'package:flutter/material.dart';
import 'package:smart_coach/models/training.dart';

class CreatingTrainingPlanScreen extends StatefulWidget {
  static const routeName = '/new_plan';

  const CreatingTrainingPlanScreen({Key? key}) : super(key: key);

  @override
  _CreatingTrainingPlanScreenState createState() => _CreatingTrainingPlanScreenState();
}

class _CreatingTrainingPlanScreenState extends State<CreatingTrainingPlanScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _trainingPlan = TrainingPlan.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Training Plan'),
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
                  CheckboxListTile(
                      title: const Text('Monday'),
                      value: _trainingPlan.repeatsOnMonday,
                      onChanged: (bool? val) {
                        setState(() {
                          _trainingPlan.repeatsOnMonday = val != null ? val : false;
                        });
                      }
                  ),
                  CheckboxListTile(
                      title: const Text('Tuesday'),
                      value: _trainingPlan.repeatsOnTuesday,
                      onChanged: (bool? val) {
                        setState(() {
                          _trainingPlan.repeatsOnTuesday = val != null ? val : false;
                        });
                      }
                  ),
                  CheckboxListTile(
                      title: const Text('Wednesday'),
                      value: _trainingPlan.repeatsOnWednesday,
                      onChanged: (bool? val) {
                        setState(() {
                          _trainingPlan.repeatsOnWednesday = val != null ? val : false;
                        });
                      }
                  ),
                  CheckboxListTile(
                      title: const Text('Thursday'),
                      value: _trainingPlan.repeatsOnThursday,
                      onChanged: (bool? val) {
                        setState(() {
                          _trainingPlan.repeatsOnThursday = val != null ? val : false;
                        });
                      }
                  ),
                  CheckboxListTile(
                      title: const Text('Friday'),
                      value: _trainingPlan.repeatsOnFriday,
                      onChanged: (bool? val) {
                        setState(() {
                          _trainingPlan.repeatsOnFriday = val != null ? val : false;
                        });
                      }
                  ),
                  CheckboxListTile(
                      title: const Text('Saturday'),
                      value: _trainingPlan.repeatsOnSaturday,
                      onChanged: (bool? val) {
                        setState(() {
                          _trainingPlan.repeatsOnSaturday = val != null ? val : false;
                        });
                      }
                  ),
                  CheckboxListTile(
                      title: const Text('Sunday'),
                      value: _trainingPlan.repeatsOnSunday,
                      onChanged: (bool? val) {
                        setState(() {
                          _trainingPlan.repeatsOnSunday = val != null ? val : false;
                        });
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          print("VALID");
                        }
                      },
                      child: const Text('Create'),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}
