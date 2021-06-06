import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_coach/data/training.dart';
import 'package:smart_coach/pages/home.dart';
import 'package:smart_coach/pages/loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartCoach',
      initialRoute: '/loading',
      routes: {
        '/home': (context) => HomePage(title: "SmartCoach"),
        '/loading': (context) => LoadingTrainingPlan()
      },
    );
  }
}