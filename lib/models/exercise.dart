import 'dart:math';

enum TrainingExerciseType {
  normal,
  timed,
}

class TrainingExercise {
  static const int maxTime = 24 * 3600 + 59 * 60 + 59;
  String description = '';
  TrainingExerciseType type = TrainingExerciseType.normal;
  int _time = 0; // duration in seconds

  TrainingExercise({
    required this.description,
    this.type = TrainingExerciseType.normal,
    int time = 0,
  }) {
    this.time = time;
  }

  TrainingExercise.empty();

  factory TrainingExercise.from(TrainingExercise other) => TrainingExercise(
      description: other.description,
      type: other.type,
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

  Map<String, dynamic> toJson() => {
    'description': description,
    'time': time,
  };

  factory TrainingExercise.fromJson(Map<String, dynamic> json) => TrainingExercise(
    description: json['description'],
    type: json['time'] == 0 ? TrainingExerciseType.normal : TrainingExerciseType.timed,
    time: json['time'],
  );
}