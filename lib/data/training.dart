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

class TrainingPlan {
  String name;
  List<int> repeating_days;
  List<TrainingExercise> exercises;

  TrainingPlan({required this.name, required this.repeating_days, required this.exercises});

  factory TrainingPlan.fromJson(Map plan) {
    TrainingPlan result = TrainingPlan(
        name: plan['name'],
        repeating_days: plan['repeating_days'],
        exercises: []
    );
    for(Map exercise in plan['exercises']) {
      switch(exercise['type']) {
        case 0:
          result.exercises.add(TrainingExercise.fromJson(exercise));
          break;
        case 1:
          result.exercises.add(TimedTrainingExercise.fromJson(exercise));
          break;
      }
    }
    return result;
  }
}

class TrainingExercise {
  final String description;

  TrainingExercise({required this.description});

  factory TrainingExercise.fromJson(Map exercise) {
    return TrainingExercise(description: exercise['description']);
  }
}

class TimedTrainingExercise extends TrainingExercise {
  final int time;

  TimedTrainingExercise({required String description, required this.time}) : super(description: description);

  factory TimedTrainingExercise.fromJson(Map exercise) {
    return TimedTrainingExercise(
      description: exercise['description'],
      time: exercise['time'],
    );
  }
}