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

import 'dart:math';


enum TrainingExerciseType {
  NORMAL,
  TIMED,
}

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

  List<int> get repeatingDaysList {
    List<int> result = [];

    if(repeatsOnMonday) result.add(0);
    if(repeatsOnTuesday) result.add(1);
    if(repeatsOnWednesday) result.add(2);
    if(repeatsOnThursday) result.add(3);
    if(repeatsOnFriday) result.add(4);
    if(repeatsOnSaturday) result.add(5);
    if(repeatsOnSunday) result.add(6);

    return result;
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

  List<Map<String, dynamic>> get exercisesJsonList {
    List<Map<String, dynamic>> result = [];

    for(TrainingExercise exercise in exercises) {
      result.add(exercise.toJson());
    }

    return result;
  }

  factory TrainingPlan.from(TrainingPlan other) {
    List<TrainingExercise> exercises = [];
    for(TrainingExercise exercise in other.exercises) {
      exercises.add(TrainingExercise.from(exercise));
    }
    return TrainingPlan(
        name: other.name,
        repeatsOnMonday: other.repeatsOnMonday,
        repeatsOnTuesday: other.repeatsOnTuesday,
        repeatsOnWednesday: other.repeatsOnWednesday,
        repeatsOnThursday: other.repeatsOnThursday,
        repeatsOnFriday: other.repeatsOnFriday,
        repeatsOnSaturday: other.repeatsOnSaturday,
        repeatsOnSunday: other.repeatsOnSunday,
        exercises: exercises
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'repeating_days': repeatingDaysList,
    'exercises': exercisesJsonList,
  };

  factory TrainingPlan.fromJson(Map<String, dynamic> plan) {
    TrainingPlan result = TrainingPlan.empty();
    for(Map<String, dynamic> exercise in plan['exercises']) {
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

class TrainingExercise {
  static const int maxTime = 24 * 3600 + 59 * 60 + 59;
  TrainingExerciseType type = TrainingExerciseType.NORMAL;
  String description = '';
  int _time = 0; // duration in seconds

  TrainingExercise({
    required this.type,
    required this.description,
    int time = 0
  }) {
    this.time = time;
  }
  TrainingExercise.empty();
  factory TrainingExercise.from(TrainingExercise other) => TrainingExercise(
      type: other.type,
      description: other.description,
      time: other.time
  );

  int get time => _time;

  set time(int value) {
    _time = min(value, maxTime);
  }

  int get seconds => time % 60;
  int get minutes => (time % 3600) ~/ 60;
  int get hours => time ~/ 3600;

  set seconds(int value) {
    time = hours * 3600 + minutes * 60 + value;
    time = min(time, maxTime);
  }

  set minutes(int value) {
    time = hours * 3600 + value * 60 + seconds;
    time = min(time, maxTime);
  }

  set hours(int value) {
    time = value * 3600 + minutes * 60 + seconds;
    time = min(time, maxTime);
  }

  String get timeLabel {
    String result = '';

    if(time != 0) {
      if(hours > 0) result += '${hours}h ';
      if(minutes > 0) result += '${minutes}m ';
      if(seconds > 0) result += '${seconds}s';
    } else {
      result += '${seconds}s';
    }

    return result;
  }

  Map<String, dynamic> toJson() {
    if(type == TrainingExerciseType.TIMED) return {
      'type': type.index,
      'description': description,
      'time': time,
    };
    return {
      'type': type.index,
      'description': description,
    };
  }

  factory TrainingExercise.fromJson(Map<String, dynamic> exercise) {
    return TrainingExercise(
        type: TrainingExerciseType.values[exercise['type']],
        description: exercise['description'],
        time: exercise.containsKey('time') ? exercise['time'] : 0
    );
  }
}

class TrainingPlanScreenArguments {
  TrainingPlan plan = TrainingPlan.empty();
  int index = 0;

  TrainingPlanScreenArguments({
    required this.plan,
    required this.index
  });
  TrainingPlanScreenArguments.empty();
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