import 'package:flutter/material.dart';
import 'package:smart_coach/screens/creating_training_plan.dart';
import 'package:smart_coach/screens/home.dart';
import 'package:smart_coach/screens/loading.dart';

void main() {
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
        CreatingTrainingPlanScreen.routeName: (context) => CreatingTrainingPlanScreen(),
      },
    );
  }
}