/*
{
  "plans": [
    {
    "name": "abc",
    "repeating_days": [0, 2, 4],
    "exercises": [
      {
        "type": 0,
        "descritption": "bla bla"
      },
      {
        "type": 1,
        "descritption": "bla bla",
        "time": 30
      }
      ]
    }
  ]
}
*/


import 'package:smart_coach/models/exercise.dart';


class TrainingPlan {
  int id = 0;
  String name = '';
  List<TrainingExercise> exercises = [];

  TrainingPlan({
    this.id = 0,
    required this.name,
    required this.exercises,
  });

  TrainingPlan.empty();

  factory TrainingPlan.from(TrainingPlan other) {
    List<TrainingExercise> exercises = [];
    for(TrainingExercise exercise in other.exercises) {
      exercises.add(TrainingExercise.from(exercise));
    }
    return TrainingPlan(
      id: other.id,
      name: other.name,
      exercises: exercises,
    );
  }

  List<Map<String, dynamic>> get exercisesJson {
    List<Map<String, dynamic>> result = [];

    for(var exercise in exercises) {
      result.add(exercise.toJson());
    }

    return result;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'exercises': exercisesJson,
  };

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    List<TrainingExercise> _exercises = [];
    for(Map<String, dynamic> exerciseJson in json['exercises']) {
      _exercises.add(TrainingExercise.fromJson(exerciseJson));
    }
    return TrainingPlan(
      name: json['name'],
      exercises: _exercises,
    );
  }
}