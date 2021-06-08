import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:smart_coach/models/training.dart';

class TrainingScreen extends StatefulWidget {
  static const String routeName = '/training';

  const TrainingScreen({Key? key}) : super(key: key);

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final audioPlayer = AudioPlayer();
  TrainingPlan _plan = TrainingPlan.empty();
  final _pageController = PageController(
    initialPage: 0,
  );

  Widget buildExerciseNumberWidget(int number) => Padding(
    padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
    child: Text(
      'Exercise #$number',
      style: TextStyle(
          fontSize: 20.0
      ),
    ),
  );

  Widget buildExerciseTimer(TrainingExercise exercise, double timerRatioSize, CountDownController countdownController) => Padding(
    padding: EdgeInsets.fromLTRB(0, 40.0, 0, 0),
    child: CircularCountDownTimer(
      controller: countdownController,
      width: timerRatioSize,
      height: timerRatioSize,
      duration: exercise.time,
      //fillColor: Colors.green,
      fillColor: Colors.lightGreen,
      backgroundColor: Colors.grey.shade900,
      ringColor: Colors.green.shade900,
      autoStart: false,
      strokeWidth: 15.0,
      textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
        fontSize: 25.0,
      ),
      textFormat: CountdownTextFormat.HH_MM_SS,
      isReverse: true,
      strokeCap: StrokeCap.round,
      onComplete: () async {
        audioPlayer.setAsset('assets/plop.mp3').then((value) => audioPlayer.play());
      },
    ),
  );

  Widget buildExerciseDescription(TrainingExercise exercise) => Padding(
    padding: EdgeInsets.fromLTRB(0, 30.0, 0, 10.0),
    child: Center(
      child: Text(
        exercise.description,
        style: TextStyle(
          fontSize: 30.0,
        ),
      ),
    )
  );

  Widget buildExercisePage(TrainingExercise exercise, bool isLast, int index) {
    final countdownController = CountDownController();
    double timerRatioSize = min(
      MediaQuery.of(context).size.width / 1.5,
      MediaQuery.of(context).size.height / 1.5,
    );

    return Container(
      margin: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildExerciseNumberWidget(index + 1),
          Expanded(
            child: exercise.type == TrainingExerciseType.NORMAL ? ListView(
              children: [
                buildExerciseDescription(exercise),
              ],
            ) : ListView(
              children: [
                buildExerciseTimer(exercise, timerRatioSize, countdownController),
                buildExerciseDescription(exercise),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        countdownController.restart();
                        countdownController.pause();
                      },
                      icon: Icon(Icons.refresh),
                      iconSize: 45.0,
                    ),
                    IconButton(
                      onPressed: () {
                        countdownController.start();
                      },
                      icon: Icon(Icons.play_arrow),
                      iconSize: 45.0,
                    ),
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                child: isLast ? ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Finish'),
                ) : ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(duration: Duration(milliseconds: 100), curve: Curves.easeOut);
                  },
                  child: const Text('Next'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TrainingPlan? passedTrainingPlan = ModalRoute.of(context)!.settings.arguments as TrainingPlan?;
    _plan = passedTrainingPlan != null ? passedTrainingPlan : _plan;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          for(int i = 0; i < _plan.exercises.length; i++)
            buildExercisePage(_plan.exercises[i], i == _plan.exercises.length - 1, i)
        ],
      ),
    );
  }
}
