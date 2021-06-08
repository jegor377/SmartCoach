import 'package:flutter/material.dart';
import 'package:smart_coach/screens/contact.dart';
import 'package:smart_coach/screens/training.dart';
import 'package:smart_coach/screens/training_plan_info.dart';
import 'package:smart_coach/screens/training_plan_setter.dart';
import 'package:smart_coach/screens/home.dart';
import 'package:smart_coach/screens/loading.dart';
import 'package:smart_coach/screens/repeat_days_selector.dart';
import 'package:smart_coach/screens/training_exercise_setter.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartCoach',
      initialRoute: LoadingTrainingPlanScreen.routeName,
      theme: ThemeData.dark(),
      routes: {
        HomePageScreen.routeName: (context) => HomePageScreen(title: "SmartCoach"),
        LoadingTrainingPlanScreen.routeName: (context) => LoadingTrainingPlanScreen(),
        TrainingPlanSetterScreen.routeName: (context) => TrainingPlanSetterScreen(),
        RepeatDaysSelectorScreen.routeName: (context) => RepeatDaysSelectorScreen(),
        TrainingExerciseSetterScreen.routeName: (context) => TrainingExerciseSetterScreen(),
        TrainingPlanInfoScreen.routeName: (context) => TrainingPlanInfoScreen(),
        TrainingScreen.routeName: (context) => TrainingScreen(),
        ContactScreen.routeName: (context) => ContactScreen(),
      },
    );
  }
}