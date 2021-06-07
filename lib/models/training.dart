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
  List<dynamic> exercises = [];

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

  String get repeatingDays {
    List<String> days = [];
    if(repeatsOnMonday) days.add('Mon');
    if(repeatsOnTuesday) days.add('Tue');
    if(repeatsOnWednesday) days.add('Wed');
    if(repeatsOnThursday) days.add('Thu');
    if(repeatsOnFriday) days.add('Fri');
    if(repeatsOnSaturday) days.add('Sat');
    if(repeatsOnSunday) days.add('Sun');
    String result = days.join(', ');
    return result.isEmpty ? 'Never' : result;
  }

  RepeatingDaysScreenArguments get repeatingDaysScreenArgs => RepeatingDaysScreenArguments(
      repeatsOnMonday: repeatsOnMonday,
      repeatsOnTuesday: repeatsOnTuesday,
      repeatsOnWednesday: repeatsOnWednesday,
      repeatsOnThursday: repeatsOnThursday,
      repeatsOnFriday: repeatsOnFriday,
      repeatsOnSaturday: repeatsOnSaturday,
      repeatsOnSunday: repeatsOnSunday
  );

  set repeatingDaysScreenArgs(RepeatingDaysScreenArguments days) {
    repeatsOnMonday = days.repeatsOnMonday;
    repeatsOnTuesday = days.repeatsOnTuesday;
    repeatsOnWednesday = days.repeatsOnWednesday;
    repeatsOnThursday = days.repeatsOnThursday;
    repeatsOnFriday = days.repeatsOnFriday;
    repeatsOnSaturday = days.repeatsOnSaturday;
    repeatsOnSunday = days.repeatsOnSunday;
  }

  factory TrainingPlan.fromJson(Map plan) {
    TrainingPlan result = TrainingPlan.empty();
    for(Map exercise in plan['exercises']) {
      result.exercises.add(TrainingExercise.fromJson(exercise));
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

class RepeatingDaysScreenArguments {
  bool repeatsOnMonday = false;
  bool repeatsOnTuesday = false;
  bool repeatsOnWednesday = false;
  bool repeatsOnThursday = false;
  bool repeatsOnFriday = false;
  bool repeatsOnSaturday = false;
  bool repeatsOnSunday = false;

  RepeatingDaysScreenArguments({
    required this.repeatsOnMonday,
    required this.repeatsOnTuesday,
    required this.repeatsOnWednesday,
    required this.repeatsOnThursday,
    required this.repeatsOnFriday,
    required this.repeatsOnSaturday,
    required this.repeatsOnSunday,
  });

  RepeatingDaysScreenArguments.empty();
}

enum TrainingExerciseType {
  NORMAL,
  TIMED,
}

class TrainingExercise {
  TrainingExerciseType type = TrainingExerciseType.NORMAL;
  String description = '';
  int time = 0;

  TrainingExercise({
    required this.type,
    required this.description,
    this.time = 0
  });
  TrainingExercise.empty();

  String get timeLabel {
    int hours = time ~/ 3600;
    int minutes = (time % 3600) ~/ 60;
    int seconds = time % 60;
    String result = '';

    if(hours > 0) result += '${hours}h ';
    if(minutes > 0) result += '${minutes}m ';
    result += '${seconds}s';

    return result;
  }

  factory TrainingExercise.fromJson(Map exercise) {
    return TrainingExercise(
      type: TrainingExerciseType.values[exercise['type']],
      description: exercise['description'],
      time: exercise.containsKey('time') ? exercise['time'] : 0
    );
  }
}