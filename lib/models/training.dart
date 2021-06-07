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
  String name = '';
  bool repeatsOnMonday = false;
  bool repeatsOnTuesday = false;
  bool repeatsOnWednesday = false;
  bool repeatsOnThursday = false;
  bool repeatsOnFriday = false;
  bool repeatsOnSaturday = false;
  bool repeatsOnSunday = false;
  List<TrainingExercise> exercises = [];

  TrainingPlan({
    required this.name,
    this.repeatsOnMonday = false,
    this.repeatsOnTuesday = false,
    this.repeatsOnWednesday = false,
    this.repeatsOnThursday = false,
    this.repeatsOnFriday = false,
    this.repeatsOnSaturday = false,
    this.repeatsOnSunday = false,
    required this.exercises,
  });

  TrainingPlan.empty();

  factory TrainingPlan.fromJson(Map plan) {
    TrainingPlan result = TrainingPlan.empty();
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
    result.name = plan['name'];
    for(int day in plan['repeating_days']) {
      switch(day) {
        case 0: // monday
          result.repeatsOnMonday = true;
          break;
        case 1: // tuesday
          result.repeatsOnTuesday = true;
          break;
        case 2: // wednesday
          result.repeatsOnWednesday = true;
          break;
        case 3: // thursday
          result. repeatsOnThursday = true;
          break;
        case 4: // friday
          result.repeatsOnFriday = true;
          break;
        case 5: // saturday
          result.repeatsOnSaturday = true;
          break;
        case 6: // sunday
          result.repeatsOnSunday = true;
          break;
      }
    }
    return result;
  }
}

class TrainingExercise {
  String description;

  TrainingExercise({this.description = ''});

  factory TrainingExercise.fromJson(Map exercise) {
    return TrainingExercise(description: exercise['description']);
  }
}

class TimedTrainingExercise extends TrainingExercise {
  int time;

  TimedTrainingExercise({String description = '', this.time = 0}) : super(description: description);

  factory TimedTrainingExercise.fromJson(Map exercise) {
    return TimedTrainingExercise(
      description: exercise['description'],
      time: exercise['time'],
    );
  }
}